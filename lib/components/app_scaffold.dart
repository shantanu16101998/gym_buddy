import 'package:flutter/material.dart';
import 'package:gym_buddy/components/header.dart';
import 'package:gym_buddy/components/side_bar.dart';
import 'package:gym_buddy/components/loader.dart';
import 'package:gym_buddy/utils/ui_constants.dart';


class AppScaffold extends StatefulWidget {
  final Widget child;
  final bool isApiDataLoaded;
  const AppScaffold({super.key,required this.isApiDataLoaded, required this.child});

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  @override
  Widget build(BuildContext context) {
    return widget.isApiDataLoaded ? Scaffold(
      drawer: const SideBar(),
      body: Container(
        padding: EdgeInsets.only(top: getStatusBarHeight(context)),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          children: [const Header(), Container(child: widget.child)],
        ),
      ),
    ) : const SizedBox(child: Loader());
  }
}
