import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
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

class _OwnerAdditionalDetailsState extends State<OwnerAdditionalDetails> {
  final TextEditingController _gymNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  HaveTrainee? _haveTrainee = HaveTrainee.yes;

  String? gymNameError;
  String? addressError;
  String? contactError;
  String? upiIdError;

  bool showValidationError = false;

  onNextButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      var sharedPreferences = await SharedPreferences.getInstance();

      var ownerName = sharedPreferences.getString("ownerName") ?? "";
      var ownerEmail = sharedPreferences.getString("ownerEmail") ?? "";
      var ownerPassword = sharedPreferences.getString("ownerPassword") ?? "";
      var ownerContact = sharedPreferences.getString("ownerContact") ?? "";

      await sharedPreferences.setString("gymName", _gymNameController.text);

      OwnerRegistrationResponse ownerRegistrationResponse =
          OwnerRegistrationResponse.fromJson(await backendAPICall(
              '/owner/signup',
              {
                'ownerName': ownerName,
                'email': ownerEmail,
                'password': ownerPassword,
                'gymName': _gymNameController.text,
                'contact': ownerContact,
                'address': _addressController.text,
                'upiId': _upiIdController.text,
                'token': sharedPreferences.getString("fcmToken")
              },
              'POST',
              true));

      await sharedPreferences.setString(
          "jwtToken", ownerRegistrationResponse.jwtToken ?? "");

      if (_haveTrainee == HaveTrainee.yes) {
        widget.formStateChanger(OwnerFormState.traineeDetails);
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Subscription()));
      }
    } else {
      setState(() {
        showValidationError = true;
      });
    }
  }

  bool validateForm() {
    setState(() {
      gymNameError = validateSimpleText(_gymNameController.text, "Gym Name");
      addressError = validateSimpleText(_addressController.text, "Address");
    });
    if (gymNameError != null || addressError != null) {
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
              child: Text("Hi ${widget.nameController.text}",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                    color: Color(0xffFFFFFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  )))),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text("Enter further details",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.normal,
                          fontSize: 18)))),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 30, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Gym Name",
                  controller: _gymNameController,
                  errorText: gymNameError)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Address",
                  controller: _addressController,
                  errorText: addressError)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "UPI Id (optional)",
                  controller: _upiIdController,
                  errorText: null)),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text("Do you have trainee ?",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.normal,
                          fontSize: 18)))),
          Padding(
              padding:
                  EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
              child: Column(
                children: [
                  ListTile(
                    leading: Radio<HaveTrainee>(
                      fillColor: MaterialStateProperty.all<Color>(Colors.white),
                      value: HaveTrainee.yes,
                      groupValue: _haveTrainee,
                      onChanged: (HaveTrainee? value) {
                        setState(() {
                          _haveTrainee = value;
                        });
                      },
                    ),
                    title: const CustomText(
                        text: 'Yes', fontSize: 18, color: Color(0xffFFFFFF)),
                  ),
                  ListTile(
                    leading: Radio<HaveTrainee>(
                      fillColor: MaterialStateProperty.all<Color>(Colors.white),
                      value: HaveTrainee.no,
                      groupValue: _haveTrainee,
                      onChanged: (HaveTrainee? value) {
                        setState(() {
                          _haveTrainee = value;
                        });
                      },
                    ),
                    title: const CustomText(
                        text: 'No', fontSize: 18, color: Color(0xffFFFFFF)),
                  ),
                ],
              )),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: showValidationError
                ? Text(formNotValidated,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 17, 0),
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