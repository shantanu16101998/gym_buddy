import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: getStatusBarHeight(context)),
          width: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: getScreenHeight(context) * 0.2,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "assets/images/mega_gym_background.png"),
                          fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(height: getScreenHeight(context) * 0.1),
                  Text("Aryan Gupta",
                      style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color(0xff004576)))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on),
                  SizedBox(width: getScreenWidth(context) * 0.05),
                      Text("Aryan Gupta",
                          style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  color: Color(0xff544C4C)))),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: getStatusBarHeight(context) +
                        getScreenHeight(context) * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: getScreenHeight(context) * 0.1,
                      height: getScreenHeight(context) * 0.1,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: Color.fromARGB(255, 255, 255, 255)),
                        borderRadius: BorderRadius.circular(60),
                        image: DecorationImage(
                            image: AssetImage("assets/images/profile_pic.png"),
                            fit: BoxFit.fill),
                      ),
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }
}
