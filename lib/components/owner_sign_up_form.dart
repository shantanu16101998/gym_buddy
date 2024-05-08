import 'package:gym_buddy/components/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerFormForm extends StatefulWidget {
  final Function setShouldShowFurtherInformation;
  final TextEditingController nameController;
  const OwnerFormForm(
      {super.key,
      required this.setShouldShowFurtherInformation,
      required this.nameController});

  @override
  State<OwnerFormForm> createState() => _OwnerFormFormState();
}

class _OwnerFormFormState extends State<OwnerFormForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  String? nameError;

  onNextButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(
          "ownerName", widget.nameController.text);
      await sharedPreferences.setString("ownerEmail", _emailController.text);
      await sharedPreferences.setString(
          "ownerPassword", _passwordController.text);
      widget.setShouldShowFurtherInformation(true);
    }
  }

  bool validateForm() {
    setState(() {
      emailError = validateEmailId(_emailController.text);
      passwordError = validateSimpleText(_passwordController.text, "Password");
      nameError = validateSimpleText(widget.nameController.text, "Name");
    });
    if (emailError != null || passwordError != null || nameError != null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 85, 84, 84).withOpacity(0.98),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(left: 30, top: 30, bottom: 12),
              child: Text("Register your gym",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                    color: Color(0xffFFFFFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  )))),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text("Welcome",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.normal,
                          fontSize: 18)))),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 30, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Name",
                  controller: widget.nameController,
                  errorText: nameError)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Email",
                  controller: _emailController,
                  errorText: emailError)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField.passwordField(
                  labelText: "Password",
                  controller: _passwordController,
                  errorText: passwordError)),
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: SizedBox(
                      height: 50,
                      width: 178,
                      child: ElevatedButton(
                          onPressed: onNextButtonPressed,
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFD9D9D9)),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Next",
                                  style: TextStyle(
                                      color: Color(0xff004576),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))))))
        ]));
  }
}
