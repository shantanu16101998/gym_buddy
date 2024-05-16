import 'package:flutter/material.dart';
import 'package:gym_buddy/components/header.dart';
import 'package:gym_buddy/components/side_bar.dart';
import 'package:gym_buddy/components/loader.dart';
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
  String ownerName = "Owner";

  @override
  void initState() {
    super.initState();
    fetchOwnerName();
  }

  fetchOwnerName() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      ownerName = sharedPreferences.getString("ownerName") ?? "Owner";
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isApiDataLoaded
        ? Scaffold(
            drawer: SideBar(ownerName: ownerName),
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
                          ? Header(ownerName: ownerName)
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

//   @override
//   Widget build(BuildContext context) {
//     return widget.isApiDataLoaded
//         ? Scaffold(
//             drawer: SideBar(ownerName: ownerName),
//             body: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   minHeight:
//                       getScreenHeight(context), // Set the minimum height here
//                 ),
//                 child: Container(
//                   padding: EdgeInsets.only(
//                     top: widget.noSpaceForStatusBar == true
//                         ? 0
//                         : getStatusBarHeight(context),
//                   ),
//                   width: double.infinity,
//                   color: widget.bodyColor ?? Colors.white,
//                   child: Column(
//                     children: [
//                       widget.showHeader
//                           ? Header(ownerName: ownerName)
//                           : const SizedBox(),
//                       Container(child: widget.child)
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           )
//         : const SizedBox(child: Loader());
//   }
// }
