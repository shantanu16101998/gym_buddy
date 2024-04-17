import 'package:flutter/material.dart';
import 'package:gym_buddy/components/login_form.dart';
import 'package:gym_buddy/components/owner_sign_up_form.dart';

class OwnerSignUp extends StatefulWidget {
  const OwnerSignUp({super.key});

  @override
  State<OwnerSignUp> createState() => _OwnerSignUpState();
}

class _OwnerSignUpState extends State<OwnerSignUp> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
              child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(padding: EdgeInsets.only(top: 100.0)),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: null,
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              )),
                          Text(
                            "|",
                            style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontSize: 22),
                          ),
                          TextButton(
                              onPressed: null,
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Color(0xffE7AA0F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              )),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(20), child: OwnerSignUpForm())
                  ])))
    ]));
  }
}
