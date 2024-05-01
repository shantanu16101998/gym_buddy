import 'package:flutter/material.dart';
import 'package:gym_buddy/components/header.dart';
import 'package:gym_buddy/components/side_bar.dart';
import 'package:gym_buddy/components/loader.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class AppScaffold extends StatefulWidget {
  final Widget child;
  final bool isApiDataLoaded;
  final bool showHeader;
  final Color? bodyColor;
  const AppScaffold(
      {super.key,
      required this.isApiDataLoaded,
      required this.child,
      this.showHeader = true,
      this.bodyColor});

  const AppScaffold.noHeader(
      {super.key,
      required this.isApiDataLoaded,
      required this.child,
      this.showHeader = false,
      this.bodyColor});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return widget.isApiDataLoaded
        ? Scaffold(
            drawer: const SideBar(),
            body: Container(
              padding: EdgeInsets.only(top: getStatusBarHeight(context)),
              width: double.infinity,
              color: widget.bodyColor ?? Colors.white,
              child: Column(
                children: [
                  widget.showHeader ? const Header() : const SizedBox(),
                  Container(child: widget.child)
                ],
              ),
            ),
          )
        : const SizedBox(child: Loader());
  }
}
