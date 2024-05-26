import 'package:flutter/services.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_buddy/constants/url.dart';

class OwnerBasicDetailsForm extends StatefulWidget {
  final Function formStateChanger;
  final TextEditingController nameController;
  const OwnerBasicDetailsForm(
      {super.key,
      required this.formStateChanger,
      required this.nameController});

  @override
  State<OwnerBasicDetailsForm> createState() => _OwnerBasicDetailsFormState();
}

class _OwnerBasicDetailsFormState extends State<OwnerBasicDetailsForm> {
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? contactError;
  String? passwordError;
  String? nameError;
  String? showValidationError;

  onNextButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString(
          "userName", widget.nameController.text);
      await sharedPreferences.setString(
          "ownerContact", _contactController.text);
      await sharedPreferences.setString(
          "ownerPassword", _passwordController.text);

      DuplicateEmailCheckResponse response =
          DuplicateEmailCheckResponse.fromJson(await backendAPICall(
              '/owner/contactDuplicateCheck/${_contactController.text}',
              {},
              'GET',
              false));

      if (response.unique) {
        widget.formStateChanger(OwnerFormState.additionalDetails);
      } else {
        setState(() {
          showValidationError = 'Contact already exists please log in';
        });
      }
    } else {
      setState(() {
        showValidationError = formNotValidated;
      });
    }
  }

  bool validateForm() {
    setState(() {
      contactError = contactValidator(_contactController.text);
      passwordError = validateSimpleText(_passwordController.text, "Password");
      nameError = validateSimpleText(widget.nameController.text, "Name");
    });
    if (contactError != null || passwordError != null || nameError != null) {
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
                  labelText: "Contact",
                  textInputType: TextInputType.number,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                  controller: _contactController,
                  errorText: contactError)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField.passwordField(
                  labelText: "Password",
                  controller: _passwordController,
                  errorText: passwordError)),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: showValidationError != null
                ? Text(showValidationError ?? "",
                    style: const TextStyle(
                        color: formValidationErrorColor,
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
