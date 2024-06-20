import 'package:flutter/material.dart';
import 'package:gym_buddy/screens/owner/analysis_homepage.dart';
import 'package:gym_buddy/screens/owner/splash_screen.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  final String userName;
  const SideBar({super.key, required this.userName});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("jwtToken");
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      width: getScreenWidth(context) * 0.5,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          SizedBox(
              height: getScreenHeight(context) * 0.25,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: getScreenWidth(context) * 0.2, left: 10),
                  child: Text(
                    widget.userName,
                    style: const TextStyle(
                        color: headingColor,
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
                        border: Border.all(
                            width: 1, color: const Color(0xffDBDDE2))),
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: getScreenWidth(context) * 0.125,
                              top: 10,
                              right: 10,
                              bottom: 10),
                          child: const Icon(Icons.home)),
                      const Text(
                        "Home",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: headingColor),
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
                        border: Border.all(
                            width: 1, color: const Color(0xffDBDDE2))),
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: getScreenWidth(context) * 0.125,
                              top: 10,
                              right: 10,
                              bottom: 10),
                          child: const Icon(Icons.bar_chart)),
                      const Text(
                        "Analysis",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: headingColor),
                      ),
                    ])),
              ),
              InkWell(
                onTap: logout,
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0xffDBDDE2))),
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: getScreenWidth(context) * 0.125,
                              top: 10,
                              right: 10,
                              bottom: 10),
                          child: const Icon(Icons.logout)),
                      const Text(
                        "Logout",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: headingColor),
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
