import 'package:gym_buddy/components/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:flutter/services.dart';

class OwnerFurtherInformationForm extends StatefulWidget {
  final TextEditingController nameController;

  const OwnerFurtherInformationForm({super.key, required this.nameController});

  @override
  State<OwnerFurtherInformationForm> createState() =>
      _OwnerFurtherInformationFormState();
}

class _OwnerFurtherInformationFormState
    extends State<OwnerFurtherInformationForm> {
  final TextEditingController _gymNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _upiIdController = TextEditingController();

  String? gymNameError;
  String? addressError;
  String? contactError;
  String? upiIdError;

  onSignUpButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      var sharedPreferences = await SharedPreferences.getInstance();

      var ownerName = sharedPreferences.getString("ownerName") ?? "";
      var ownerEmail = sharedPreferences.getString("ownerEmail") ?? "";
      var ownerPassword = sharedPreferences.getString("ownerPassword") ?? "";
      await sharedPreferences.setString("gymName", _gymNameController.text);


      OwnerRegistrationResponse ownerRegistrationResponse = OwnerRegistrationResponse.fromJson(await backendAPICall(
          '/owner/signup',
          {
            'ownerName': ownerName,
            'email': ownerEmail,
            'password': ownerPassword,
            'gymName': _gymNameController.text,
            'contact': _contactController.text,
            'address': _addressController.text,
            'upiId' : _upiIdController.text,
            'token': sharedPreferences.getString("fcmToken")
          },
          'POST',
          true));

        await sharedPreferences.setString("jwtToken", ownerRegistrationResponse.jwtToken ?? "");

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const Subscription()));
    }
  }

  bool validateForm() {
    setState(() {
      gymNameError = validateSimpleText(_gymNameController.text, "Gym Name");
      addressError = validateSimpleText(_addressController.text, "Address");
      contactError = validateSimpleText(_contactController.text, "Contact");
      upiIdError = validateSimpleText(_contactController.text, "UPI Id");
    });
    if (gymNameError != null ||
        addressError != null ||
        contactError != null ||
        upiIdError != null) {
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
                  errorText: null)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Contact",
                  textInputType: TextInputType.number,
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                  controller: _contactController,
                  errorText: contactError)),
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
                  labelText: "UPI Id",
                  controller: _upiIdController,
                  errorText: upiIdError)),
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: SizedBox(
                      height: 50,
                      width: 178,
                      child: ElevatedButton(
                          onPressed: onSignUpButtonPressed,
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFD9D9D9)),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Sign Up",
                                  style: TextStyle(
                                      color: Color(0xff004576),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))))))
        ]));
  }
}
