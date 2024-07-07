import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/attendance_calendar.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/common/screen_shimmer.dart';
import 'package:gym_buddy/components/member/referral_dialog.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  MemberProfileResponse memberProfileResponse = MemberProfileResponse(
      name: '',
      contact: '',
      startDate: '',
      validTill: 0,
      trainerName: '',
      currentWeekAttendance: '',
      gymLocationLat: 0,
      gymLocationLon: 0);

  bool isApiDataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchProfileDetails();
  }

  fetchProfileDetails() async {
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
    return isApiDataLoaded
        ? Column(
            children: [
              const Center(child: AttendanceCalendar()),
              Container(
                  decoration: const BoxDecoration(
                      border: Border(
                    top: BorderSide(
                      color: Color(0xffDBDDE2),
                      width: 1.0,
                    ),
                  )),
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: getScreenWidth(context) * 0.8,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffD0D5DD)))),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        text: 'Name',
                                        fontSize: 16,
                                        color: Color(0xff7A7F93),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: CustomText(
                                          text: memberProfileResponse.name,
                                          fontSize: 22,
                                          color: primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: getScreenWidth(context) * 0.8,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffD0D5DD)))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        text: 'Contact',
                                        fontSize: 16,
                                        color: Color(0xff7A7F93),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: CustomText(
                                          text:
                                              '+91 ${memberProfileResponse.contact}',
                                          fontSize: 22,
                                          color: primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: getScreenWidth(context) * 0.8,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffD0D5DD)))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        text: 'Start Date',
                                        fontSize: 16,
                                        color: Color(0xff7A7F93),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: CustomText(
                                          text: memberProfileResponse.startDate,
                                          fontSize: 22,
                                          color: primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: getScreenWidth(context) * 0.8,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Color(0xffD0D5DD)))),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 30, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const CustomText(
                                        text: 'Plan',
                                        fontSize: 16,
                                        color: Color(0xff7A7F93),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: CustomText(
                                          text:
                                              '${memberProfileResponse.validTill} ${memberProfileResponse.validTill == 1 ? 'month' : 'months'}',
                                          fontSize: 22,
                                          color: primaryColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              if (memberProfileResponse.trainerName != null)
                                Container(
                                  width: getScreenWidth(context) * 0.8,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color(0xffD0D5DD)))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30, bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const CustomText(
                                          text: 'Mentor',
                                          fontSize: 16,
                                          color: Color(0xff7A7F93),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: CustomText(
                                            text:
                                                '${memberProfileResponse.trainerName}',
                                            fontSize: 22,
                                            color: primaryColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          )))),
              Padding(
                  padding: const EdgeInsets.only(top: 100, bottom: 100),
                  child: SizedBox(
                      height: 45,
                      width: 300,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 2, color: Color(0xffD0D5DD)),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 22,
                                color: Color(0xffB01D1D),
                                fontWeight: FontWeight.bold,
                              )),
                          onPressed: () {
                            showModalBottomSheet<void>(
                                elevation: 0,
                                context: context,
                                builder: (BuildContext context) {
                                  return const ReferralDialog();
                                });
                          },
                          child: Text('Refer a friend',
                              style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: primaryColor)))))),
            ],
          )
        : const ScreenShimmer();
  }
}
