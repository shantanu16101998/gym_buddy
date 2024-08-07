import 'package:flutter/material.dart';
import 'package:gym_buddy/constants/url.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/member/member.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:flutter/services.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberLoginForm extends StatefulWidget {
  const MemberLoginForm({super.key});

  @override
  State<MemberLoginForm> createState() => _MemberLoginFormState();
}

class _MemberLoginFormState extends State<MemberLoginForm> {
  final TextEditingController _contactController = TextEditingController();
  String? contactError;
  String? showValidationError;
  bool validateForm() {
    setState(() {
      contactError = contactValidator(_contactController.text);
    });

    if (contactError != null) {
      showValidationError = formNotValidated;
      return false;
    }

    return true;
  }

  onLoginButtonPressed() async {
    if (validateForm()) {
      MemberLoginResponse memberLoginResponse = MemberLoginResponse.fromJson(
          await backendAPICall('/customer/login',
              {'contact': _contactController.text.trim()}, 'POST', false));

      if (memberLoginResponse.name == null) {
        setState(() {
          showValidationError =
              'This number is not registered with our Gym Partners';
        });
      } else {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        if (memberLoginResponse.token != null) {
          sharedPreferences.setString(
              'jwtToken', memberLoginResponse.token ?? "");
          sharedPreferences.setString(
              'userName', memberLoginResponse.name ?? "");
        }
        if (mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const MemberScreen(
                        customerScreens: CustomerScreens.homepage,
                      )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          margin: EdgeInsets.only(top: getStatusBarHeight(context)),
          decoration: const BoxDecoration()),
      SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/designer.png"),
                  fit: BoxFit.cover,
                ),
              ),
              // color: primaryColor,
              height: getScreenHeight(context),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xffF5F5F5),
                            borderRadius: BorderRadius.circular(20),
                            // color: const Color.fromARGB(255, 85, 84, 84)
                            //     .withOpacity(0.98),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 30, bottom: 15, right: 30),
                                child: LabeledTextField(
                                  labelText: "Mobile Number",
                                  controller: _contactController,
                                  textInputType: TextInputType.number,
                                  textInputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  errorText: contactError,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 15, bottom: 15, right: 30),
                                child: showValidationError != null
                                    ? Text(showValidationError ?? "",
                                        style: const TextStyle(
                                            color: Color(0xffFF8C00),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15))
                                    : const SizedBox(),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 50, top: 20),
                                  child: SizedBox(
                                    height: 50,
                                    width: 178,
                                    child: OutlinedButton(
                                      onPressed: onLoginButtonPressed,
                                      style: OutlinedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: primaryColor,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Log In",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ])))
    ]));
  }
}
