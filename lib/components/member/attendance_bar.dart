import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/custom_dialog_box.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

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
    return CustomDialogBox(
      buttonColor: const Color(0xff888A12),
      buttonName: 'Allow',
      iconWidget:
          const Icon(Icons.warning_rounded, size: 50, color: Color(0xff888A12)),
      heading: 'Grant location permission !',
      subheading: 'Please grant permission for attendance verification',
      buttonAction: () async {
        LocationResult locationResult = await getCurrentLocationSuccess();
        bool verdict = locationResult.success;
        if (verdict) {
          if (await userInGym(
              locationResult.latitude, locationResult.longitude)) {
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
    );
  }

  Widget attendanceMarkedWidget() {
    return const CustomDialogBox(
        buttonColor: Color(0xff3ABA2E),
        iconWidget: Icon(
          Icons.check_circle,
          size: 50,
          color: Color(0xff3ABA2E),
        ),
        heading: 'Attendance Marked !',
        subheading: 'Your attendance is marked successfully',
        buttonAction: null);
  }

  Widget userNotInLocationWidget() {
    return CustomDialogBox(
        buttonColor: const Color(0xffE46A6A),
        iconWidget: Container(
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
              color: Color(0xffE46A6A),
              borderRadius: BorderRadius.all(Radius.circular(80))),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 40,
          ),
        ),
        heading: 'Attendance Not Marked !',
        subheading: 'Please go inside gym to mark attendance',
        buttonAction: null);
  }

  userInGym(double locationLat, double locationLon) {
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
      LocationResult locationResult = await getCurrentLocationSuccess();

      bool verdict = locationResult.success;

      if (verdict) {
        if (attendanceStatus != AttendanceStatus.present) {
          if (await userInGym(
              locationResult.latitude, locationResult.longitude)) {
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent, // Set background color to white
          content: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child:
                attendanceStatus == AttendanceStatus.notLocationPermissionGiven
                    ? grantLocationPermissionWidget()
                    : attendanceStatus == AttendanceStatus.present
                        ? attendanceMarkedWidget()
                        : userNotInLocationWidget(),
          ),
        );
      },
    );
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

  double decideWidth(int weekDay) {
    if (weekDay == currentWeekDay) {
      return getScreenWidth(context) * 0.15;
    } else {
      return getScreenWidth(context) * 0.12;
    }
  }

  double decideHeight(int weekDay) {
    if (weekDay == currentWeekDay) {
      return tabBarHeight * 1.2;
    } else {
      return tabBarHeight;
    }
  }

//

  Widget decideIcon(int weekDay) {
    if (weekDay == currentWeekDay) {
      if (attendanceStatus == AttendanceStatus.present) {
        return presentContainer();
      }
    } else if (weekDay > widget.attendanceString.length) {
      return Icon(
        Icons.check_circle,
        size: iconSize,
        color: Colors.transparent,
      );
    }
    return containerDeciderForAttendance(weekDay - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
            Material(
              color: currentWeekDay >= 1
                  ? Colors.white
                  : const Color.fromARGB(255, 235, 238, 241),
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(10)),
              child: InkWell(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  onAttendanceButtonClicked(1, context);
                },
                highlightColor: Colors.transparent,
                splashColor: currentWeekDay == 1
                    ? const Color.fromARGB(255, 235, 238, 241)
                    : Colors.transparent,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(10)),
                child: Container(
                  width: decideWidth(1),
                  height: decideHeight(1),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(10)),
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD)),
                  ),
                  child: Center(child: decideIcon(1)),
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
                text: 'Tue',
                fontWeight: FontWeight.bold,
              ),
            ),
            Material(
              color: currentWeekDay >= 2
                  ? Colors.white
                  : const Color.fromARGB(255, 235, 238, 241),
              child: InkWell(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  onAttendanceButtonClicked(2, context);
                },
                highlightColor: Colors.transparent,
                splashColor: currentWeekDay == 2
                    ? const Color.fromARGB(255, 235, 238, 241)
                    : Colors.transparent,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(10)),
                child: Container(
                  width: decideWidth(2),
                  height: decideHeight(2),
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD)),
                  ),
                  child: Center(child: decideIcon(2)),
                ),
              ),
            )
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
            Material(
              color: currentWeekDay >= 3
                  ? Colors.white
                  : const Color.fromARGB(255, 235, 238, 241),
              child: InkWell(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  onAttendanceButtonClicked(3, context);
                },
                highlightColor: Colors.transparent,
                splashColor: currentWeekDay == 3
                    ? const Color.fromARGB(255, 235, 238, 241)
                    : Colors.transparent,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(10)),
                child: Container(
                  width: decideWidth(3),
                  height: decideHeight(3),
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD)),
                  ),
                  child: Center(child: decideIcon(3)),
                ),
              ),
            )
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
            Material(
              color: currentWeekDay >= 4
                  ? Colors.white
                  : const Color.fromARGB(255, 235, 238, 241),
              child: InkWell(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  onAttendanceButtonClicked(4, context);
                },
                highlightColor: Colors.transparent,
                splashColor: currentWeekDay == 4
                    ? const Color.fromARGB(255, 235, 238, 241)
                    : Colors.transparent,
                child: Container(
                  width: decideWidth(4),
                  height: decideHeight(4),
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD)),
                  ),
                  child: Center(child: decideIcon(4)),
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
            Material(
              color: currentWeekDay >= 5
                  ? Colors.white
                  : const Color.fromARGB(255, 235, 238, 241),
              child: InkWell(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  onAttendanceButtonClicked(5, context);
                },
                highlightColor: Colors.transparent,
                splashColor: currentWeekDay == 5
                    ? const Color.fromARGB(255, 235, 238, 241)
                    : Colors.transparent,
                child: Container(
                  width: decideWidth(5),
                  height: decideHeight(5),
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD)),
                  ),
                  child: Center(child: decideIcon(5)),
                ),
              ),
            )
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
            Material(
              color: currentWeekDay >= 6
                  ? Colors.white
                  : const Color.fromARGB(255, 235, 238, 241),
              child: InkWell(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  onAttendanceButtonClicked(6, context);
                },
                highlightColor: Colors.transparent,
                splashColor: currentWeekDay == 6
                    ? const Color.fromARGB(255, 235, 238, 241)
                    : Colors.transparent,
                child: Container(
                  width: decideWidth(6),
                  height: decideHeight(6),
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD)),
                  ),
                  child: Center(child: decideIcon(6)),
                ),
              ),
            )
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
            Material(
              color: currentWeekDay >= 7
                  ? Colors.white
                  : const Color.fromARGB(255, 235, 238, 241),
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(10)),
              child: InkWell(
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                onTap: () {
                  onAttendanceButtonClicked(7, context);
                },
                highlightColor: Colors.transparent,
                splashColor: currentWeekDay == 7
                    ? const Color.fromARGB(255, 235, 238, 241)
                    : Colors.transparent,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(10)),
                child: Container(
                  width: decideWidth(7),
                  height: decideHeight(7),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(10)),
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD)),
                  ),
                  child: Center(child: decideIcon(7)),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
