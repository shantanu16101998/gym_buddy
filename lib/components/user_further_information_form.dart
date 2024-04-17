import 'package:gym_buddy/components/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class UserFurtherInformationForm extends StatefulWidget {
  const UserFurtherInformationForm({super.key});

  @override
  State<UserFurtherInformationForm> createState() =>
      _UserFurtherInformationFormState();
}

class _UserFurtherInformationFormState
    extends State<UserFurtherInformationForm> {
  final TextEditingController _usernameController = TextEditingController();

  DateTime selectedDate = DateTime.now();


  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 85, 84, 84).withOpacity(0.98),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(left: 30, top: 30, bottom: 12),
              child: Text("Complete Suraj's registration",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                    color: Color(0xffFFFFFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  )))),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 30, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Age", controller: _usernameController)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Gender", controller: _usernameController)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Blood Group", controller: _usernameController)),
          Align(
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, top: 15, bottom: 15, right: 30),
                child: Text('Enter subscription details',
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                      color: Color(0xffFFFFFF),
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    )))),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Start Date", controller: _usernameController)),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, top: 15, bottom: 15, right: 30),
                child: Text('Valid Till',
                    style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                      color: Color(0xffFFFFFF).withOpacity(0.9),
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    )))),
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 105, 105, 105)
                              .withOpacity(0.2)),
                      child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("3",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)))),
                  OutlinedButton(
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 105, 105, 105)
                              .withOpacity(0.2)),
                      child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("6",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)))),
                  OutlinedButton(
                      onPressed: () => {},
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Color.fromARGB(255, 105, 105, 105)
                              .withOpacity(0.2)),
                      child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("12",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))))
                ],
              )),
          Align(
            alignment: Alignment.center,
            child: Padding(
                          padding: EdgeInsets.all(30),
                          child:LabeledTextField(
                  labelText: "Add Custom Month", controller: _usernameController))),
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: SizedBox(
                      height: 50,
                      width: 178,
                      child: ElevatedButton(
                          onPressed: () => {},
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFD9D9D9)),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Next",
                                  style: TextStyle(
                                      color: Color(0xff004576),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))))))
        ]));
  }
}
