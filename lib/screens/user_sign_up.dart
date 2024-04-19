import 'package:flutter/material.dart';
import 'package:gym_buddy/components/user_sign_up_form_basic.dart';
import 'package:gym_buddy/components/user_further_information_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {

  late bool needFurtherInformation = true;

  void intialRouteDecider() async {
    var sharedPreference = await SharedPreferences.getInstance();
    needFurtherInformation =
        sharedPreference.getBool("needFurtherInformation") ?? false;
  }

  @override
  void initState() {
    super.initState();
    intialRouteDecider();
  }

  void onNeedFurtherInformationChanged(value) async {
    setState(() {
      needFurtherInformation = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
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
                    const Padding(padding: EdgeInsets.only(top: 100.0)),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: needFurtherInformation
                          ? UserFurtherInformationForm(
                              onNeedFurtherInformationChanged:
                                  onNeedFurtherInformationChanged)
                          : UserSignUpFormBasic(
                              onNeedFurtherInformationChanged:
                                  onNeedFurtherInformationChanged),
                    )
                  ])))
    ]));
  }
}
