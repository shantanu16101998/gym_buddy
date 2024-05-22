import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/user_payment_form.dart';
import 'package:gym_buddy/components/owner/user_sign_up_form_basic.dart';
import 'package:gym_buddy/components/owner/user_further_information_form.dart';
import 'dart:ui';

import 'package:gym_buddy/utils/ui_constants.dart';

enum PageToShow { basicPage,signUpDetails, futherInformationPage, paymentPage }

class UserSignUp extends StatefulWidget {
  const UserSignUp({super.key});

  @override
  State<UserSignUp> createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUp> {
  PageToShow pageToShow = PageToShow.signUpDetails;

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
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.only(top: getStatusBarHeight(context)),
          child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
            image: AssetImage("assets/images/register.png"),
            fit: BoxFit.fitWidth,
          ))),
        ),
      ),
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
                                : pageToShow == PageToShow.signUpDetails
                                    ? UserFurtherInformationForm(
                                        onPageToShowChange: onPageToShowChange)
                                    : UserPaymentForm(
                                        onPageToShowChange:
                                            onPageToShowChange)))
                  ])))
    ]));
  }
}
