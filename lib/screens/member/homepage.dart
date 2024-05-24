import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/attendance_bar.dart';
import 'package:gym_buddy/components/member/card_container.dart';
import 'package:gym_buddy/components/owner/app_scaffold.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';

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
            const CardContainer(),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  color: Colors.white,
                  child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 10),
                          child: SizedBox(
                              height: 50,
                              width: 340,
                              child: ElevatedButton(
                                  onPressed: () => {},
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: const Color(0xFFD9D9D9)),
                                  child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Add Exercise",
                                          style: TextStyle(
                                              color: Color(0xff004576),
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight.bold))))))),
                ))
          ],
        ));
  }
}
