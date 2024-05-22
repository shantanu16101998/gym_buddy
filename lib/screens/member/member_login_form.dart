import 'package:flutter/material.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:flutter/services.dart';
import 'package:gym_buddy/utils/validator.dart';

class MemberLoginForm extends StatefulWidget {
  const MemberLoginForm({super.key});

  @override
  State<MemberLoginForm> createState() => _MemberLoginFormState();
}

class _MemberLoginFormState extends State<MemberLoginForm> {
  final TextEditingController _contactController = TextEditingController();
  String? contactError;
  bool validateForm() {
    setState(() {
    contactError = contactValidator(_contactController.text);
      
    });

    if (contactError != null) {
      return true;
    }

    return false;
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
                    const Padding(padding: EdgeInsets.only(top: 100.0)),
                    const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          TextButton(
                              onPressed: null,
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                    color: Color(0xffE7AA0F),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22),
                              )),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 85, 84, 84)
                                .withOpacity(0.98),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 30, bottom: 12),
                                child: Text(
                                  "Customer login",
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 30),
                                child: Text(
                                  "Welcome",
                                  style: GoogleFonts.inter(
                                    textStyle: const TextStyle(
                                      color: Color(0xffFFFFFF),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 30, bottom: 15, right: 30),
                                child: LabeledTextField(
                                  labelText: "Contact",
                                  controller: _contactController,
                                  textInputType: TextInputType.number,
                                  textInputFormatter: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  errorText: contactError,
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 50, top: 30),
                                  child: SizedBox(
                                    height: 50,
                                    width: 178,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        validateForm();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor:
                                            const Color(0xFFD9D9D9),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text(
                                          "Log In",
                                          style: TextStyle(
                                            color: Color(0xff004576),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ])))
    ]));
  }
}
