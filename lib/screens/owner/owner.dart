import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/gym_analysis.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/owner/side_bar.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class OwnerScreen extends StatefulWidget {
  final OwnerScreens ownerScreens;
  const OwnerScreen({super.key, required this.ownerScreens});

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(userName: ''),
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
                    const Header(),
                    Container(color: Colors.white, child: const GymAnalysis()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
