import 'package:flutter/material.dart';
import 'package:gym_buddy/components/app_scaffold.dart';
import 'package:gym_buddy/components/image_dialog.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/subscription_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      gender: "Male");

  bool isApiDataLoaded = false;
  bool isImageExpanded = false;
  ImageProvider<Object> image = const AssetImage("assets/images/bheem.jpg");


  textToSend() {
    return "Hi ${userProfileResponse.name}, we hope this message finds you well. We wanted to inform you that your gym subscription has ended. Please feel free to reach out to us if you have any questions or if you'd like to renew your subscription. Have a wonderful day!";
  }

  fetchProfileDetails() async {
    var userProfileApiResponse = UserProfileResponse.fromJson(
        await backendAPICall('/customer/getCustomerProfile/${widget.userId}',
            null, 'GET', true));

    setState(() {
      userProfileResponse = userProfileApiResponse;
      isApiDataLoaded = true;
      image = AssetImage(userProfileResponse.gender == "Male" ? "assets/images/bheem.jpg" : "assets/images/chutki.jpg");
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
        queryParameters: {'text': textToSend()}));
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
      child: Container(
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
                          image: AssetImage("assets/images/gym_background.jpg"),
                          fit: BoxFit.fill),
                    ),
                  ),
                  SizedBox(height: getScreenHeight(context) * 0.08),
                  Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(20.0, 16.0, 12.0, 24.0),
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
                  Padding(
                      padding: const EdgeInsets.only(top: 0),
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
                            ),
                          ),
                          onPressed: _openWhatsappLink,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Aligns children horizontally
                            children: [
                              Icon(FontAwesomeIcons.whatsapp,
                                  weight: 20,
                                  color: Color.fromARGB(255, 29, 176, 93)),
                              const SizedBox(width: 15),
                              Text(
                                'Message',
                                style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Color.fromARGB(255, 29, 176, 93),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Container(
                    width: 250,
                    // color: Color.fromARGB(255, 1, 10, 26),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on,
                                  color: Color(0xff004576)),
                              SizedBox(width: getScreenWidth(context) * 0.03),
                              Flexible(
                                child: Text(userProfileResponse.address,
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
                        Padding(
                          padding: const EdgeInsets.all(13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.cake, color: Color(0xff004576)),
                              SizedBox(width: getScreenWidth(context) * 0.03),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Icon(Icons.bloodtype,
                                  color: Color(0xff004576)),
                              SizedBox(width: getScreenWidth(context) * 0.03),
                              Flexible(
                                child: Text(userProfileResponse.bloodGroup,
                                    style: GoogleFonts.inter(
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                            color: Color(0xff544C4C)))),
                              )
                            ],
                          ),
                        ),
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
                padding: EdgeInsets.only(
                    top: getStatusBarHeight(context) +
                        getScreenHeight(context) * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => ImageDialog(
                                image: image, changeImage: changeImage))
                      },
                      child: Container(
                        width: getScreenHeight(context) * 0.1,
                        height: getScreenHeight(context) * 0.1,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 2,
                              color: const Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(60),
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
