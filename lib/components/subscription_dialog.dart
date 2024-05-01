import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/text_box.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:intl/intl.dart';
import 'package:gym_buddy/utils/validator.dart';

class SubscriptionDialog extends StatefulWidget {
  final String userId;
  final Function() fetchSubscription;
  const SubscriptionDialog(
      {super.key, required this.userId, required this.fetchSubscription});

  @override
  State<SubscriptionDialog> createState() => _SubscriptionDialogState();
}

class _SubscriptionDialogState extends State<SubscriptionDialog> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endMonthController = TextEditingController();

  String? startDateError;
  String? endMonthError;

  bool validateForm() {
    setState(() {
      startDateError =
          validateSimpleText(_startDateController.text, "Start Date");
      endMonthError = validateSimpleText(_endMonthController.text, "End Month");
    });
    if (startDateError != null || endMonthError != null) {
      return false;
    }
    return true;
  }

  _onUpdatePressed() async {
    if (validateForm()) {
      await backendAPICall(
          '/customer/updateSubscription/${widget.userId}',
          {
            'currentBeginDate': _startDateController.text,
            'validTill': _endMonthController.text
          },
          'PUT',
          true);
      await widget.fetchSubscription();
      Navigator.pop(context);
    }
  }

  _selectDate(
      BuildContext context, TextEditingController dateController) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        dateController.text = DateFormat("d MMMM yyyy").format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
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
                controller: _startDateController,
                onTap: () => {_selectDate(context, _startDateController)},
                errorText: startDateError)),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 10, bottom: 10, right: 30),
              child: Text('Valid Till',
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
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
                    onPressed: () => {
                          setState(() {
                            _endMonthController.text = "3";
                          })
                        },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: _endMonthController.text == "3"
                          ? Color.fromARGB(255, 203, 203, 203)
                          : Colors.white,
                      side: BorderSide(
                          width: 1.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("3",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.normal)))),
                OutlinedButton(
                    onPressed: () => {
                          setState(() {
                            _endMonthController.text = "6";
                          })
                        },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _endMonthController.text == "6"
                          ? Color.fromARGB(255, 203, 203, 203)
                          : Colors.white,
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
                                fontWeight: FontWeight.normal)))),
                OutlinedButton(
                    onPressed: () => {
                          setState(() {
                            _endMonthController.text = "12";
                          })
                        },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: _endMonthController.text == "12"
                          ? Color.fromARGB(255, 203, 203, 203)
                          : Colors.white,
                      side: BorderSide(
                          width: 1.0, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                    child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("12",
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.normal)))),
              ],
            )),
        Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.all(1),
                child: Container(
                    width: 340,
                    child: LabeledTextField.homepageText(
                        labelText: "Add Month",
                        controller: _endMonthController,
                        onTap: () => {
                              setState(() {
                                _endMonthController.text = "";
                              })
                            },
                        errorText: endMonthError)))),
        Align(
            alignment: Alignment.center,
            child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                    height: 50,
                    width: 340,
                    child: ElevatedButton(
                        onPressed: _onUpdatePressed,
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
