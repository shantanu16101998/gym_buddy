import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

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

  String locationAlertPrompt =
      "Please give location permission to mark attendance";

  locationPermission() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      LocationData locationData = await Location().getLocation();

      double distanceBetweenGymAndPerson = calculateDistanceInKm(
          12.932206048757998,
          77.61528538850291,
          12.934171901523671,
          77.614341250971);

      if (distanceBetweenGymAndPerson < 0.05) {
        Navigator.of(context).pop();
      } else {
        
      }


      print(
          'Latitude: ${locationData.latitude}, Longitude: ${locationData.longitude}');
      return true;
    } else {
      return false;
    }
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(locationAlertPrompt),
          backgroundColor: Colors.white,
          content: OutlinedButton(
              onPressed: locationPermission,
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
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the dialog
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
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
                      : Color.fromARGB(255, 235, 238, 241),
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(10)),
                  border: Border.all(width: 1, color: const Color(0xffD0D5DD))),
              child: Center(
                child: Icon(
                  Icons.check_circle,
                  size: iconSize,
                  color: const Color(0xff3ABA2E),
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
            Container(
              width: getScreenWidth(context) * 0.12,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  color: currentWeekDay == 2
                      ? Colors.white
                      : Color.fromARGB(255, 235, 238, 241),
                  border: Border.all(width: 1, color: const Color(0xffD0D5DD))),
              child: Center(
                // Centering the inner container
                child: Container(
                  height: circleWidth,
                  width: circleWidth,
                  decoration: BoxDecoration(
                      color: const Color(0xffE46A6A),
                      borderRadius:
                          BorderRadius.all(Radius.circular(circleWidth))),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
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
                      : Color.fromARGB(255, 235, 238, 241)),
              child: Center(
                // Centering the inner container
                child: Container(
                  width: circleWidth,
                  height: circleWidth,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(circleWidth))),
                  child: const Icon(Icons.check),
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
                      : Color.fromARGB(255, 235, 238, 241),
                  border: Border.all(width: 1, color: const Color(0xffD0D5DD))),
              child: Center(
                // Centering the inner container
                child: Container(
                  width: circleWidth,
                  height: circleWidth,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(circleWidth))),
                  child: const Icon(Icons.check),
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
            Container(
              width: getScreenWidth(context) * 0.12,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  color: currentWeekDay == 5
                      ? Colors.white
                      : Color.fromARGB(255, 235, 238, 241),
                  border: Border.all(width: 1, color: const Color(0xffD0D5DD))),
              child: Center(
                // Centering the inner container
                child: Container(
                  width: circleWidth,
                  height: circleWidth,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(circleWidth))),
                  child: const Icon(Icons.check),
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
                text: 'Sat',
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                _showAlertDialog(context);
              },
              child: Container(
                width: getScreenWidth(context) * 0.12,
                height: tabBarHeight,
                decoration: BoxDecoration(
                    color: currentWeekDay == 6
                        ? Colors.white
                        : Color.fromARGB(255, 235, 238, 241),
                    border:
                        Border.all(width: 1, color: const Color(0xffD0D5DD))),
                child: Center(
                  // Centering the inner container
                  child: Container(
                    width: circleWidth,
                    height: circleWidth,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.all(Radius.circular(circleWidth))),
                    child: const Icon(Icons.check),
                  ),
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
                      : Color.fromARGB(255, 235, 238, 241),
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(10)),
                  border: Border.all(width: 1, color: const Color(0xffD0D5DD))),
              child: Center(
                // Centering the inner container
                child: Container(
                  width: circleWidth,
                  height: circleWidth,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black),
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.all(Radius.circular(circleWidth))),
                  child: const Icon(Icons.check),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
