import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/custom_dialog_box.dart';
import 'package:gym_buddy/components/member/add_exercise.dart';
import 'package:gym_buddy/components/member/attendance_bar.dart';
import 'package:gym_buddy/components/member/card_container.dart';
import 'package:gym_buddy/components/member/identity_card.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/providers/customer_details.dart';
import 'package:gym_buddy/providers/excercise_provider.dart';
import 'package:gym_buddy/screens/common/screen_shimmer.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
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
    IdCardResponse idCardResponse =
        await Provider.of<CustomerDetailsProvider>(context, listen: false)
            .fetchIdCardResponse();

    ScreenshotController screenshotController = ScreenshotController();
    // ignore: unused_local_variable
    bool isDowloaded = false;

    Future<bool> requestStoragePermission() async {
      if (await Permission.storage.request().isGranted) {
        return true;
      } else if (await Permission.manageExternalStorage.request().isGranted) {
        return true;
      } else {
        openAppSettings();
        return false;
      }
    }

    void showDownloadedDialog() {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            content: CustomDialogBox(
                buttonColor: Color(0xff004576),
                iconWidget: Icon(Icons.warning_rounded,
                    size: 50, color: Color(0xff004576)),
                heading: 'Id Card downloaded',
                subheading: 'Your id card is downloaded in your gallary')),
      );
    }

    void captureAndSave() async {
      try {
        Uint8List? image = await screenshotController.capture();
        if (image != null) {
          var status = await requestStoragePermission();
          if (status) {
            await ImageGallerySaver.saveImage(image);
            setState(() {
              isDowloaded = true;
              Navigator.pop(context);
              showDownloadedDialog();
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

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            content: Container(
              width: 312,
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Container(
                        height: 50,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Color(0xff32A737),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12))),
                        child: const Center(
                          child: CustomText(
                            text: 'Your ID Card is Ready!',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
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
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: captureAndSave,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Color(0xff004576),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                ),
                              ),
                              width: 156,
                              height: 40,
                              child: const Center(
                                child: CustomText(
                                  text: 'Dowload',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xffD3D3D3),
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: const Center(
                                  child: CustomText(
                                    text: 'Dismiss',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
        .exerciseFirstTimeInitialized) {
      Provider.of<ExerciseProvider>(context, listen: false).initExercise(
          Provider.of<ExerciseProvider>(context, listen: false).providerDay);
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

  bool isApiDataLoaded = false;

  fetchCustomerDetails() async {
    MemberProfileResponse memberProfileResponseAPI =
        await Provider.of<CustomerDetailsProvider>(context, listen: false)
            .fetchMemberProfileResponse();

    setState(() {
      memberProfileResponse = memberProfileResponseAPI;
      isApiDataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = context.watch<ExerciseProvider>();

    return isApiDataLoaded
        ? Stack(
            children: [
              Column(
                children: [
                  memberProfileResponse.gymLocationLat != null
                      ? const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: CustomText(
                            text: 'Tap Here For Attendance',
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: headerColor,
                          ),
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 20),
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
                        color: Colors.white,
                        child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 70, top: 10),
                                child: SizedBox(
                                    height: 50,
                                    width: 340,
                                    child: exerciseProvider.providerDay ==
                                            DateTime.now().weekday
                                        ? ElevatedButton(
                                            onPressed: () => {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      isScrollControlled: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return SingleChildScrollView(
                                                            child: Padding(
                                                          padding: EdgeInsets.only(
                                                              bottom: MediaQuery
                                                                      .of(context)
                                                                  .viewInsets
                                                                  .bottom),
                                                          child:
                                                              const AddExercisedDialog(),
                                                        ));
                                                      })
                                                },
                                            style: OutlinedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor: primaryColor
                                                    .withOpacity(0.9)),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child: Text(
                                                    "Add Exercise for ${expandedWeekdays[DateTime.now().weekday - 1]}",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold))))
                                        : const SizedBox()))),
                      )),
                  exerciseProvider.exerciseList.isEmpty
                      ? Center(
                          child: exerciseProvider.isProviderDayToday()
                              ? Container(
                                  height: 200,
                                  width: 200,
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/app-icon-faded.png'))),
                                )
                              : CustomText(
                                  text: 'No Exercise Added on This Day',
                                  fontSize: 40,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor.withOpacity(0.5),
                                ),
                        )
                      : const SizedBox()
                ],
              ),
            ],
          )
        : const ScreenShimmer();
  }
}
