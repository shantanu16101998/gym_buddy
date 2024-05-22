import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/attendance_bar.dart';
import 'package:gym_buddy/components/member/card_container.dart';
import 'package:gym_buddy/components/owner/app_scaffold.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

enum CardsToShow { exercise, diet }

class _HomepageState extends State<Homepage> {
  CardsToShow cardsToShow = CardsToShow.exercise;
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        isApiDataLoaded: true,
        child: Column(
          children: [
            const CustomText(
              text: 'Tap Here For Attendance',
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xff344054),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: AttendanceBar(),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: getScreenWidth(context) * 0.05,
                  top: 20,
                  right: getScreenWidth(context) * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CustomText(
                          text: 'Exercise',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          isUnderlined: cardsToShow == CardsToShow.exercise
                              ? true
                              : false),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomText(
                          text: 'Diet',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          isUnderlined:
                              cardsToShow == CardsToShow.diet ? true : false)
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Icon(Icons.add))
                ],
              ),
            ),
            const CardContainer()
          ],
        ));
  }
}
