import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/member/side_bar.dart' as member_side_bar;
import 'package:gym_buddy/constants/environment.dart';
import 'package:gym_buddy/constants/navigator.dart';
import 'package:gym_buddy/providers/api_data_loaded.dart';
import 'package:gym_buddy/screens/member/homepage.dart';
import 'package:gym_buddy/screens/member/profile.dart';
import 'package:gym_buddy/screens/member/workout_analysis.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class MemberScreen extends StatefulWidget {
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
      drawer: member_side_bar.SideBar(userName: userName),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: getScreenHeight(context),
              ),
              child: Container(
                padding: EdgeInsets.only(
                  top: getStatusBarHeight(context),
                ),
                width: double.infinity,
                color: Colors.white,
                child: Column(
                  children: [
                    Header(userName: userName),
                    Container(
                        child: context
                                .watch<ApiDataLoadedProvider>()
                                .isApiDataLoaded
                            ? const Homepage()
                            : SizedBox(
                                width: double.infinity,
                                height: getEffectiveScreenHeight(context),
                                child: Shimmer.fromColors(
                                  baseColor:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  highlightColor:
                                      const Color.fromARGB(255, 227, 227, 226),
                                  child: Container(
                                    height: 20,
                                    width: 100,
                                    color: Colors.white,
                                  ),
                                ))),
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
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
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

                            navigateBackToRouteOrPush(
                                context, '/member/homepage', const Homepage());
                          },
                          child: SizedBox(
                            width: getScreenWidth(context) * 0.3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: Icon(Icons.home,
                                  size: 30,
                                  color: currentScreen == "home"
                                      ? headingColor
                                      : const Color.fromARGB(
                                          255, 149, 142, 142)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setString(
                                "currentScreen", "analysis");

                            navigateBackToRouteOrPush(context,
                                '/member/analysis', const WorkoutAnalayis());
                          },
                          child: SizedBox(
                            width: getScreenWidth(context) * 0.3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: Icon(Icons.auto_graph,
                                  size: 30,
                                  color: currentScreen == "analysis"
                                      ? headingColor
                                      : const Color.fromARGB(
                                          255, 149, 142, 142)),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            var sharedPreferences =
                                await SharedPreferences.getInstance();

                            sharedPreferences.setString(
                                "currentScreen", "profile");

                            navigateBackToRouteOrPush(
                                context, '/member/profile', const Profile());
                          },
                          child: SizedBox(
                            width: getScreenWidth(context) * 0.3,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: Icon(Icons.person,
                                  size: 30,
                                  color: currentScreen == "profile"
                                      ? headingColor
                                      : const Color.fromARGB(
                                          255, 149, 142, 142)),
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
