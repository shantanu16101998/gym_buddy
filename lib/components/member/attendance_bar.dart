import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceBar extends StatefulWidget {
  final String attendanceString;
  final num gymLocationLat;
  final num gymLocationLon;
  const AttendanceBar(
      {super.key,
      required this.attendanceString,
      required this.gymLocationLat,
      required this.gymLocationLon});

  @override
  State<AttendanceBar> createState() => _AttendanceBarState();
}

class _AttendanceBarState extends State<AttendanceBar> {
  final tabBarWidth = 50.0;
  final tabBarHeight = 50.0;

  final circleWidth = 25.0;
  final iconSize = 30.0;

  List<int> attendanceList = [];

  int currentWeekDay = DateTime.now().weekday;
  AttendanceStatus attendanceStatus =
      AttendanceStatus.notLocationPermissionGiven;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < 7; i++) {
      if (i > widget.attendanceString.length - 1) {
        attendanceList.add(0);
      } else if (widget.attendanceString[i] == '0') {
        attendanceList.add(-1);
      } else {
        attendanceList.add(1);
      }
    }

    if (attendanceList[currentWeekDay - 1] == 1) {
      setState(() {
        attendanceStatus = AttendanceStatus.present;
      });
    }
  }

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
                  if (mounted) {
                    Navigator.pop(context);
                  }
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
      height: 110,
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
        locationLat,
        locationLon,
        widget.gymLocationLat.toDouble(),
        widget.gymLocationLon.toDouble());

    if (distanceBetweenGymAndPerson < 0.05) {
      return true;
    } else {
      return false;
    }
  }

  onAttendanceButtonClicked(int weekDay, BuildContext context) async {
    if (weekDay == currentWeekDay &&
        attendanceStatus != AttendanceStatus.present) {
      print("mama ric");
      bool verdict = await getCurrentLocationSuccess();

      if (verdict) {
        if (attendanceStatus != AttendanceStatus.present) {
          if (await userInGym()) {
            setState(() {
              attendanceStatus = AttendanceStatus.present;

              backendAPICall('/customer/markAttendance', {}, 'POST', true);
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

  Widget absentContainer() {
    return Container(
      height: circleWidth,
      width: circleWidth,
      decoration: BoxDecoration(
          color: const Color(0xffE46A6A),
          borderRadius: BorderRadius.all(Radius.circular(circleWidth))),
      child: const Icon(
        Icons.close,
        color: Colors.white,
      ),
    );
  }

  Widget presentContainer() {
    return Icon(
      Icons.check_circle,
      size: iconSize,
      color: const Color(0xff3ABA2E),
    );
  }

  Widget notGivenContainer() {
    return Container(
        width: circleWidth,
        height: circleWidth,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black),
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(circleWidth))),
        child: const Icon(Icons.check));
  }

  Widget containerDeciderForAttendance(int index) {
    if (attendanceList[index] == 0) {
      return notGivenContainer();
    } else if (attendanceList[index] == 1) {
      return presentContainer();
    } else {
      return absentContainer();
    }
  }

//

  Widget decideIcon(int weekDay) {
    if (weekDay == currentWeekDay) {
      if (attendanceStatus == AttendanceStatus.present) {
        return presentContainer();
      }
    }
    return containerDeciderForAttendance(weekDay - 1);
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
            GestureDetector(
              onTap: () {
                onAttendanceButtonClicked(1, context);
              },
              child: Container(
                width: getScreenWidth(context) * 0.12,
                height: tabBarHeight,
                decoration: BoxDecoration(
                    color: currentWeekDay == 1
                        ? Colors.white
                        : const Color.fromARGB(255, 235, 238, 241),
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(10)),
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD))),
                child: Center(child: decideIcon(1)),
              ),
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
            GestureDetector(
              onTap: () {
                onAttendanceButtonClicked(3, context);
              },
              child: Container(
                width: getScreenWidth(context) * 0.12,
                height: tabBarHeight,
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD)),
                    color: currentWeekDay == 3
                        ? Colors.white
                        : const Color.fromARGB(255, 235, 238, 241)),
                child: Center(
                    // Centering the inner container
                    child: decideIcon(3)),
              ),
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
            GestureDetector(
              onTap: () {
                onAttendanceButtonClicked(4, context);
              },
              child: Container(
                width: getScreenWidth(context) * 0.12,
                height: tabBarHeight,
                decoration: BoxDecoration(
                    color: currentWeekDay == 4
                        ? Colors.white
                        : const Color.fromARGB(255, 235, 238, 241),
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD))),
                child: Center(
                  // Centering the inner container
                  child: decideIcon(4),
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
                text: 'Fri',
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                onAttendanceButtonClicked(5, context);
              },
              child: Container(
                width: getScreenWidth(context) * 0.12,
                height: tabBarHeight,
                decoration: BoxDecoration(
                    color: currentWeekDay == 5
                        ? Colors.white
                        : const Color.fromARGB(255, 235, 238, 241),
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD))),
                child: Center(
                    // Centering the inner container
                    child: decideIcon(5)),
              ),
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
            GestureDetector(
              onTap: () {
                onAttendanceButtonClicked(7, context);
              },
              child: Container(
                width: getScreenWidth(context) * 0.12,
                height: tabBarHeight,
                decoration: BoxDecoration(
                    color: currentWeekDay == 7
                        ? Colors.white
                        : const Color.fromARGB(255, 235, 238, 241),
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(10)),
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD))),
                child: Center(
                  // Centering the inner container
                  child: decideIcon(7),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
