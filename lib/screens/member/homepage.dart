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
            const CardContainer()
          ],
        ));
  }
}
