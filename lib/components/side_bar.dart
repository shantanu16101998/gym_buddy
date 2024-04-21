import 'package:flutter/material.dart';
import 'package:gym_buddy/screens/analysis_homepage.dart';
import 'package:gym_buddy/screens/subscription.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: getScreenWidth(context) * 0.5,
      // color: Colors.white,
      // margin: EdgeInsets.only(left: getScreenWidth(context) * 0.5),
      child: Column(
        children: [
          Container(
              height: getScreenHeight(context) * 0.25,
              child: Padding(
                  padding: EdgeInsets.only(top: getScreenWidth(context) * 0.2),
                  child: const Text(
                    "Murali M",
                    style: TextStyle(
                        color: Color(0xff344054),
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Subscription()))
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: const Color(0xffDBDDE2))),
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: getScreenWidth(context) * 0.125,
                              top: 10,
                              right: 10,
                              bottom: 10),
                          child: Icon(Icons.home)),
                      const Text(
                        "Home",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ])),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AnalysisHomepage()))
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: const Color(0xffDBDDE2))),
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: getScreenWidth(context) * 0.125,
                              top: 10,
                              right: 10,
                              bottom: 10),
                          child: Icon(Icons.bar_chart)),
                      const Text(
                        "Analysis",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ])),
              )
            ],
          )
        ],
      ),
    );
  }
}
