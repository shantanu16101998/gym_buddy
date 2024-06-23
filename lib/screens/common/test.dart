import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/components/owner/gym_analysis.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // showAlertDialog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
        isApiDataLoaded: true,
        bodyColor: Color.fromARGB(255, 255, 255, 255),
        child: GymAnalysis());
  }
}
