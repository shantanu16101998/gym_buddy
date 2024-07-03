import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/gym_analysis.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/owner/side_bar.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/screens/owner/user_sign_up.dart';
import 'package:gym_buddy/utils/colors.dart';
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
                    Container(
                        color: Colors.white,
                        child:
                            widget.ownerScreens == OwnerScreens.subscriptionPage
                                ? const Subscription()
                                : const GymAnalysis()),
                  ],
                ),
              ),
            ),
          ),
          if (widget.ownerScreens == OwnerScreens.subscriptionPage)
            Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 25, bottom: 25),
                  child: GestureDetector(
                    onTap: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserSignUp()))
                    },
                    child: Container(
                        height: 60,
                        width: 60,
                        decoration: const BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            boxShadow: [
                              BoxShadow(blurRadius: 2, color: Colors.grey)
                            ]),
                        child: Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                                child: Text("+",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold))))),
                  ),
                )),
        ],
      ),
    );
  }
}
