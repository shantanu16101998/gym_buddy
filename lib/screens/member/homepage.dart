import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/add_exercise.dart';
import 'package:gym_buddy/components/member/attendance_bar.dart';
import 'package:gym_buddy/components/member/card_container.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/components/member/identity_card.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/providers/excercise_provider.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'dart:typed_data';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  void _showIdentityCardDialog(BuildContext context) async {
    ScreenshotController screenshotController = ScreenshotController();
    bool isDowloaded = false;

    IdCardResponse idCardResponse = IdCardResponse.fromJson(
        await backendAPICall('/customer/idCard', {}, 'GET', true));

    void captureAndSave() async {
      try {
        Uint8List? image = await screenshotController.capture();
        if (image != null) {
          var status = await Permission.storage.request();
          if (status.isGranted) {
            await ImageGallerySaver.saveImage(image);
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

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (idCardResponse.planid != sharedPreferences.getString("currentPlanId")) {
      sharedPreferences.setString("currentPlanId", idCardResponse.planid);

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
                        controller: screenshotController,
                        child: IdentityCard(
                          gymContact: idCardResponse.gymContact,
                          dueDate: idCardResponse.planDue,
                          gymName: idCardResponse.gymName,
                          memberName: idCardResponse.memberName,
                          validTillInMonths:
                              idCardResponse.planDuration.toString(),
                          profileUrl: idCardResponse.customerPic,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: OutlinedButton(
                          onPressed: captureAndSave,
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            side:
                                const BorderSide(width: 1, color: Colors.black),
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
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showIdentityCardDialog(context);
    });
    fetchCustomerDetails();

    if (!Provider.of<ExerciseProvider>(context, listen: false)
        .exerciseInitialized) {
      Provider.of<ExerciseProvider>(context, listen: false).initExercise();
    }
  }

  MemberProfileResponse memberProfileResponse = MemberProfileResponse(
      name: '',
      contact: '',
      startDate: '',
      validTill: 0,
      trainerName: '',
      currentWeekAttendance: '',
      gymLocationLat: 0,
      gymLocationLon: 0.0);

  bool isApiDataLoaded = true;

  fetchCustomerDetails() async {
    MemberProfileResponse memberProfileResponseAPI =
        MemberProfileResponse.fromJson(
            await backendAPICall('/customer/details', {}, 'GET', true));

    setState(() {
      memberProfileResponse = memberProfileResponseAPI;
      isApiDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        isApiDataLoaded: isApiDataLoaded,
        child: Stack(
          children: [
            Column(
              children: [
                memberProfileResponse.gymLocationLat != null
                    ? const CustomText(
                        text: 'Tap Here For Attendance',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff344054),
                      )
                    : const SizedBox(),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: memberProfileResponse.gymLocationLat != null
                      ? AttendanceBar(
                          attendanceString:
                              memberProfileResponse.currentWeekAttendance,
                          gymLocationLat:
                              memberProfileResponse.gymLocationLat ?? 0,
                          gymLocationLon:
                              memberProfileResponse.gymLocationLon ?? 0)
                      : const SizedBox(),
                ),
                const CardContainer(),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      // height: 200,
                      color: Colors.white,
                      child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 70, top: 10),
                              child: SizedBox(
                                  height: 50,
                                  width: 340,
                                  child: ElevatedButton(
                                      onPressed: () => {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return SingleChildScrollView(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                                context)
                                                            .viewInsets
                                                            .bottom),
                                                    child:
                                                        const AddExercisedDialog(),
                                                  ));
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
