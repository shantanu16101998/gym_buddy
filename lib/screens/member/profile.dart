import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/attendance_calendar.dart';
import 'package:gym_buddy/components/owner/app_scaffold.dart';
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
    return AppScaffold.noHeader(
      isApiDataLoaded: true,
      child: Column(
        children: [
          Center(child: AttendanceCalendar()),
          Container(
            height: 480,
            decoration: const BoxDecoration(
                border: Border(
              top: BorderSide(
                color: Color(0xffDBDDE2), 
                width: 1.0,
              ),
            )),
            // double padding = getScreenWidth(context * 0.25),
            // padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top : 30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width : 200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                                // userProfileResponse.gender == "Male"
                                Icons.male,
                                // : Icons.female,
                                color: Color(0xff004576),
                                size: 35),
                            SizedBox(width: getScreenWidth(context) * 0.03),
                            Flexible(
                              child: Text('Aryan Gupta',
                                  style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: Color(0xff004576)))),
                            ),
                            // const Text(
                            //   'Aryan Gupta',
                            //   style: TextStyle(
                            //       fontSize: 22,
                            //       fontWeight: FontWeight.bold,
                            //       color: Color(0xff004576)),
                            // ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12), // Add some space between rows
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width : 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.phone, color: Color(0xff004576)),
                              SizedBox(width: 25),
                              Flexible(
                                child: Text('987654321',
                                    style: GoogleFonts.inter(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            color: Color(0xff544C4C)))),
                              )
                              // const Text(
                              //   '987654321',
                              //   style: TextStyle(
                              //       fontSize: 18,
                              //       fontWeight: FontWeight.w400,
                              //       color: Color(0xff544C4C)),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10), // Add some space between rows
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width : 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.person, color: Color(0xff004576)),
                              SizedBox(width: 25),
                              Flexible(
                                child: Text('Shivendra',
                                    style: GoogleFonts.inter(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            color: Color(0xff544C4C)))),
                              )
                            ],
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(88.0),
                          child: Container(
                            width : 229,
                            height : 41,
                            child: ElevatedButton(
                              onPressed: () {
                                print('Button pressed!');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white, // Background color
                                // onPrimary: Colors.white, // Text color
                                shadowColor:
                                    Color.fromARGB(255, 52, 50, 50), // Shadow color
                                elevation: 0, // Elevation (shadow depth)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                    color: Color(0xff004576), // Border color
                                    width: 2, // Border width
                                  ),
                                ),
                                // padding: const EdgeInsets.symmetric(
                                //     horizontal: 20, vertical: 15),
                              ),
                              child: const Text(
                                'Refer a friend',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xff004576),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
