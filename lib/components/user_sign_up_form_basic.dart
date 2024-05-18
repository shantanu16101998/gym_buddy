import 'package:gym_buddy/components/custom_image_picker.dart';
import 'package:gym_buddy/components/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/constants/url.dart';
import 'package:gym_buddy/screens/user_sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:flutter/services.dart';

class UserSignUpFormBasic extends StatefulWidget {
  final Function onPageToShowChange;

  const UserSignUpFormBasic({super.key, required this.onPageToShowChange});

  @override
  State<UserSignUpFormBasic> createState() => _UserSignUpFormBasicState();
}

class _UserSignUpFormBasicState extends State<UserSignUpFormBasic> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool showValidationError = false;

  String? _nameError;
  String? _emailError;
  String? _contactError;
  String? _addressError;

  onNextButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("userName", _nameController.text);
      await sharedPreferences.setString("userEmail", _emailController.text);
      await sharedPreferences.setString("userContact", _contactController.text);
      await sharedPreferences.setString("userAddress", _addressController.text);
      await sharedPreferences.setBool("needFurtherInformation", true);

      widget.onPageToShowChange(PageToShow.futherInformationPage);
    } else {
      setState(() {
        showValidationError = true;
      });
    }
  }

  bool validateForm() {
    setState(() {
      _nameError = validateSimpleText(_nameController.text, "Name");
      _emailError = validateEmailId(_emailController.text);
      _contactError = contactValidator(_contactController.text);
      // _addressError = validateSimpleText(_addressController.text, "Email");
    });
    if (_nameError != null
        || _emailError != null
        || _contactError != null
        // || _addressError != null
        ) {
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
              child: Text("Start user fitness journey",
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
          const CustomImagePicker(),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 30, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Name",
                  controller: _nameController,
                  errorText: _nameError)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Email",
                  controller: _emailController,
                  errorText: _emailError)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Contact",
                  textInputType: TextInputType.number,
                  textInputFormatter: [FilteringTextInputFormatter.digitsOnly,LengthLimitingTextInputFormatter(10)],
                  controller: _contactController,
                  errorText: _contactError)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Address",
                  controller: _addressController,
                  errorText: _addressError)),
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
