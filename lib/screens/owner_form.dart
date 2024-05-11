import 'package:flutter/material.dart';
import 'package:gym_buddy/components/login_form.dart';
import 'package:gym_buddy/components/owner_sign_up_form.dart';
import 'package:gym_buddy/components/owner_further_information.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerForm extends StatefulWidget {
  const OwnerForm({super.key});

  @override
  State<OwnerForm> createState() => _OwnerFormState();
}

class _OwnerFormState extends State<OwnerForm> {
  late bool shouldShowLoginPage = true;
  late bool shouldShowFutherInformation = false;

  final TextEditingController nameController = TextEditingController();

  Future<void> setShouldShowLoginPage(bool value) async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setBool("shouldShowLoginPage", value);
    setState(() {
      shouldShowLoginPage = value;
    });
  }

  Future<void> setShouldShowFurtherInformation(bool value) async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setBool("shouldShowFurtherInformation", value);
    setState(() {
      shouldShowFutherInformation = value;
    });
  }

  Widget widgetDecider() {
    if (shouldShowLoginPage) {
      return const LoginForm();
    } else if (shouldShowFutherInformation) {
      return OwnerFurtherInformationForm(nameController: nameController);
    } else {
      return OwnerFormForm(
          nameController: nameController,
          setShouldShowFurtherInformation: setShouldShowFurtherInformation);
    }
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
                                setShouldShowLoginPage(true);
                              },
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                    color: shouldShowLoginPage
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
                                setShouldShowLoginPage(false);
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: shouldShowLoginPage
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
