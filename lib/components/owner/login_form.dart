import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/owner/owner.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  bool showEmailPasswordNotMatchedError = false;
  String? contactError;
  String? passwordError;

  bool validateForm() {
    setState(() {
      contactError = contactValidator(_contactController.text);
      passwordError = validateSimpleText(_passwordController.text, "Password");
    });
    if (contactError != null || passwordError != null) {
      return false;
    }
    return true;
  }

  onLoginButtonPressed() async {
    bool isInformationValidated = validateForm();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (isInformationValidated) {
      LoginResponse loginResponse = LoginResponse.fromJson(await backendAPICall(
          '/owner/login',
          {
            'contact': _contactController.text,
            'password': _passwordController.text,
            'deviceToken': sharedPreferences.getString("fcmToken")
          },
          'POST',
          false));

      if (loginResponse.jwtToken != null) {
        var sharedPreferences = await SharedPreferences.getInstance();

        sharedPreferences.setString("jwtToken", loginResponse.jwtToken ?? "");
        sharedPreferences.setString("userName", loginResponse.name ?? "Owner");
        await sharedPreferences.setString(
            "gymName", loginResponse.gymName ?? "Gym");
        await sharedPreferences.setString(
            'ownerContact', loginResponse.contact ?? "");
        if (loginResponse.lat != null) {
          sharedPreferences.setBool('isLocationPermissionGiven', true);
        }
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const OwnerScreen()));
        }
      } else {
        setState(() {
          showEmailPasswordNotMatchedError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.98),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30, bottom: 12),
            child: Text(
              "Gym Buddy",
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  color: headingColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              "Welcome Back",
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  color: headingColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 30, bottom: 15, right: 30),
            child: LabeledTextField(
              labelText: "Contact",
              textInputType: TextInputType.number,
              textInputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10)
              ],
              controller: _contactController,
              errorText: contactError,
              textColour: headingColor,
              borderColor: headingColor,
              cursorColor: headingColor,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: LabeledTextField.passwordField(
              labelText: "Password",
              controller: _passwordController,
              errorText: passwordError,
              textColour: headingColor,
              borderColor: headingColor,
              cursorColor: headingColor,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: showEmailPasswordNotMatchedError
                ? const Text("Contact or password does not match",
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 15))
                : const SizedBox(),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50, top: 30),
              child: SizedBox(
                height: 50,
                width: 178,
                child: ElevatedButton(
                  onPressed: onLoginButtonPressed,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: headingColor,
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
    );
  }
}
