import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

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
              width: getScreenWidth(context) * 0.15,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 238, 241),
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
              width: getScreenWidth(context) * 0.15,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 238, 241),
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
              width: getScreenWidth(context) * 0.15,
              height: tabBarHeight,
              decoration: BoxDecoration(
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
                text: 'Thu',
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: getScreenWidth(context) * 0.15,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 238, 241),
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
              width: getScreenWidth(context) * 0.15,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 238, 241),
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
            Container(
              width: getScreenWidth(context) * 0.15,
              height: tabBarHeight,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 235, 238, 241),
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
