import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/owner/owner.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
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
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  HaveTrainee? _haveTrainee;
  InsideGym? _insideGym;

  String? gymNameError;
  String? addressError;
  String? contactError;
  String? upiIdError;

  bool haveTraineeOptionValid = true;
  bool insideGymOptionValid = true;

  bool showValidationError = false;

  bool locationPermissionGivenWhenAsked = true;
  bool isLocationPermissionNeeded = false;

  Future<LocationResult> onLocationPermissionPressed() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    LocationResult result = await getCurrentLocationSuccess();
    bool verdict = result.success;
    sharedPreferences.setDouble("latitude", result.latitude);
    sharedPreferences.setDouble("longitude", result.longitude);
    sharedPreferences.setBool('isLocationPermissionGiven', verdict);
    setState(() {
      locationPermissionGivenWhenAsked = verdict;
    });
    return result;
  }

  onNextButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      var sharedPreferences = await SharedPreferences.getInstance();

      if (_haveTrainee == HaveTrainee.yes) {
        sharedPreferences.setString('gymName', _gymNameController.text);
        sharedPreferences.setString('address', _addressController.text);
        sharedPreferences.setString('upiId', _upiIdController.text);
        sharedPreferences.setBool('insideGym', _insideGym == InsideGym.yes);
        widget.formStateChanger(OwnerFormState.traineeDetails);
      } else {
        var userName = sharedPreferences.getString("userName") ?? "";
        var ownerPassword = sharedPreferences.getString("ownerPassword") ?? "";
        var ownerContact = sharedPreferences.getString("ownerContact") ?? "";

        await sharedPreferences.setString("gymName", _gymNameController.text);
        await sharedPreferences.setString("address", _addressController.text);
        await sharedPreferences.setString("upiId", _upiIdController.text);

        OwnerRegistrationResponse ownerRegistrationResponse =
            OwnerRegistrationResponse.fromJson(await backendAPICall(
                '/owner/signup',
                {
                  'name': userName.trim(),
                  'password': ownerPassword.trim(),
                  'gymName': _gymNameController.text.trim(),
                  'contact': ownerContact.trim(),
                  'address': _addressController.text.trim(),
                  'upiId': _upiIdController.text.trim(),
                  'token': sharedPreferences.getString("fcmToken"),
                  if (_insideGym ==  InsideGym.yes &&  sharedPreferences.getDouble("latitude") != null)
                    'lat': sharedPreferences.getDouble("latitude"),
                  if (_insideGym ==  InsideGym.yes && sharedPreferences.getDouble("longitude") != null)
                    'lon': sharedPreferences.getDouble("longitude"),
                  'trainees': []
                },
                'POST',
                true));

        await sharedPreferences.setString(
            "jwtToken", ownerRegistrationResponse.jwtToken ?? "");

        sharedPreferences.setString(
            'gymName', ownerRegistrationResponse.gymName ?? "Gym");
        if (mounted) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const OwnerScreen()));
        }
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

      haveTraineeOptionValid = _haveTrainee != null;
      insideGymOptionValid = _insideGym != null;
    });
    if (gymNameError != null ||
        addressError != null ||
        !haveTraineeOptionValid ||
        !insideGymOptionValid ||
        (isLocationPermissionNeeded && !locationPermissionGivenWhenAsked)) {
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
                  labelText: "Address",
                  textColour: headingColor,
                  borderColor: headingColor,
                  cursorColor: headingColor,
                  controller: _addressController,
                  errorText: addressError)),
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
              padding: const EdgeInsets.only(left: 30),
              child: Text("Do you have trainee ?",
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          color: haveTraineeOptionValid
                              ? headingColor
                              : formValidationErrorColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 18)))),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: Column(
                children: [
                  ListTile(
                    leading: Radio<HaveTrainee>(
                      fillColor: MaterialStateProperty.all<Color>(headingColor),
                      value: HaveTrainee.yes,
                      groupValue: _haveTrainee,
                      onChanged: (HaveTrainee? value) {
                        setState(() {
                          _haveTrainee = value;
                        });
                      },
                    ),
                    title: const CustomText(
                        text: 'Yes', fontSize: 18, color: headingColor),
                  ),
                  ListTile(
                    leading: Radio<HaveTrainee>(
                      fillColor: MaterialStateProperty.all<Color>(headingColor),
                      value: HaveTrainee.no,
                      groupValue: _haveTrainee,
                      onChanged: (HaveTrainee? value) {
                        setState(() {
                          _haveTrainee = value;
                        });
                      },
                    ),
                    title: const CustomText(
                        text: 'No', fontSize: 18, color: headingColor),
                  ),
                ],
              )),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text("Are you inside gym ?",
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          color: insideGymOptionValid
                              ? headingColor
                              : formValidationErrorColor,
                          fontWeight: FontWeight.normal,
                          fontSize: 18)))),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: Column(
                children: [
                  ListTile(
                    leading: Radio<InsideGym>(
                      fillColor: MaterialStateProperty.all<Color>(headingColor),
                      value: InsideGym.yes,
                      groupValue: _insideGym,
                      onChanged: (InsideGym? value) {
                        onLocationPermissionPressed();
                        setState(() {
                          isLocationPermissionNeeded = true;
                          locationPermissionGivenWhenAsked = false;
                          _insideGym = value;
                          print(_insideGym);
                        });
                      },
                    ),
                    title: const CustomText(
                        text: 'Yes', fontSize: 18, color: headingColor),
                  ),
                  ListTile(
                    leading: Radio<InsideGym>(
                      fillColor: MaterialStateProperty.all<Color>(headingColor),
                      value: InsideGym.no,
                      groupValue: _insideGym,
                      onChanged: (InsideGym? value) {
                        setState(() {
                          _insideGym = value;
                        });
                      },
                    ),
                    title: const CustomText(
                        text: 'No', fontSize: 18, color: headingColor),
                  ),
                ],
              )),
          _insideGym == InsideGym.yes && isLocationPermissionNeeded
              ? Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 30),
                      child: SizedBox(
                          child: ElevatedButton(
                              onPressed: onLocationPermissionPressed,
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.transparent,
                                  side: BorderSide(
                                      width: 1,
                                      color: locationPermissionGivenWhenAsked
                                          ? headingColor
                                          : formValidationErrorColor)),
                              child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text("Grant Location Permission",
                                      style: TextStyle(
                                          color: headingColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)))))))
              : const SizedBox(),
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
