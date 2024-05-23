import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/utils/custom.dart';

class AttendanceCalendar extends StatefulWidget {
  const AttendanceCalendar({super.key});

  @override
  State<AttendanceCalendar> createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  final PageController _pageController =
      PageController(initialPage: DateTime.now().month);

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
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: SizedBox(
            height: 400,
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


                final List<Color> attendanceColors = [
                  for (int i = 0; i < daysInMonth; i++) const Color(0xffD9D9D9)
                ];
                return Container(
                  child: GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
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
                      color: Color(0xff004576),
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xff004576)),
                    onPressed: () {
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
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward,
                        color: Color(0xff004576)),
                    onPressed: () {
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
