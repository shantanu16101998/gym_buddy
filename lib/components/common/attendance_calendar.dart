import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/constants/environment.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class AttendanceCalendar extends StatefulWidget {
  final String? customerId;
  const AttendanceCalendar({super.key, this.customerId});

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  final PageController _pageController =
      PageController(initialPage: DateTime.now().month);

  int minMonth = 0;
  int maxMonth = 12;
  int minYear = 1900;
  int maxYear = 2100;
  int startDay = 1;

  AttendanceResponse? attendanceResponse;

  fetchAttendance() async {
    if (appEnvironment == AppEnvironment.member) {
      Map<String, dynamic> responseData = await backendAPICall(
          '/attendance/getLifeTimeAttendance', {}, 'GET', true);

      setState(() {
        attendanceResponse = AttendanceResponse.fromJson(responseData['data']);
        minMonth = getShortMonthNumber(
                responseData['startMonth'].toString().toLowerCase()) ??
            0;
        startDay = responseData['startDay'] ?? 1;
        maxMonth = getShortMonthNumber(
                responseData['endMonth'].toString().toLowerCase()) ??
            12;
        minYear = responseData['startYear'];
        maxYear = responseData['endYear'];
      });
    } else {
      Map<String, dynamic> responseData = await backendAPICall(
          '/attendance/${widget.customerId}/getLifeTimeAttendance',
          {},
          'GET',
          true);

      setState(() {
        attendanceResponse = AttendanceResponse.fromJson(responseData['data']);
        minMonth = getShortMonthNumber(
                responseData['startMonth'].toString().toLowerCase()) ??
            0;
        startDay = responseData['startDay'] ?? 1;
        maxMonth = getShortMonthNumber(
                responseData['endMonth'].toString().toLowerCase()) ??
            12;
        minYear = responseData['startYear'];
        maxYear = responseData['endYear'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAttendance();
  }

  int year = DateTime.now().year;
  int currentMonth = DateTime.now().month;

  double mainAxisSpacing = 12.0;

  int getStartingDayOfMonth(int year, int month) {
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    return firstDayOfMonth.weekday % 7;
  }

  int getDaysInMonth(int year, int month) {
    DateTime firstDayNextMonth;
    if (month == 12) {
      firstDayNextMonth = DateTime(year + 1, 1, 1);
    } else {
      firstDayNextMonth = DateTime(year, month + 1, 1);
    }
    DateTime lastDayOfMonth =
        firstDayNextMonth.subtract(const Duration(days: 1));
    return lastDayOfMonth.day;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 50,
              left: getScreenWidth(context) * 0.1,
              right: getScreenWidth(context) * 0.1),
          child: SizedBox(
            height: 400,
            width: double.infinity,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentMonth = index;
                });
              },
              itemBuilder: (context, index) {
                int displayMonth = (index % 12);
                int displayYear = year + (index ~/ 12);

                int startingDayOfMonth =
                    getStartingDayOfMonth(displayYear, displayMonth);

                int daysInMonth = getDaysInMonth(displayYear, displayMonth);

                List<Color> attendanceColors = [];

                if (attendanceResponse != null) {
                  MonthData? monthData = attendanceResponse!.attendanceData
                      .firstWhere(
                          (monthData) =>
                              getShortMonthNumber(
                                      monthData.month.toLowerCase()) ==
                                  displayMonth &&
                              displayYear == monthData.year,
                          orElse: () =>
                              MonthData(year: 0, month: '', days: []));

                  int i = 0;

                  if (displayMonth == minMonth) {
                    for (i = 0; i < startDay - 1; i++) {
                      attendanceColors.add(attendanceMarkNothing);
                    }
                  }

                  for (; i < monthData.days.length; i++) {
                    if (monthData.days[i] == 1) {
                      attendanceColors.add(attendanceMarkPresent);
                    } else {
                      attendanceColors.add(attendanceMarkAbsent);
                    }
                  }

                  for (; i < daysInMonth; i++) {
                    attendanceColors.add(attendanceMarkNothing);
                  }
                } else {
                  attendanceColors = [
                    for (int i = 0; i < daysInMonth; i++) attendanceMarkNothing
                  ];
                }

                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: mainAxisSpacing,
                      crossAxisSpacing: mainAxisSpacing,
                    ),
                    itemCount: 42,
                    itemBuilder: (context, index) {
                      if (index < 7) {
                        return Container(
                          alignment: Alignment.bottomCenter,
                          child: CustomText(text: weekDays[index]),
                        );
                      }
                      // + 7 will be added as offset
                      else if (index < startingDayOfMonth - 1 + 7 ||
                          index >= startingDayOfMonth + daysInMonth + 6) {
                        // Empty cells for the start and end of the calendar
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        );
                      } else {
                        int dayNumber = index -
                            (startingDayOfMonth - 1) -
                            6; // Adjusted for header

                        return Container(
                          decoration: BoxDecoration(
                            color: attendanceColors[dayNumber - 1],
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(monthNames[currentMonth],
                  style: const TextStyle(
                      color: primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: (minYear < year || minMonth < currentMonth)
                            ? primaryColor
                            : primaryColor.withOpacity(0.5)),
                    onPressed: () {
                      if (minYear < year || minMonth < currentMonth) {
                        setState(() {
                          currentMonth--;
                          if (currentMonth < 0) {
                            currentMonth = 11;
                            year--;
                          }
                          _pageController.animateToPage(
                            currentMonth,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward,
                        color: (maxYear > year || maxMonth > currentMonth)
                            ? primaryColor
                            : primaryColor.withOpacity(0.5)),
                    onPressed: () {
                      if (maxMonth > currentMonth || maxYear > year) {
                        setState(() {
                          currentMonth++;
                          if (currentMonth > 11) {
                            currentMonth = 0;
                            year++;
                          }
                          _pageController.animateToPage(
                            currentMonth,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
