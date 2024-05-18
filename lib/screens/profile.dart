import 'package:flutter/material.dart';
import 'package:gym_buddy/components/app_scaffold.dart';
import 'package:gym_buddy/components/image_dialog.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/subscription_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  final String userId;
  const Profile({super.key, required this.userId});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  UserProfileResponse userProfileResponse = const UserProfileResponse(
      name: "Suraj Kumar",
      email: "email",
      address: "address",
      age: "age",
      phone: "7424948001",
      bloodGroup: "bloodGroup",
      gender: "Male",
      profilePic: null);

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
          ? AssetImage(userProfileResponse.gender == "Male"
              ? "assets/images/profile_default.png"
              : "assets/images/profile_default.png") as ImageProvider<Object>
          : NetworkImage(userProfileResponse.profilePic ??
              "https://appcraft.s3.ap-south-1.amazonaws.com/profile_default");
    });
  }

  _onDeleteUserPressed() async {
    await backendAPICall(
        "/customer/deleteCustomer/${widget.userId}", null, "DELETE", true);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Subscription()));
  }

  _openWhatsappLink() async {
    await launchUrl(Uri(
        host: 'wa.me',
        path: '+91${userProfileResponse.phone}',
        scheme: 'https',
        queryParameters: {'text': textToSend(userProfileResponse.name)}));
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
    return AppScaffold.noHeader(
      isApiDataLoaded: isApiDataLoaded,
      noSpaceForStatusBar: true,
      child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/gym_background.jpg"),
                          fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(height: 70),
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(30.0, 16.0, 12.0, 24.0),
                        child: SizedBox(
                          width: 250,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Text(userProfileResponse.name,
                                      style: GoogleFonts.inter(
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: Color(0xff004576))))),
                              Icon(
                                  userProfileResponse.gender == "Male"
                                      ? Icons.male
                                      : Icons.female,
                                  color: Color(0xff004576),
                                  size: 35),
                            ],
                          ),
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
                                  return SubscriptionDialog(
                                      userId: widget.userId);
                                });
                          },
                          child: Text('Update Subscription',
                              style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Color(0xff004576)))),
                        ),
                      )),
                  Container(
                    width: 250,
                    // color: Color.fromARGB(255, 1, 10, 26),
                    child: Column(
                      children: [
                        isTrueString(userProfileResponse.address)
                            ? Padding(
                                padding: const EdgeInsets.all(13),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.location_on,
                                        color: Color(0xff004576)),
                                    SizedBox(
                                        width: getScreenWidth(context) * 0.03),
                                    Flexible(
                                      child: Text(userProfileResponse.address!,
                                          style: GoogleFonts.inter(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Color(0xff544C4C)))),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        Padding(
                          padding: const EdgeInsets.all(13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.email, color: Color(0xff004576)),
                              SizedBox(width: getScreenWidth(context) * 0.03),
                              Flexible(
                                child: Text(userProfileResponse.email,
                                    style: GoogleFonts.inter(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            color: Color(0xff544C4C)))),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.phone, color: Color(0xff004576)),
                              SizedBox(width: getScreenWidth(context) * 0.03),
                              Flexible(
                                child: Text(userProfileResponse.phone,
                                    style: GoogleFonts.inter(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            color: Color(0xff544C4C)))),
                              )
                            ],
                          ),
                        ),
                        isTrueString(userProfileResponse.age)
                            ? Padding(
                                padding: const EdgeInsets.all(13),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.cake,
                                        color: Color(0xff004576)),
                                    SizedBox(
                                        width: getScreenWidth(context) * 0.03),
                                    Flexible(
                                      child: Text(
                                          "${userProfileResponse.age} years old",
                                          style: GoogleFonts.inter(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Color(0xff544C4C)))),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        isTrueString(userProfileResponse.bloodGroup)
                            ? Padding(
                                padding: const EdgeInsets.all(13),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.bloodtype,
                                        color: Color(0xff004576)),
                                    SizedBox(
                                        width: getScreenWidth(context) * 0.03),
                                    Flexible(
                                      child: Text(
                                          userProfileResponse.bloodGroup!,
                                          style: GoogleFonts.inter(
                                              textStyle: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 18,
                                                  color: Color(0xff544C4C)))),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
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
                padding: EdgeInsets.only(top: 100),
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
                      child: Container(
                        width: getScreenHeight(context) * 0.15,
                        height: getScreenHeight(context) * 0.15,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: const Color.fromARGB(255, 255, 255, 255)),
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
          )),
    );
  }
}
