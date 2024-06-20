import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/components/owner/user_goal_form.dart';
import 'package:gym_buddy/components/owner/user_payment_form.dart';
import 'package:gym_buddy/components/owner/user_sign_up_form_basic.dart';
import 'package:gym_buddy/components/owner/user_further_information_form.dart';
import 'dart:ui';

import 'package:gym_buddy/utils/ui_constants.dart';

enum PageToShow { basicPage, signUpDetails, futherInformationPage, paymentPage }

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
    return AppScaffold(
        isApiDataLoaded: true,
        child: Stack(children: <Widget>[
          Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(top: getStatusBarHeight(context)),
              child: Container(),
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
                        // const Padding(padding: EdgeInsets.only(top: 20.0)),
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  return SlideTransition(
                                    position: Tween<Offset>(
                                      begin: Offset(1, 0),
                                      end: Offset(0, 0),
                                    ).animate(animation),
                                    child: child,
                                  );
                                },
                                child: pageToShow == PageToShow.basicPage
                                    ? UserSignUpFormBasic(
                                        onPageToShowChange: onPageToShowChange)
                                    : pageToShow == PageToShow.signUpDetails
                                        ? UserFurtherInformationForm(
                                            onPageToShowChange:
                                                onPageToShowChange)
                                        : pageToShow ==
                                                PageToShow.futherInformationPage
                                            ? UserGoalForm(
                                                onPageToShowChange:
                                                    onPageToShowChange)
                                            : UserPaymentForm(
                                                onPageToShowChange:
                                                    onPageToShowChange)))
                      ])))
        ]));
  }
}
