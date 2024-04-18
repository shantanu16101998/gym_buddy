import 'package:flutter/material.dart';
import 'package:gym_buddy/components/header.dart';
import 'package:gym_buddy/components/subscription_card_container.dart';
import 'package:gym_buddy/components/tab_bar.dart';
import 'package:gym_buddy/components/text_box.dart';
import 'package:gym_buddy/screens/user_sign_up.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  final TextEditingController _usernameController = TextEditingController();

  bool showCurrentUsers = true;

  Future<void> setShouldShowCurrent(bool value) async {
    var sharedPreference = await SharedPreferences.getInstance();
    await sharedPreference.setBool("showCurrent", value);
    setState(() {
      showCurrentUsers = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  // padding: EdgeInsets.all(10),
                  padding: EdgeInsets.only(
                      top: getStatusBarHeight(context), left: 10, right: 10),
                  child: Column(
                    children: [
                      Header(),
                      CustomTabBar(
                          setShouldShowCurrent: setShouldShowCurrent,
                          showCurrentUsers: showCurrentUsers),
                      Container(
                        width: 340,
                        child: LabeledTextField.homepageText(
                            labelText: "Search members",
                            controller: _usernameController,
                            errorText: null),
                      ),
                      SubscriptionCardContainer(
                          showCurrentUsers: showCurrentUsers)
                    ],
                  ),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  color: Colors.white,
                  child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 10),
                          child: SizedBox(
                              height: 50,
                              width: 340,
                              child: ElevatedButton(
                                  onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserSignUp()))
                                      },
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor: const Color(0xFFD9D9D9)),
                                  child: const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text("Add Members",
                                          style: TextStyle(
                                              color: Color(0xff004576),
                                              fontSize: 18,
                                              fontWeight:
                                                  FontWeight.bold))))))),
                ))
          ],
        ));
  }
}
