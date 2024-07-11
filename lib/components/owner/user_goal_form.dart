import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/owner/user_payment_form.dart';
import 'package:gym_buddy/database/user_subscription.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/providers/subscription_provider.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/custom.dart';
import 'package:provider/provider.dart';
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

  void onSignUpButtonClicked() async {
    var sharedPreferences = await SharedPreferences.getInstance();

    var memberName = sharedPreferences.getString("memberName") ?? "";
    var userContact = sharedPreferences.getString("userContact") ?? "";
    var startDate = sharedPreferences.getString("startDate") ?? "";
    var validTillString = sharedPreferences.getString("validTill");
    var chargesString = sharedPreferences.getString("charges");
    var profilePic = sharedPreferences.getString('profilePic');
    var mentorId = sharedPreferences.getString('mentorId');
    var goal = sharedPreferences.getString('goal');
    var experience = sharedPreferences.getString('experience');
    sharedPreferences.remove('profilePic');

    int? validTill = tryParseInt(validTillString);
    int? charges = tryParseInt(chargesString);

    RegisterCustomerResponse registerCustomerResponse =
        RegisterCustomerResponse.fromJson(await backendAPICall(
            '/customer/registerCustomer',
            {
              'name': capitalizeFirstLetter(memberName).trim(),
              'contact': userContact.trim(),
              'currentBeginDate': startDate.trim(),
              'validTill': validTill ?? 0,
              'charges': charges ?? 0,
              'profilePic': profilePic,
              if (mentorId != null) 'mentorId': mentorId,
              'goal': goal,
              'experience': experience
            },
            "POST",
            true));

    Provider.of<SubscriptionProvider>(context, listen: false)
        .insertUserInDb(registerCustomerResponse.newUser);

        

    if (sharedPreferences.getString('referralCode') != '') {
      backendAPICall(
          '/verifyReferralCode/${sharedPreferences.getString('referralCode')}',
          {},
          'POST',
          true);
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Subscription()),
      );
    }
  }

  void intialConfigs() async {
    try {
      var sharedPreference = await SharedPreferences.getInstance();

      OwnerDetails ownerDetails = OwnerDetails.fromJson(
          await backendAPICall('/owner/details', {}, 'GET', true));

      List<List<String>> gymTrainee = [
        ['default', 'Select Mentor']
      ];

      for (var trainee in ownerDetails.traineeDetails) {
        gymTrainee.add([trainee.id, trainee.name]);
      }

      setState(() {
        userName = sharedPreference.getString("memberName") ?? "User's";
        mentors = gymTrainee;
        mentor = mentors.isNotEmpty ? mentors[0] : [];
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

      if (mentors.length > 1) {
        await sharedPreferences.setString("mentorId", mentor.first);
      }

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserPaymentForm(
                    onButtonPressed: onSignUpButtonClicked,
                    buttonText: "Sign up and share Gym Card",
                  )));
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
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
              padding: const EdgeInsets.only(left: 30, top: 20, bottom: 30),
              child: Text("Complete  $userName registration",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 22,
                  )))),
          Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Center(
                child: DropdownButton2(
                  value: goal,
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
                  dropdownStyleData: const DropdownStyleData(
                      maxHeight: 400,
                      // width: 100,
                      decoration: BoxDecoration(color: Colors.white)),
                  buttonStyleData: ButtonStyleData(
                      width: 320,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
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
                          child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CustomText(
                          text: value,
                          color: goalError != null ? Colors.red : Colors.black,
                        ),
                      )),
                    );
                  }).toList(),
                ),
              )),
          Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Center(
                child: DropdownButton2(
                  value: experience,
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
                  dropdownStyleData: const DropdownStyleData(
                      maxHeight: 400,
                      decoration: BoxDecoration(color: Colors.white)),
                  buttonStyleData: ButtonStyleData(
                      width: 320,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
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
                          child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: CustomText(
                          text: value,
                          color: experienceError != null
                              ? Colors.red
                              : Colors.black,
                        ),
                      )),
                    );
                  }).toList(),
                ),
              )),
          if (mentors.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Center(
                child: DropdownButton2<List<String>>(
                  value: mentor,
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
                  dropdownStyleData: const DropdownStyleData(
                      maxHeight: 400,
                      decoration: BoxDecoration(color: Colors.white)),
                  buttonStyleData: ButtonStyleData(
                      width: 320,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(5)))),
                  onChanged: (List<String>? value) {
                    setState(() {
                      mentor = value ??
                          ['', '']; // Ensure a default value if value is null
                      mentorError = null;
                    });
                  },
                  items: mentors.map<DropdownMenuItem<List<String>>>(
                      (List<String> value) {
                    return DropdownMenuItem<List<String>>(
                      value: value,
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: CustomText(
                            text: value
                                .last, // Assuming the last string is the mentor's name
                            color:
                                mentorError != null ? Colors.red : Colors.black,
                          ),
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
                      width: 320,
                      child: ElevatedButton(
                          onPressed: onPayNowButtonPressed,
                          style: ElevatedButton.styleFrom(
                              elevation: 0, backgroundColor: primaryColor),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Pay Now",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))))))
        ]));
  }
}
