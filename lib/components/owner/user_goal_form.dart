import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/owner/user_sign_up.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gym_buddy/constants/url.dart';

final List<String> goals = ["Select Goals", "Weight loss", "Muscle gain"];
final List<String> experiences = [
  "Select Experience",
  "Beginner",
  "Intermediate",
  "Experienced"
];

class UserGoalForm extends StatefulWidget {
  final Function onPageToShowChange;

  const UserGoalForm({super.key, required this.onPageToShowChange});

  @override
  State<UserGoalForm> createState() => _UserGoalFormState();
}

class _UserGoalFormState extends State<UserGoalForm> {
  bool showValidationError = false;

  String? goalError;
  String? experienceError;
  String? mentorError;

  String goal = goals[0];
  String experience = experiences[0];
  List<List<String>> mentors = [];
  List<String> mentor = ['default', 'Select Mentor'];
  late String userName = "User's";

  void intialConfigs() async {
    try {
      var sharedPreference = await SharedPreferences.getInstance();

      OwnerDetails ownerDetails = OwnerDetails.fromJson(
          await backendAPICall('/owner/details', {}, 'GET', true));

      List<List<String>> gymTrainee = [['default', 'Select Mentor']];

      for (var trainee in ownerDetails.traineeDetails) {
        gymTrainee.add([trainee.id, trainee.name]);
      }

      setState(() {
        userName = sharedPreference.getString("userName") ?? "User's";
        mentors = gymTrainee;
        mentor = mentors.isNotEmpty ? mentors[0] : ['', ''];
      });
    } catch (e) {
      print('Exception: $e');
    }
  }

  onPayNowButtonPressed() async {
    bool isInformationValidated = validateForm();

    if (isInformationValidated) {
      var sharedPreferences = await SharedPreferences.getInstance();

      await sharedPreferences.setString("goal", goal);
      await sharedPreferences.setString("experience", experience);
      await sharedPreferences.setString("mentorId", mentor.first);
      widget.onPageToShowChange(PageToShow.paymentPage);
    } else {
      setState(() {
        showValidationError = true;
      });
    }
  }

  bool validateForm() {
    setState(() {
      if (goal == goals[0]) {
        goalError = "Please select goal";
      } else {
        goalError = null;
      }

      if (experience == experiences[0]) {
        experienceError = "Please select goal";
      } else {
        experienceError = null;
      }

      if (mentor == mentors[0]) {
        mentorError = "Please select mentor";
      } else {
        mentorError = null;
      }
    });
    if (goalError != null || experienceError != null || mentorError != null) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    intialConfigs();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          border: Border.all(color: Colors.black)
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(left: 30, top: 30, bottom: 12),
              child: Text("Complete  $userName registration",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  )))),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: Center(
                child: DropdownButton(
                  value: goal,
                  dropdownColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      goal = value!;
                      goalError = null;
                    });
                  },
                  items: goals.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                          // color: Colors.white,
                          width: getScreenWidth(context) * 0.6,
                          child: CustomText(
                            text: value,
                            color:
                                goalError != null ? Colors.red : Colors.black,
                          )),
                    );
                  }).toList(),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(
                  left: 30, top: 15, bottom: 15, right: 30),
              child: Center(
                child: DropdownButton(
                  value: experience,
                  dropdownColor: Colors.white,
                  onChanged: (value) {
                    setState(() {
                      experience = value!;
                      experienceError = null;
                    });
                  },
                  items:
                      experiences.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: SizedBox(
                          // color: Colors.white,
                          width: getScreenWidth(context) * 0.6,
                          child: CustomText(
                            text: value,
                            color: experienceError != null
                                ? Colors.red
                                : Colors.black,
                          )),
                    );
                  }).toList(),
                ),
              )),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 15, bottom: 15, right: 30),
            child: Center(
              child: DropdownButton<List<String>>(
                value: mentor,
                dropdownColor: Colors.white,
                onChanged: (List<String>? value) {
                  setState(() {
                    mentor = value ??
                        ['', '']; // Ensure a default value if value is null
                    mentorError = null;
                  });
                },
                items: mentors
                    .map<DropdownMenuItem<List<String>>>((List<String> value) {
                  return DropdownMenuItem<List<String>>(
                    value: value,
                    child: SizedBox(
                      // color: Colors.white,
                      width: getScreenWidth(context) * 0.6,
                      child: CustomText(
                        text: value
                            .last, // Assuming the last string is the mentor's name
                        color: mentorError != null ? Colors.red :  Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
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
                      width: 178,
                      child: ElevatedButton(
                          onPressed: onPayNowButtonPressed,
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              side: BorderSide(color: Colors.black),
                          ),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Pay Now",
                                  style: TextStyle(
                                      color: headingColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))))))
        ]));
  }
}
