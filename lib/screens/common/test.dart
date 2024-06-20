import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/components/common/custom_dialog_box.dart';

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
    return AppScaffold(
        isApiDataLoaded: true,
        bodyColor: Color.fromARGB(255, 150, 147, 147),
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
              child: CustomDialogBox(
            buttonAction: null,
            heading: 'Your attendance is marked!',
            subheading: 'jingle bell',
            buttonColor: Color(0xff3ABA2E),
            iconWidget: Icon(Icons.abc),
          )),
        ));
  }
}
