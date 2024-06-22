import 'package:flutter/material.dart';
import 'package:gym_buddy/screens/member/member.dart';
import 'package:gym_buddy/screens/member/member_login_form.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  final String userName;
  const SideBar({super.key, required this.userName});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("jwtToken");

    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MemberLoginForm()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      width: getScreenWidth(context) * 0.5,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          SizedBox(
              height: getScreenHeight(context) * 0.25,
              child: Padding(
                  padding: EdgeInsets.only(top: getScreenWidth(context) * 0.2),
                  child: Text(
                    widget.userName,
                    style: const TextStyle(
                        color: Color(0xff344054),
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MemberScreen(
                              customerScreens: CustomerScreens.homepage)))
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0xffDBDDE2))),
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: getScreenWidth(context) * 0.125,
                              top: 10,
                              right: 10,
                              bottom: 10),
                          child: const Icon(
                            Icons.home,
                            color: headingColor,
                          )),
                      const Text(
                        "Home",
                        style: TextStyle(
                            color: headingColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ])),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MemberScreen(
                              customerScreens: CustomerScreens.analysis)))
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0xffDBDDE2))),
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: getScreenWidth(context) * 0.125,
                              top: 10,
                              right: 10,
                              bottom: 10),
                          child: const Icon(
                            Icons.auto_graph,
                            color: headingColor,
                          )),
                      const Text(
                        "Analysis",
                        style: TextStyle(
                            color: headingColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ])),
              ),
              InkWell(
                onTap: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MemberScreen(
                              customerScreens: CustomerScreens.profile)))
                },
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0xffDBDDE2))),
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.only(
                              left: getScreenWidth(context) * 0.125,
                              top: 10,
                              right: 10,
                              bottom: 10),
                          child: const Icon(
                            Icons.person,
                            color: headingColor,
                          )),
                      const Text(
                        "Profile",
                        style: TextStyle(
                            color: headingColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ])),
              ),

              /*
              
              Have to remove until otp comes.

              */
              // InkWell(
              //   onTap: logout,
              //   child: Container(
              //       decoration: BoxDecoration(
              //           border: Border.all(
              //               width: 1, color: const Color(0xffDBDDE2))),
              //       child: Row(children: [
              //         Padding(
              //             padding: EdgeInsets.only(
              //                 left: getScreenWidth(context) * 0.125,
              //                 top: 10,
              //                 right: 10,
              //                 bottom: 10),
              //             child: const Icon(Icons.logout)),
              //         const Text(
              //           "Logout",
              //           style: TextStyle(
              //               fontWeight: FontWeight.bold, fontSize: 18),
              //         ),
              //       ])),
              // )
            ],
          )
        ],
      ),
    );
  }
}
