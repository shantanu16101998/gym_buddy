import 'package:gym_buddy/components/owner/custom_image_picker.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/constants/url.dart';
import 'package:gym_buddy/screens/owner/user_sign_up.dart';
import 'package:gym_buddy/utils/colors.dart';
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
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _confirmContactController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _referralCodeController = TextEditingController();

  bool showValidationError = false;

  bool showReferralTextBox = false;

  bool shouldHidePhoneNumber = false;

  final FocusNode confirmContactFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    confirmContactFocus.addListener(_onconfirmContactFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    confirmContactFocus.removeListener(_onconfirmContactFocusChange);
    confirmContactFocus.dispose();
  }

  String? _nameError;
  String? _contactError;
  String? _confirmContactError;

  void _onconfirmContactFocusChange() {
    if (confirmContactFocus.hasFocus) {
      setState(() {
        shouldHidePhoneNumber = true;
      });
    }
  }

  onNextButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("memberName", _nameController.text);
      await sharedPreferences.setString("userContact", _contactController.text);
      await sharedPreferences.setString("userAddress", _addressController.text);
      await sharedPreferences.setBool("needFurtherInformation", true);

      await sharedPreferences.setString(
          "referralCode", _referralCodeController.text);

      widget.onPageToShowChange(PageToShow.signUpDetails);
    } else {
      setState(() {
        showValidationError = true;
      });
    }
  }

  bool validateForm() {
    setState(() {
      _nameError = validateSimpleText(_nameController.text, "Name");
      _contactError = contactValidator(_contactController.text);

      if (_contactController.text == _confirmContactController.text) {
        _confirmContactError = null;
      } else {
        _confirmContactError = "Contact do not match";
      }
      // _addressError = validateSimpleText(_addressController.text, "Email");
    });
    if (_nameError != null ||
        _contactError != null ||
        _confirmContactError != null) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // decoration: BoxDecoration(
        //   border: Border.all(color: Color(0xffDBDDE2)),
        //   borderRadius: BorderRadius.circular(20),
        //   color: const Color(0xffFCFCFD),
        // ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 30),
          child: Center(
            child: Text("Register New User",
                style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: primaryColor))),
          )),
      const CustomImagePicker(),
      Padding(
          padding:
              const EdgeInsets.only(left: 30, top: 30, bottom: 15, right: 30),
          child: LabeledTextField(
              labelText: "Name",
              controller: _nameController,
              errorText: _nameError)),
      Padding(
          padding:
              const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
          child: LabeledTextField(
              labelText: "Contact",
              shouldObscure: shouldHidePhoneNumber,
              textInputType: TextInputType.number,
              textInputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10)
              ],
              controller: _contactController,
              errorText: _contactError)),
      Padding(
          padding:
              const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
          child: LabeledTextField(
              labelText: "Confirm contact",
              focusNode: confirmContactFocus,
              textInputType: TextInputType.number,
              textInputFormatter: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10)
              ],
              controller: _confirmContactController,
              errorText: _confirmContactError)),
      Padding(
          padding:
              const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
          child: showReferralTextBox
              ? LabeledTextField(
                  labelText: "Referral code",
                  textInputType: TextInputType.number,
                  textInputFormatter: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10)
                  ],
                  controller: _referralCodeController,
                  errorText: null)
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      showReferralTextBox = true;
                    });
                  },
                  child: const CustomText(
                      text: 'Have a referral code?', isUnderlined: true),
                )),
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
                  width: 250,
                  child: OutlinedButton(
                      onPressed: onNextButtonPressed,
                      style: OutlinedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: primaryColor,
                          side: const BorderSide(color: primaryColor)),
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
