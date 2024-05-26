import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/owner/side_bar.dart' as owner_side_bar;
import 'package:gym_buddy/components/member/side_bar.dart' as member_side_bar;
import 'package:gym_buddy/components/owner/loader.dart';
import 'package:gym_buddy/constants/environment.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;
  final bool isApiDataLoaded;
  final bool showHeader;
  final Color? bodyColor;
  final bool? noSpaceForStatusBar;
  const AppScaffold(
      {super.key,
      required this.isApiDataLoaded,
      required this.child,
      this.showHeader = true,
      this.bodyColor,
      this.noSpaceForStatusBar});

  const AppScaffold.noHeader(
      {super.key,
      required this.isApiDataLoaded,
      required this.child,
      this.showHeader = false,
      this.bodyColor,
      this.noSpaceForStatusBar});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  String userName = "Owner";

  @override
  void initState() {
    super.initState();
    fetchOwnerName();
  }

  fetchOwnerName() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreferences.getString("userName") ?? "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isApiDataLoaded
        ? Scaffold(
            drawer: appEnvironment == AppEnvironment.owner ? owner_side_bar.SideBar(userName: userName) : member_side_bar.SideBar(userName: userName),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: getScreenHeight(context),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                      top: widget.noSpaceForStatusBar == true
                          ? 0
                          : getStatusBarHeight(context)),
                  width: double.infinity,
                  color: widget.bodyColor ?? Colors.white,
                  child: Column(
                    children: [
                      widget.showHeader
                          ? Header(userName: userName)
                          : const SizedBox(),
                      Container(child: widget.child)
                    ],
                  ),
                ),
              ),
            ),
          )
        : const SizedBox(child: Loader());
  }
}
