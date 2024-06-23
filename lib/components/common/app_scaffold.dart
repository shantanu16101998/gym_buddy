import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/owner/side_bar.dart' as owner_side_bar;
import 'package:gym_buddy/components/member/side_bar.dart' as member_side_bar;
import 'package:gym_buddy/constants/environment.dart';
import 'package:gym_buddy/constants/navigator.dart';
import 'package:gym_buddy/components/member/homepage.dart';
import 'package:gym_buddy/components/member/profile.dart';
import 'package:gym_buddy/components/member/workout_analysis.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;
  final bool isApiDataLoaded;
  final bool showHeader;
  final Color? bodyColor;
  final bool? noSpaceForStatusBar;

  const AppScaffold({
    super.key,
    required this.isApiDataLoaded,
    required this.child,
    this.showHeader = true,
    this.bodyColor,
    this.noSpaceForStatusBar,
  });

  const AppScaffold.noHeader({
    super.key,
    required this.isApiDataLoaded,
    required this.child,
    this.showHeader = false,
    this.bodyColor,
    this.noSpaceForStatusBar,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  String userName = "Owner";
  String currentScreen = "home";

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
      drawer: appEnvironment == AppEnvironment.owner
          ? owner_side_bar.SideBar(userName: userName)
          : member_side_bar.SideBar(userName: userName),
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
                color: widget.bodyColor ?? Colors.white,
                child: Column(
                  children: [
                    widget.showHeader
                        ? Header()
                        : const SizedBox(),
                    Container(
                        child: widget.isApiDataLoaded
                            ? widget.child
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
