import 'package:flutter/material.dart';
import 'package:gym_buddy/components/user_payment_form.dart';
import 'package:gym_buddy/components/user_sign_up_form_basic.dart';
import 'package:gym_buddy/components/user_further_information_form.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

enum PageToShow { basicPage, futherInformationPage, paymentPage }

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  PageToShow pageToShow = PageToShow.basicPage;

  void intialRouteDecider() async {
    // var sharedPreference = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    intialRouteDecider();
  }

  void onPageToShowChange(value) async {
    setState(() {
      pageToShow = value;
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
                        child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: pageToShow == PageToShow.basicPage
                                ? UserSignUpFormBasic(
                                    onPageToShowChange: onPageToShowChange)
                                : pageToShow == PageToShow.futherInformationPage
                                    ? UserFurtherInformationForm(
                                        onPageToShowChange: onPageToShowChange)
                                    : UserPaymentForm(
                                        onPageToShowChange:
                                            onPageToShowChange)))
                  ])))
    ]));
  }
}
