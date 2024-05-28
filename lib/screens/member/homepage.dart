import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/add_exercise.dart';
import 'package:gym_buddy/components/member/attendance_bar.dart';
import 'package:gym_buddy/components/member/card_container.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/components/member/identity_card.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void _showIdentityCardDialog(BuildContext context) {
    ScreenshotController _screenshotController = ScreenshotController();
    bool isDowloaded = false;

    void captureAndSave() async {
      try {
        Uint8List? image = await _screenshotController.capture();
        if (image != null) {
          var status = await Permission.storage.request();
          if (status.isGranted) {
            var result = await ImageGallerySaver.saveImage(image);
            print(result);
            setState(() {
              isDowloaded = true;
              Navigator.pop(context);
            });
          } else {
            // Handle permission denied
            print("Permission denied to save image");
          }
        } else {
          print("Failed to capture image");
        }
      } catch (e) {
        print(e.toString());
      }
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return !isDowloaded
            ? Container(
                decoration: const BoxDecoration(color: Colors.white),
                width: double.infinity,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        'Your gym Id card is generated',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Screenshot(
                      controller: _screenshotController,
                      child: const IdentityCard(
                        gymContact: 'gymContact',
                        startDate: '24 Mar 2024',
                        gymName: 'gymName',
                        memberName: 'memberName',
                        validTillInMonths: '2',
                        profileUrl:
                            'https://appcraft.s3.ap-south-1.amazonaws.com/6654baf866f7e7a6a867ef6b?time=1716828996270',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: OutlinedButton(
                        onPressed: captureAndSave,
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          side: const BorderSide(width: 1, color: Colors.black),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Save in gallary",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                width: double.infinity,
                color: Colors.white,
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomText(
                          text:
                              'Your id card is downloaded successfully in gallery',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: headingColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _showIdentityCardDialog(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        isApiDataLoaded: true,
        child: Stack(
          children: [
            Column(
              children: [
                const CustomText(
                  text: 'Tap Here For Attendance',
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff344054),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: AttendanceBar(),
                ),
                const CardContainer(),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 100,
                      color: Colors.white,
                      child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              child: SizedBox(
                                  height: 50,
                                  width: 340,
                                  child: ElevatedButton(
                                      onPressed: () => {
                                            showModalBottomSheet(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AddExercisedDialog();
                                                })
                                          },
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor:
                                              const Color(0xFFD9D9D9)),
                                      child: const Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text("Add Exercise",
                                              style: TextStyle(
                                                  color: Color(0xff004576),
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold))))))),
                    ))
              ],
            ),
          ],
        ));
  }
}
