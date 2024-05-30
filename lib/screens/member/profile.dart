import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/attendance_calendar.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  MemberProfileResponse memberProfileResponse = MemberProfileResponse(
      name: '', contact: '', startDate: '', validTill: 0, trainerName: '',currentWeekAttendance: '');

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
    return AppScaffold.noHeader(
      isApiDataLoaded: isApiDataLoaded,
      child: Column(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CustomText(
                            text: 'Name:',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xff004576)),
                        SizedBox(height: 20),
                        CustomText(
                            text: 'Contact:',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xff004576)),
                        SizedBox(height: 20),
                        CustomText(
                            text: 'Mentor:',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xff004576)),
                        SizedBox(height: 20),
                        CustomText(
                            text: 'Start Date:',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xff004576)),
                        SizedBox(height: 20),
                        CustomText(
                            text: 'Plan:',
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Color(0xff004576)),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(memberProfileResponse.name,
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(fontSize: 22))),
                        const SizedBox(height: 20),
                        Text(memberProfileResponse.contact,
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(fontSize: 22))),
                        const SizedBox(height: 20),
                        Text(memberProfileResponse.trainerName,
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(fontSize: 22))),
                        const SizedBox(height: 20),
                        Text(memberProfileResponse.startDate,
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(fontSize: 22))),
                        const SizedBox(height: 20),
                        Text(
                            '${memberProfileResponse.validTill.toString()} months',
                            style: GoogleFonts.inter(
                                textStyle: const TextStyle(fontSize: 22))),
                      ],
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
