import 'package:flutter/material.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        double attendanceBoxSize =
            (constraints.maxWidth - 8 * mainAxisSpacing) / 7;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(monthNames[currentMonth - 1],
                      style: const TextStyle(
                          color: Color(0xff004576),
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back,
                            color: Color(0xff004576)),
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
            Container(
              width: 390,
              color: Colors.black54,  
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Center(child: Text('Mon'))),
                    Expanded(child: Center(child: Text('Tue'))),
                    Expanded(child: Center(child: Text('Wed'))),
                    Expanded(child: Center(child: Text('Thu'))),
                    Expanded(child: Center(child: Text('Fri'))),
                    Expanded(child: Center(child: Text('Sat'))),
                    Expanded(child: Center(child: Text('Sun'))),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16),
              child: Container(
                color: Colors.brown,
                height: 250,
                width: 350,
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

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: mainAxisSpacing,
                        crossAxisSpacing: mainAxisSpacing,
                      ),
                      itemCount: 42, // 6 weeks to cover the full month
                      itemBuilder: (context, index) {
                        if (index < startingDayOfMonth - 1 ||
                            index >= startingDayOfMonth + daysInMonth - 1) {
                          // Empty cells for the start and end of the calendar
                          return Container(
                            height: attendanceBoxSize,
                            width: attendanceBoxSize,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(233, 107, 7, 7),
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          );
                        } else {
                          return Container(
                            height: attendanceBoxSize,
                            width: attendanceBoxSize,
                            decoration: BoxDecoration(
                              color: attendanceColors[
                                  index - (startingDayOfMonth - 1)],
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
