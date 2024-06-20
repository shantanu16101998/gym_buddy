import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/member/side_bar.dart' as member_side_bar;
import 'package:gym_buddy/constants/environment.dart';
import 'package:gym_buddy/screens/member/homepage.dart';
import 'package:gym_buddy/screens/member/profile.dart';
import 'package:gym_buddy/screens/member/workout_analysis.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberScreen extends StatefulWidget {
  final CustomerScreens customerScreens;
  const MemberScreen({super.key, required this.customerScreens});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  String userName = "Owner";
  String currentScreen = "home";
  CustomerScreens customerScreens = CustomerScreens.homepage;

  @override
  void initState() {
    super.initState();
    setState(() {
      customerScreens = widget.customerScreens;
    });
    fetchOwnerName();
  }

  fetchOwnerName() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("userName") ?? "User";
      currentScreen = sharedPreferences.getString("currentScreen") ?? "home";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: member_side_bar.SideBar(userName: ''),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: getScreenHeight(context),
              ),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Header(userName: userName),
                    Container(
                        color: Colors.white,
                        child: customerScreens == CustomerScreens.homepage
                            ? const Homepage()
                            : customerScreens == CustomerScreens.analysis
                                ? const WorkoutAnalayis()
                                : const Profile()),
                  ],
                ),
              ),
            ),
          ),
          appEnvironment == AppEnvironment.member
              ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    // height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(
                              255, 247, 245, 245), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 2, // Blur radius
                          offset: Offset(
                              0, -3), // Position the shadow above the Container
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            var sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(
                                "currentScreen", "home");

                            setState(() {
                              customerScreens = CustomerScreens.homepage;
                            });
                          },
                          child: SizedBox(
                            width: getScreenWidth(context) * 0.3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                children: [
                                  Icon(Icons.home,
                                      size: 20,
                                      color: customerScreens ==
                                              CustomerScreens.homepage
                                          ? headingColor
                                          : const Color.fromARGB(
                                              255, 149, 142, 142)),
                                  CustomText(
                                      text: 'Home',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: customerScreens ==
                                              CustomerScreens.homepage
                                          ? headingColor
                                          : const Color.fromARGB(
                                              255, 149, 142, 142)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(
                                "currentScreen", "analysis");

                            setState(() {
                              customerScreens = CustomerScreens.analysis;
                            });
                          },
                          child: SizedBox(
                            width: getScreenWidth(context) * 0.3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                children: [
                                  Icon(Icons.auto_graph,
                                      size: 20,
                                      color: customerScreens ==
                                              CustomerScreens.analysis
                                          ? headingColor
                                          : const Color.fromARGB(
                                              255, 149, 142, 142)),
                                  CustomText(
                                      text: 'Analyse',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: customerScreens ==
                                              CustomerScreens.analysis
                                          ? headingColor
                                          : const Color.fromARGB(
                                              255, 149, 142, 142)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var sharedPreferences =
                                await SharedPreferences.getInstance();

                            sharedPreferences.setString(
                                "currentScreen", "profile");

                            setState(() {
                              customerScreens = CustomerScreens.profile;
                            });
                          },
                          child: SizedBox(
                            width: getScreenWidth(context) * 0.3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Column(
                                children: [
                                  Icon(Icons.person,
                                      size: 20,
                                      color: customerScreens ==
                                              CustomerScreens.profile
                                          ? headingColor
                                          : const Color.fromARGB(
                                              255, 149, 142, 142)),
                                  CustomText(
                                      text: 'Profile',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: customerScreens ==
                                              CustomerScreens.profile
                                          ? headingColor
                                          : const Color.fromARGB(
                                              255, 149, 142, 142)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );

    // Container(color: Colors.white, child: const Loader());
  }
}
