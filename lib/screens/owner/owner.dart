import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/header.dart';
import 'package:gym_buddy/components/owner/side_bar.dart';
import 'package:gym_buddy/screens/owner/analysis_homepage.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/screens/owner/user_sign_up.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class OwnerScreen extends StatefulWidget {
  const OwnerScreen({super.key});

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  OwnerScreens ownerScreens = OwnerScreens.subscriptionPage;

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
                        child: ownerScreens == OwnerScreens.subscriptionPage
                            ? const Subscription()
                            : const AnalysisHomepage()),
                  ],
                ),
              ),
            ),
          ),
          if (ownerScreens == OwnerScreens.subscriptionPage)
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(blurRadius: 2, color: Colors.grey)
                        ]),
                    child: Align(
                        alignment: Alignment.center,
                        child: Padding(
                            padding: const EdgeInsets.only(bottom: 10, top: 10),
                            child: SizedBox(
                                height: 50,
                                width: 340,
                                child: ElevatedButton(
                                    onPressed: () => {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const UserSignUp()))
                                        },
                                    style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                            color: headingColor, width: 1),
                                        elevation: 0,
                                        backgroundColor:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text("Add Members",
                                            style: TextStyle(
                                                color: headingColor,
                                                fontSize: 18,
                                                fontWeight:
                                                    FontWeight.bold))))))))),
        ],
      ),
    );
  }
}
