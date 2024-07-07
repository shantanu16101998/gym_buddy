import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/screens/owner/user_sign_up.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/exercise_constant.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:gym_buddy/constants/url.dart';



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

  String duration = durations[0];

  late String userName = "User's";

  void intialConfigs() async {
    var sharedPreference = await SharedPreferences.getInstance();
    setState(() {
      userName = sharedPreference.getString("memberName") ?? "User" "'s";
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
      widget.onPageToShowChange(PageToShow.userGoalForm);
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
      endMonthError = _endMonthController.text == "0"
          ? "End month cannot be zero"
          : validateSimpleText(_endMonthController.text, "Valid till");
      chargesError = chargeValidator(_chargesController.text);
    });
    if (genderError != null ||
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
      BuildContext context, TextEditingController dateController) async {
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
        dateController.text = DateFormat("d MMM yyyy").format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 30),
        child: Center(
          child: Text("Enter subscription details",
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      overflow: TextOverflow.clip))),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Center(
          child: SizedBox(
              width: 320,
              // height: 80,
              child: LabeledTextField(
                  labelText: "Start Date",
                  controller: _startDateController,
                  errorText: startDateError,
                  readOnly: true,
                  onTap: () {
                    _selectDate(context, _startDateController);
                  })),
        ),
      ),
      Center(
        child: DropdownButton2(
          iconStyleData: IconStyleData(
              icon: RotatedBox(
                  quarterTurns: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 15,
                    ),
                  ))),
          underline: Container(
            height: 1,
            color: Colors.transparent,
          ),
          buttonStyleData: ButtonStyleData(
              width: 320,
              height: 60,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: endMonthError != null ? Colors.red : Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5)))),
          dropdownStyleData: const DropdownStyleData(
              maxHeight: 400,
              // width: 100,
              decoration: BoxDecoration(color: Colors.white)),
          value: duration,
          onChanged: (value) {
            setState(() {
              duration = value!;
              _endMonthController.text = durations.indexOf(value).toString();
            });
          },
          items: durations.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Container(
                  // width: getScreenWidth(context) * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CustomText(
                      text: value,
                      fontSize: 17,
                    ),
                  )),
            );
          }).toList(),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Align(
            alignment: Alignment.center,
            child: Container(
                width: 320,
                child: LabeledTextField(
                  textInputType: TextInputType.number,
                  labelText: "Charges",
                  controller: _chargesController,
                  textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
                  errorText: chargesError,
                  prefixIcon: const Icon(
                    Icons.currency_rupee,
                  ),
                ))),
      ),
      Padding(
        padding:
            const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
        child: showValidationError
            ? Text(formNotValidated,
                style: const TextStyle(
                    color: formValidationErrorColor,
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
                  width: 320,
                  child: OutlinedButton(
                      onPressed: onPayNowButtonPressed,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: primaryColor,
                        elevation: 0,
                      ),
                      child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text("Next",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold)))))))
    ]));
  }
}
