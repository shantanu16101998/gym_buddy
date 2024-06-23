import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:gym_buddy/constants/url.dart';

class OwnerAdditionalDetails extends StatefulWidget {
  final TextEditingController nameController;
  final Function formStateChanger;

  const OwnerAdditionalDetails(
      {super.key,
      required this.nameController,
      required this.formStateChanger});

  @override
  State<OwnerAdditionalDetails> createState() => _OwnerAdditionalDetailsState();
}

enum HaveTrainee { yes, no }

enum InsideGym { yes, no }

class _OwnerAdditionalDetailsState extends State<OwnerAdditionalDetails> {
  final TextEditingController _gymNameController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  String? gymNameError;
  String? contactError;
  String? upiIdError;


  bool showValidationError = false;

  onNextButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      var sharedPreferences = await SharedPreferences.getInstance();

      sharedPreferences.setString('gymName', _gymNameController.text);
      sharedPreferences.setString('upiId', _upiIdController.text);
      widget.formStateChanger(OwnerFormState.traineeDetails);
    } else {
      setState(() {
        showValidationError = true;
      });
    }
  }

  bool validateForm() {
    setState(() {
      gymNameError = validateSimpleText(_gymNameController.text, "Gym Name");
    });
    if (gymNameError != null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white.withOpacity(0.98),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(left: 30, top: 30, bottom: 12),
              child: Text("Hi ${widget.nameController.text}",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                    color: headingColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  )))),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text("Enter further details",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          color: headingColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 18)))),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 30, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Gym Name",
                  textColour: headingColor,
                  borderColor: headingColor,
                  cursorColor: headingColor,
                  controller: _gymNameController,
                  errorText: gymNameError)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "UPI Id",
                  textColour: headingColor,
                  borderColor: headingColor,
                  cursorColor: headingColor,
                  controller: _upiIdController,
                  errorText: null)),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: showValidationError
                ? Text(formNotValidated,
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
                      child: OutlinedButton(
                          onPressed: onNextButtonPressed,
                          style: OutlinedButton.styleFrom(
                              elevation: 0, backgroundColor: headingColor),
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
