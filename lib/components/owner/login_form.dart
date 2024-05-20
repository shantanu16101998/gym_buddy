import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool showEmailPasswordNotMatchedError = false;
  String? emailError;
  String? passwordError;

  bool validateForm() {
    setState(() {
      emailError = validateSimpleText(_emailController.text, "Email");
      passwordError = validateSimpleText(_passwordController.text, "Password");
    });
    if (emailError != null || passwordError != null) {
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
            'email': _emailController.text,
            'password': _passwordController.text,
            'deviceToken': sharedPreferences.getString("fcmToken")
          },
          'POST',
          false));

      if (loginResponse.jwtToken != null) {
        var sharedPreferences = await SharedPreferences.getInstance();

        sharedPreferences.setString("jwtToken", loginResponse.jwtToken ?? "");
        sharedPreferences.setString("ownerName", loginResponse.name ?? "Owner");

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Subscription()));
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
        color: const Color.fromARGB(255, 85, 84, 84).withOpacity(0.98),
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
                  color: Color(0xffFFFFFF),
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
                  color: Color(0xffFFFFFF),
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
              labelText: "Email",
              controller: _emailController,
              errorText: emailError,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: LabeledTextField.passwordField(
              labelText: "Password",
              controller: _passwordController,
              errorText: passwordError,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: showEmailPasswordNotMatchedError
                ? const Text("Email or password does not match",
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
                    backgroundColor: const Color(0xFFD9D9D9),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        color: Color(0xff004576),
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
