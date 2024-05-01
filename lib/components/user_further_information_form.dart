import 'package:flutter/services.dart';
import 'package:gym_buddy/components/custom_text.dart';
import 'package:gym_buddy/components/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/screens/user_sign_up.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:gym_buddy/utils/validator.dart';

final List<String> genders = ["Male", "Female"];

class UserFurtherInformationForm extends StatefulWidget {
  final Function onPageToShowChange;

  const UserFurtherInformationForm(
      {super.key, required this.onPageToShowChange});

  @override
  State<UserFurtherInformationForm> createState() =>
      _UserFurtherInformationFormState();
}

class _UserFurtherInformationFormState
    extends State<UserFurtherInformationForm> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endMonthController = TextEditingController();
  // final TextEditingController _chargesController = TextEditingController();

  String? ageError;
  String? genderError;
  String? bloodGroupError;
  String? startDateError;
  String? endMonthError;

  String gender = genders[0];
  late String userName = "User's";

  void intialConfigs() async {
    var sharedPreference = await SharedPreferences.getInstance();
    userName = sharedPreference.getString("userName") ?? "User" "'s";
  }

  onPayNowButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      var sharedPreferences = await SharedPreferences.getInstance();

      var userName = sharedPreferences.getString("userName") ?? "";
      var userEmail = sharedPreferences.getString("userEmail") ?? "";
      var userContact = sharedPreferences.getString("userContact") ?? "";
      var userAddress = sharedPreferences.getString("userAddress") ?? "";
      var gymName = sharedPreferences.getString("gymName") ?? "";

      backendAPICall(
          '/customer/registerCustomer',
          {
            'customerName': capitalizeFirstLetter(userName),
            'email': userEmail,
            'contact': int.parse(userContact),
            'gymName': gymName,
            'address': userAddress,
            'age': int.parse(_ageController.text),
            'gender': gender,
            'currentBeginDate': _startDateController.text,
            'bloodGroup': _bloodGroupController.text,
            'validTill': int.parse(_endMonthController.text)
          },
          "POST",
          true);

      widget.onPageToShowChange(PageToShow.paymentPage);
    }
  }

  bool validateForm() {
    setState(() {
      ageError = validateSimpleText(_ageController.text, "Age");
      bloodGroupError =
          validateSimpleText(_bloodGroupController.text, "Blood Group");
      startDateError =
          validateSimpleText(_startDateController.text, "Start Date");
      endMonthError =
          validateSimpleText(_endMonthController.text, "Valid till");
    });
    if (ageError != null ||
        genderError != null ||
        bloodGroupError != null ||
        startDateError != null ||
        endMonthError != null) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    intialConfigs();
  }

  DateTime selectedDate = DateTime.now();

  _selectDate(
      BuildContext context, TextEditingController _dateController) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat("d MMMM yyyy").format(pickedDate);
      });
    }
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
              child: Text("Complete  $userName registration",
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
                  labelText: "Age",
                  textInputType: TextInputType.number,
                  textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  controller: _ageController,
                  errorText: ageError)),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: DropdownButton(
                value: gender,
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
                items: genders.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    
                    value: value,
                    child: Container(
                      width: getScreenWidth(context) * 0.6,
                        child: CustomText(
                      text: value,
                      color: Colors.white,
                    )),
                  );
                }).toList(),
              )),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: LabeledTextField(
                  labelText: "Blood Group",
                  controller: _bloodGroupController,
                  errorText: bloodGroupError)),
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
              child: LabeledTextField.onTapOverride(
                  labelText: "Start Date",
                  controller: _startDateController,
                  errorText: startDateError,
                  onTap: () {
                    _selectDate(context, _startDateController);
                  })),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, top: 15, bottom: 15, right: 30),
                child: Text('Valid Till in Months',
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
                      onPressed: () => {
                            setState(() {
                              _endMonthController.text = "3";
                            })
                          },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: _endMonthController.text == "3"
                              ? Color.fromARGB(255, 105, 105, 105)
                              : Color.fromARGB(255, 105, 105, 105)
                                  .withOpacity(0.2)),
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("3",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)))),
                  OutlinedButton(
                      onPressed: () => {
                            setState(() {
                              _endMonthController.text = "6";
                            })
                          },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: _endMonthController.text == "6"
                              ? Color.fromARGB(255, 105, 105, 105)
                              : Color.fromARGB(255, 105, 105, 105)
                                  .withOpacity(0.2)
                                  .withOpacity(0.2)),
                      child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("6",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 243, 243, 243),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)))),
                  OutlinedButton(
                      onPressed: () => {
                            setState(() {
                              _endMonthController.text = "12";
                            })
                          },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: _endMonthController.text == "12"
                              ? Color.fromARGB(255, 105, 105, 105)
                              : Color.fromARGB(255, 105, 105, 105)
                                  .withOpacity(0.2)
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
                  child: LabeledTextField(
                      textInputType: TextInputType.number,
                      labelText: "Valid till Month",
                      textInputFormatter: [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      controller: _endMonthController,
                      onTap: () => {
                            setState(() {
                              _endMonthController.text = "";
                            })
                          },
                      errorText: endMonthError))),
          // Align(
          //     alignment: Alignment.center,
          //     child: Padding(
          //         padding:
          //             EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
          //         child: LabeledTextField(
          //           textInputType: TextInputType.number,
          //           labelText: "Charges",
          //           controller: _chargesController,
          //           textInputFormatter: [
          //             FilteringTextInputFormatter.digitsOnly
          //           ],
          //           onTap: () => {
          //             setState(() {
          //               _endMonthController.text = "";
          //             })
          //           },
          //           errorText: endMonthError,
          //           prefixIcon: Icon(
          //             Icons.currency_rupee,
          //             color: Colors.white,
          //           ),
          //         ))),
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: SizedBox(
                      height: 50,
                      width: 178,
                      child: ElevatedButton(
                          onPressed: onPayNowButtonPressed,
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFD9D9D9)),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Pay Now",
                                  style: TextStyle(
                                      color: Color(0xff004576),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))))))
        ]));
  }
}
