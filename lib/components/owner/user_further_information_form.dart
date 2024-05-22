import 'package:flutter/services.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/screens/owner/user_sign_up.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:gym_buddy/constants/url.dart';

final List<String> timings = ["Regular Timings", "Special Timings"];

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
  final TextEditingController _chargesController = TextEditingController();

  bool showValidationError = false;

  String? ageError;
  String? genderError;
  String? bloodGroupError;
  String? startDateError;
  String? endMonthError;
  String? chargesError;

  String timing = timings[0];
  late String userName = "User's";

  void intialConfigs() async {
    var sharedPreference = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreference.getString("userName") ?? "User" "'s";
    });
  }

  onPayNowButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      var sharedPreferences = await SharedPreferences.getInstance();

      await sharedPreferences.setString("charges", _chargesController.text);
      await sharedPreferences.setString("age", _ageController.text);
      await sharedPreferences.setString(
          "bloodGroup", _bloodGroupController.text);
      await sharedPreferences.setString("startDate", _startDateController.text);
      await sharedPreferences.setString("validTill", _endMonthController.text);
      await sharedPreferences.setString("timing", timing);
      widget.onPageToShowChange(PageToShow.paymentPage);
    } else {
      setState(() {
        showValidationError = true;
      });
    }
  }

  bool validateForm() {
    setState(() {
      startDateError =
          validateSimpleText(_startDateController.text, "Start Date");
      endMonthError =
          validateSimpleText(_endMonthController.text, "Valid till");
      chargesError = validateSimpleText(_chargesController.text, "charges");
    });
    if (
        // ageError != null
        genderError != null
            // || bloodGroupError != null
            ||
            startDateError != null ||
            endMonthError != null ||
            chargesError != null) {
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
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: formPrimaryColor,
              onPrimary: Colors.white,
              onSurface: formPrimaryColor,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              titleMedium: TextStyle(color: Colors.white),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat("d MMM yyyy").format(pickedDate);
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
                  labelText: "Start Date",
                  controller: _startDateController,
                  errorText: startDateError,
                  readOnly: true,
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
                              ? const Color.fromARGB(255, 105, 105, 105)
                              : const Color.fromARGB(255, 105, 105, 105)
                                  .withOpacity(0.2)),
                      child: const Padding(
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
                              ? const Color.fromARGB(255, 105, 105, 105)
                              : const Color.fromARGB(255, 105, 105, 105)
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
                              ? const Color.fromARGB(255, 105, 105, 105)
                              : const Color.fromARGB(255, 105, 105, 105)
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
                  padding: const EdgeInsets.all(30),
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
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: DropdownButton(
                value: timing,
                dropdownColor: const Color.fromARGB(255, 105, 105, 105),
                onChanged: (value) {
                  setState(() {
                    timing = value!;
                  });
                },
                items: timings.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Container(
                        // color: Colors.white,
                        width: getScreenWidth(context) * 0.6,
                        child: CustomText(
                          text: value,
                          color: Colors.white,
                        )),
                  );
                }).toList(),
              )),
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(
                      left: 30, top: 15, bottom: 15, right: 30),
                  child: LabeledTextField(
                    textInputType: TextInputType.number,
                    labelText: "Charges",
                    controller: _chargesController,
                    textInputFormatter: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    errorText: chargesError,
                    prefixIcon: const Icon(
                      Icons.currency_rupee,
                      color: Colors.white,
                    ),
                  ))),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: showValidationError
                ? Text(formNotValidated,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 17, 0),
                        fontWeight: FontWeight.bold,
                        fontSize: 15))
                : const SizedBox(),
          ),
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
