import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/screens/member/member_login_form.dart';
import 'package:gym_buddy/screens/owner/owner_form.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class Decider extends StatefulWidget {
  const Decider({super.key});

  @override
  State<Decider> createState() => _DeciderState();
}

class _DeciderState extends State<Decider> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold.noHeader(
      isApiDataLoaded: true,
      child: Stack(
        children: <Widget>[
          Container(
            height: getScreenHeight(context),
            margin: EdgeInsets.only(top: getStatusBarHeight(context)),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/register.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          // Center the inner container horizontally and vertically
          Padding(
            padding: EdgeInsets.only(top: getScreenHeight(context) * 0.4),
            child: Center(
              child: Container(
                width:
                    getScreenWidth(context) * 0.8, // Adjust the width as needed
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:
                      const Color.fromARGB(255, 85, 84, 84).withOpacity(0.98),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CustomText(
                        text: 'Are you a',
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: getScreenWidth(context) * 0.5,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const OwnerForm()));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            side: const BorderSide(
                                width: 1.0, color: Colors.white),
                            // backgroundColor:
                            // const Color.fromARGB(255, 105, 105, 105),
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Gym Owner",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 243, 243, 243),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: getScreenWidth(context) * 0.5,
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MemberLoginForm()));
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            side: const BorderSide(
                                width: 1.0, color: Colors.white),
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Gym member",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 243, 243, 243),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ),
                    )
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
