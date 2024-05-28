import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceBar extends StatefulWidget {
  const AttendanceBar({super.key});

  @override
  State<AttendanceBar> createState() => _AttendanceBarState();
}

class _AttendanceBarState extends State<AttendanceBar> {
  final tabBarWidth = 50.0;
  final tabBarHeight = 50.0;

  final circleWidth = 25.0;
  final iconSize = 30.0;

  int currentWeekDay = DateTime.now().weekday;
  AttendanceStatus attendanceStatus =
      AttendanceStatus.notLocationPermissionGiven;

  Widget grantLocationPermissionWidget() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: CustomText(
            text: 'Please grant location permission for attendance',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: headingColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: OutlinedButton(
              onPressed: () async {
                bool verdict = await getCurrentLocationSuccess();

                if (verdict) {
                  if (await userInGym()) {
                    setState(() {
                      attendanceStatus = AttendanceStatus.present;
                    });
                  } else {
                    setState(() {
                      attendanceStatus = AttendanceStatus.notInsideGym;
                    });
                  }
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  side: const BorderSide(width: 1, color: Colors.black)),
              child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text("Grant Location Permission",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)))),
        )
      ],
    );
  }

  Widget attendanceMarkedWidget() {
    return Container(
      height: 90,
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: CustomText(
              text: 'Attendance is marked successfully',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: headingColor,
            ),
          )
        ],
      ),
    );
  }

  Widget userNotInLocationWidget() {
    return const SizedBox(
      height: 100,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: CustomText(
              text: 'Please go inside gym to mark attendance',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: headingColor,
            ),
          )
        ],
      ),
    );
  }

  userInGym() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var locationLat = sharedPreferences.getDouble('latitude') ?? 0;
    var locationLon = sharedPreferences.getDouble('longitude') ?? 0;

    double distanceBetweenGymAndPerson = calculateDistanceInKm(
        locationLat, locationLon, 12.934171901523671, 77.614341250971);

    if (distanceBetweenGymAndPerson < 0.05) {
      return true;
    } else {
      return false;
    }
  }

  onAttendanceButtonClicked(int weekDay, BuildContext context) async {
    if (weekDay == currentWeekDay) {
      bool verdict = await getCurrentLocationSuccess();

      if (verdict) {
        if (attendanceStatus != AttendanceStatus.present) {
          if (await userInGym()) {
            setState(() {
              attendanceStatus = AttendanceStatus.present;
            });
          } else {
            setState(() {
              attendanceStatus = AttendanceStatus.notInsideGym;
            });
          }
        }
      } else {
        setState(() {
          attendanceStatus = AttendanceStatus.notLocationPermissionGiven;
        });
      }
      if (mounted) {
        _showAlertDialog();
      }
    }
  }

  void _showAlertDialog() async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              width: double.infinity,
              color: Colors.white,
              child: attendanceStatus ==
                      AttendanceStatus.notLocationPermissionGiven
                  ? grantLocationPermissionWidget()
                  : attendanceStatus == AttendanceStatus.present
                      ? attendanceMarkedWidget()
                      : userNotInLocationWidget());
        });
  }

// for absent

// Container(
//                     height: circleWidth,
//                     width: circleWidth,
//                     decoration: BoxDecoration(
//                         color: const Color(0xffE46A6A),
//                         borderRadius:
//                             BorderRadius.all(Radius.circular(circleWidth))),
//                     child: const Icon(
//                       Icons.close,
//                       color: Colors.white,
//                     ),
//                   ),

  Widget decideIcon(int weekDay) {
    if (weekDay == currentWeekDay) {
      if (attendanceStatus == AttendanceStatus.present) {
        return Icon(
          Icons.check_circle,
          size: iconSize,
          color: const Color(0xff3ABA2E),
        );
      }
    }
    return Container(
        width: circleWidth,
        height: circleWidth,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(circleWidth))),
        child: const Icon(Icons.check));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: CustomText(
                text: 'Mon',
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: getScreenWidth(context) * 0.12,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  color: currentWeekDay == 1
                      ? Colors.white
                      : const Color.fromARGB(255, 235, 238, 241),
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(10)),
                  border: Border.all(width: 1, color: const Color(0xffD0D5DD))),
              child: Center(child: decideIcon(1)),
            ),
          ],
        ),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: CustomText(
                text: 'Tue',
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
                onTap: () {
                  onAttendanceButtonClicked(2, context);
                },
                child: Container(
                    width: getScreenWidth(context) * 0.12,
                    height: tabBarHeight,
                    decoration: BoxDecoration(
                        color: currentWeekDay == 2
                            ? Colors.white
                            : const Color.fromARGB(255, 235, 238, 241),
                        border: Border.all(
                            width: 1, color: const Color(0xffD0D5DD))),
                    child: Center(child: decideIcon(2)))),
          ],
        ),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: CustomText(
                text: 'Wed',
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: getScreenWidth(context) * 0.12,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: const Color(0xffD0D5DD)),
                  color: currentWeekDay == 3
                      ? Colors.white
                      : const Color.fromARGB(255, 235, 238, 241)),
              child: Center(
                  // Centering the inner container
                  child: decideIcon(3)),
            ),
          ],
        ),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: CustomText(
                text: 'Thu',
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: getScreenWidth(context) * 0.12,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  color: currentWeekDay == 4
                      ? Colors.white
                      : const Color.fromARGB(255, 235, 238, 241),
                  border: Border.all(width: 1, color: const Color(0xffD0D5DD))),
              child: Center(
                // Centering the inner container
                child: decideIcon(4),
              ),
            ),
          ],
        ),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: CustomText(
                text: 'Fri',
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: getScreenWidth(context) * 0.12,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  color: currentWeekDay == 5
                      ? Colors.white
                      : const Color.fromARGB(255, 235, 238, 241),
                  border: Border.all(width: 1, color: const Color(0xffD0D5DD))),
              child: Center(
                  // Centering the inner container
                  child: decideIcon(5)),
            ),
          ],
        ),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: CustomText(
                text: 'Sat',
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                onAttendanceButtonClicked(6, context);
              },
              child: Container(
                width: getScreenWidth(context) * 0.12,
                height: tabBarHeight,
                decoration: BoxDecoration(
                    color: currentWeekDay == 6
                        ? Colors.white
                        : const Color.fromARGB(255, 235, 238, 241),
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD))),
                child: Center(
                  // Centering the inner container
                  child: decideIcon(6),
                ),
              ),
            ),
          ],
        ),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: CustomText(
                text: 'Sun',
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: getScreenWidth(context) * 0.12,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  color: currentWeekDay == 7
                      ? Colors.white
                      : const Color.fromARGB(255, 235, 238, 241),
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(10)),
                  border: Border.all(width: 1, color: const Color(0xffD0D5DD))),
              child: Center(
                // Centering the inner container
                child: decideIcon(7),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
