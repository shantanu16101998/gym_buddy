import 'package:flutter/services.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
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
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? contactError;
  String? passwordError;
  String? nameError;
  String? showValidationError;
  String? confirmPasswordError;

  onNextButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("userName", widget.nameController.text);
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
          showValidationError = 'Contact already exists please log In';
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

      if (_passwordController.text != _confirmPasswordController.text) {
        confirmPasswordError = 'Passwords do not match';
      } else {
        confirmPasswordError = null;
      }
    });
    if (contactError != null ||
        passwordError != null ||
        nameError != null ||
        confirmPasswordError != null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 12),
              child: Center(
                child: Text("Register Gym",
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ))),
              )),
          Center(
              child: Text("Welcome!",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 18)))),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, top: 30, bottom: 15),
              child: Center(
                child: LabeledTextField(
                    labelText: "Owner Name",
                    controller: widget.nameController,
                    textColour: primaryColor,
                    borderColor: primaryColor,
                    cursorColor: primaryColor,
                    errorText: nameError),
              )),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Mobile Number",
                  textColour: primaryColor,
                  borderColor: primaryColor,
                  cursorColor: primaryColor,
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
                  textColour: primaryColor,
                  borderColor: primaryColor,
                  cursorColor: primaryColor,
                  controller: _passwordController,
                  errorText: passwordError)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField.passwordField(
                  labelText: "Confirm password",
                  textColour: primaryColor,
                  borderColor: primaryColor,
                  cursorColor: primaryColor,
                  controller: _confirmPasswordController,
                  errorText: confirmPasswordError)),
          if (showValidationError != null)
            Padding(
                padding: const EdgeInsets.only(
                    left: 30, top: 15, bottom: 15, right: 30),
                child: Text(showValidationError ?? "",
                    style: const TextStyle(
                        color: formValidationErrorColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15))),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                    text: 'Already have an account? ',
                    color: primaryColor,
                    fontSize: 16),
                GestureDetector(
                    onTap: () {
                      widget.formStateChanger(OwnerFormState.loginPage);
                    },
                    child: CustomText(
                        text: 'Log In',
                        color: primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold))
              ],
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: SizedBox(
                      height: 50,
                      width: 178,
                      child: OutlinedButton(
                          onPressed: onNextButtonPressed,
                          style: OutlinedButton.styleFrom(
                              elevation: 0, backgroundColor: primaryColor),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Next",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))))))
        ]));
  }
}
