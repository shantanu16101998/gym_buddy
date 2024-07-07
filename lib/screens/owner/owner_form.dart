import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/login_form.dart';
import 'package:gym_buddy/components/owner/owner_basic_details_form.dart';
import 'package:gym_buddy/components/owner/owner_additional_details.dart';
import 'package:gym_buddy/components/owner/trainee_form.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_buddy/utils/enums.dart';

class OwnerForm extends StatefulWidget {
  const OwnerForm({super.key});

  @override
  State<OwnerForm> createState() => _OwnerFormState();
}

class _OwnerFormState extends State<OwnerForm> {
  OwnerFormState formState = OwnerFormState.loginPage;

  final TextEditingController nameController = TextEditingController();

  Future<void> setShouldShowLoginPage(bool value) async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setBool("shouldShowLoginPage", value);
    setState(() {
      formState = OwnerFormState.additionalDetails;
    });
  }

  Future<void> formStateChanger(nextFormState) async {
    setState(() {
      formState = nextFormState;
    });
  }

  Widget widgetDecider() {
    if (formState == OwnerFormState.loginPage) {
      return LoginForm(formStateChanger: formStateChanger);
    } else if (formState == OwnerFormState.basicDetails) {
      return OwnerBasicDetailsForm(
          formStateChanger: formStateChanger, nameController: nameController);
    } else if (formState == OwnerFormState.additionalDetails) {
      return OwnerAdditionalDetails(
          nameController: nameController, formStateChanger: formStateChanger);
    } else if (formState == OwnerFormState.traineeDetails) {
      return OwnerTraineeForm(
          nameController: nameController, formStateChanger: formStateChanger);
    }
    return LoginForm(formStateChanger: formStateChanger);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.only(top: getStatusBarHeight(context)),
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              constraints: BoxConstraints(maxHeight: getScreenHeight(context) - 20),
              child: SingleChildScrollView(child: widgetDecider()))
        ],
      ),
    ));
  }
}
