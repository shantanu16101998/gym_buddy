import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/attendance_calendar.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/image_dialog.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/owner/owner.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/owner/subscription_dialog.dart';
import 'package:shimmer/shimmer.dart';

class Profile extends StatefulWidget {
  final String userId;
  const Profile({super.key, required this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserProfileResponse userProfileResponse = const UserProfileResponse(
      name: "Suraj Kumar",
      phone: "7424948001",
      profilePic: null,
      validTill: null,
      startDate: null,
      traineeName: null);

  bool isApiDataLoaded = false;
  bool isImageExpanded = false;
  ImageProvider<Object> image = const NetworkImage(
      "https://appcraft.s3.ap-south-1.amazonaws.com/profile_default");

  fetchProfileDetails() async {
    var userProfileApiResponse = UserProfileResponse.fromJson(
        await backendAPICall('/customer/getCustomerProfile/${widget.userId}',
            null, 'GET', true));

    setState(() {
      userProfileResponse = userProfileApiResponse;
      isApiDataLoaded = true;
      image = userProfileResponse.profilePic == null
          ? const AssetImage("assets/images/profile_default.png")
              as ImageProvider<Object>
          : NetworkImage(userProfileResponse.profilePic ??
              "https://appcraft.s3.ap-south-1.amazonaws.com/profile_default");
    });
  }

  _onDeleteUserPressed() async {
    await backendAPICall(
        "/customer/deleteCustomer/${widget.userId}", {}, "DELETE", true);
    if (mounted) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const OwnerScreen()));
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfileDetails();
  }

  void changeImage(ImageProvider<Object> newImage) {
    setState(() {
      image = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isApiDataLoaded: isApiDataLoaded,
      noSpaceForStatusBar: false,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 450,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(width: 1, color: Color(0xffD9D9D9)))),
                child: !isApiDataLoaded
                    ? SizedBox(
                        height: 200.0,
                        child: Shimmer.fromColors(
                          baseColor: const Color.fromARGB(255, 255, 255, 255),
                          highlightColor:
                              const Color.fromARGB(255, 227, 227, 226),
                          child: Container(
                            height: 20,
                            width: 100,
                            color: Colors.white,
                          ),
                        ))
                    : AttendanceCalendar(customerId: widget.userId),
              ),
              const SizedBox(height: 70),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 30.0, 12.0, 24.0),
                    child: !isApiDataLoaded
                        ? SizedBox(
                            width: 300.0,
                            height: 200.0,
                            child: Shimmer.fromColors(
                              baseColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              highlightColor:
                                  const Color.fromARGB(255, 227, 227, 226),
                              child: Container(
                                height: 20,
                                width: 100,
                                color: Colors.white,
                              ),
                            ))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const CustomText(
                                      text: 'Name:',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: headingColor),
                                  const SizedBox(height: 20),
                                  const CustomText(
                                      text: 'Contact:',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: headingColor),
                                  userProfileResponse.traineeName != null
                                      ? const SizedBox(height: 20)
                                      : const SizedBox(),
                                  userProfileResponse.traineeName != null
                                      ? const CustomText(
                                          text: 'Mentor:',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22,
                                          color: headingColor)
                                      : const SizedBox(),
                                  const SizedBox(height: 20),
                                  const CustomText(
                                      text: 'Start Date:',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: headingColor),
                                  const SizedBox(height: 20),
                                  const CustomText(
                                      text: 'Plan:',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: headingColor),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(userProfileResponse.name,
                                      style: GoogleFonts.inter(
                                          textStyle:
                                              const TextStyle(fontSize: 22))),
                                  const SizedBox(height: 20),
                                  Text(userProfileResponse.phone,
                                      style: GoogleFonts.inter(
                                          textStyle:
                                              const TextStyle(fontSize: 22))),
                                  userProfileResponse.traineeName != null
                                      ? const SizedBox(height: 20)
                                      : const SizedBox(),
                                  userProfileResponse.traineeName != null
                                      ? Text(
                                          userProfileResponse.traineeName ?? "",
                                          style: GoogleFonts.inter(
                                              textStyle: const TextStyle(
                                                  fontSize: 22)))
                                      : const SizedBox(),
                                  const SizedBox(height: 20),
                                  Text(userProfileResponse.startDate ?? "",
                                      style: GoogleFonts.inter(
                                          textStyle:
                                              const TextStyle(fontSize: 22))),
                                  const SizedBox(height: 20),
                                  Text(
                                      '${userProfileResponse.validTill ?? 0} months',
                                      style: GoogleFonts.inter(
                                          textStyle:
                                              const TextStyle(fontSize: 22))),
                                ],
                              )
                            ],
                          ),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(bottom: 25),
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
                            context: context,
                            builder: (BuildContext context) {
                              return SubscriptionDialog(userId: widget.userId);
                            });
                      },
                      child: Text('Update Subscription',
                          style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: headingColor))),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SizedBox(
                    height: 45,
                    width: 300,
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 2, color: Color(0xffD0D5DD)),
                              borderRadius: BorderRadius.circular(20)),
                          textStyle: const TextStyle(
                              fontSize: 22,
                              color: Color(0xffB01D1D),
                              fontWeight: FontWeight.bold)),
                      onPressed: _onDeleteUserPressed,
                      child: Text('Delete user',
                          style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Color(0xffB01D1D)))),
                    ),
                  )),
              const SizedBox(height: 50)
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 400),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => ImageDialog(
                              image: image,
                              changeImage: changeImage,
                              customerId: widget.userId,
                            ))
                  },
                  child: !isApiDataLoaded
                      ? Container(
                          width: getScreenHeight(context) * 0.15,
                          height: getScreenHeight(context) * 0.15,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(70),
                              border: Border.all(
                                color: const Color(0xffD9D9D9),
                              )),
                        )
                      : Container(
                          width: getScreenHeight(context) * 0.15,
                          height: getScreenHeight(context) * 0.15,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: const Color(0xffD9D9D9)),
                            borderRadius: BorderRadius.circular(70),
                            image:
                                DecorationImage(image: image, fit: BoxFit.fill),
                          ),
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
