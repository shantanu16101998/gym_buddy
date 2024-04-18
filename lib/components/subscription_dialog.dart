import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/text_box.dart';

class SubscriptionDialog extends StatefulWidget {
  const SubscriptionDialog({super.key});

  @override
  State<SubscriptionDialog> createState() => _SubscriptionDialogState();
}

class _SubscriptionDialogState extends State<SubscriptionDialog> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text("Update Subscription",
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: Color(0xff344054)))),
        ),
        Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: LabeledTextField.homepageText(
                labelText: "Start Date",
                controller: _usernameController,
                errorText: null)),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: Text('Valid Till',
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                    color: Color(0xff344054),
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  )))),
        ),
        Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () => {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      side: BorderSide(
                          width: 1.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("3",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold)))),
                OutlinedButton(
                    onPressed: () => {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      side: BorderSide(
                          width: 1.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("6",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold)))),
                OutlinedButton(
                    onPressed: () => {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      side: BorderSide(
                          width: 1.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("12",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.bold)))),
              ],
            )),
        Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.all(1),
                child: Container(
                    width: 340,
                    child: LabeledTextField.homepageText(
                        labelText: "Add Custom Month",
                        controller: _usernameController,
                        errorText: null)))),
                                  Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: SizedBox(
                      height: 50,
                      width: 340,
                      child: ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFD9D9D9)),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Update",
                                  style: TextStyle(
                                      color: Color(0xff004576),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))))))
      ]),
    );
  }
}
