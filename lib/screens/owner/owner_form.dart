import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/login_form.dart';
import 'package:gym_buddy/components/owner/owner_basic_details_form.dart';
import 'package:gym_buddy/components/owner/owner_additional_details.dart';
import 'package:gym_buddy/components/owner/trainee_form.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_buddy/utils/enums.dart';

class OwnerForm extends StatefulWidget {
  const OwnerForm({super.key});

  @override
  State<OwnerForm> createState() => _OwnerFormState();
}

class _OwnerFormState extends State<OwnerForm> {
  OwnerFormState formState = OwnerFormState.additionalDetails;

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
      return const LoginForm();
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
    return const LoginForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          margin: EdgeInsets.only(top: getStatusBarHeight(context)),
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/register.png"),
            fit: BoxFit.fitWidth,
          ))),
      SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
              color: Colors.transparent,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 100.0)),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  formState = OwnerFormState.loginPage;
                                });
                              },
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                    color: formState == OwnerFormState.loginPage
                                        ? Color(0xffE7AA0F)
                                        : Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              )),
                          const Text(
                            "|",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  formState = OwnerFormState.basicDetails;
                                });
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: formState == OwnerFormState.loginPage
                                        ? Color.fromARGB(255, 255, 255, 255)
                                        : Color(0xffE7AA0F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              )),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20), child: widgetDecider())
                  ])))
    ]));
  }
}
