import 'package:flutter/services.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/models/requests.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/constants/url.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnerTraineeForm extends StatefulWidget {
  final TextEditingController nameController;
  final Function formStateChanger;

  const OwnerTraineeForm(
      {super.key,
      required this.nameController,
      required this.formStateChanger});

  @override
  State<OwnerTraineeForm> createState() => _OwnerTraineeFormState();
}

enum HaveTrainee { yes, no }

class _OwnerTraineeFormState extends State<OwnerTraineeForm> {
  bool showValidationError = false;
  int numberOfTrainee = 1;

  final List<TextEditingController> _namesControllers = [
    TextEditingController(),
  ];
  final List<TextEditingController> _experienceControllers = [
    TextEditingController(),
  ];

  addTraineeCount() {
    setState(() {
      numberOfTrainee++;
      _namesControllers.add(TextEditingController());
      _experienceControllers.add(TextEditingController());
    });
  }

  onNextButtonPressed() async {
    bool isInformationValidated = validateForm();

    List<TraineeDetails> traineeDetails = [];

    if (isInformationValidated) {
      for (int i = 0; i < _namesControllers.length; i++) {
        if (_namesControllers[i].text != '') {
          traineeDetails.add(TraineeDetails(
              name: _namesControllers[i].text,
              experience: _experienceControllers[i].text));
        }
      }

      var sharedPreferences = await SharedPreferences.getInstance();

      var userName = sharedPreferences.getString("userName") ?? "";
      var ownerPassword = sharedPreferences.getString("ownerPassword") ?? "";
      var ownerContact = sharedPreferences.getString("ownerContact") ?? "";
      var gymName = sharedPreferences.getString("gymName");
      var address = sharedPreferences.getString("address");
      var upiId = sharedPreferences.getString("upiId");

      OwnerRegistrationResponse ownerRegistrationResponse =
          OwnerRegistrationResponse.fromJson(await backendAPICall(
              '/owner/signup',
              {
                'name': userName,
                'password': ownerPassword,
                'gymName': gymName,
                'contact': ownerContact,
                'address': address,
                'upiId': upiId,
                'token': sharedPreferences.getString("fcmToken"),
                'lat': sharedPreferences.getString("latitude"),
                'lon': sharedPreferences.getString("longitude"),
                'trainees':
                    traineeDetails.map((trainee) => trainee.toJson()).toList(),
              },
              'POST',
              true));

      await sharedPreferences.setString(
          "jwtToken", ownerRegistrationResponse.jwtToken ?? "");

      sharedPreferences.setString(
          'gymName', ownerRegistrationResponse.gymName ?? "Gym");
      if (mounted) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const Subscription()));
      }
    } else {
      setState(() {
        showValidationError = true;
      });
    }
  }

  bool validateForm() {
    return true;
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
              child: Text("Hi ${widget.nameController.text}",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                    color: Color(0xffFFFFFF),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  )))),
          Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text("Enter trainee details",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          color: Color(0xffFFFFFF),
                          fontWeight: FontWeight.normal,
                          fontSize: 18)))),
          for (int i = 0; i < numberOfTrainee; i++)
            Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 30, top: 30),
                    child: Text("Trainee ${i + 1}",
                        style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.bold,
                                fontSize: 16)))),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 30, top: 30, bottom: 15, right: 30),
                    child: LabeledTextField(
                        labelText: "Name",
                        textColour: Colors.white,
                        borderColor: Colors.white,
                        cursorColor: Colors.white,
                        controller: _namesControllers[i],
                        errorText: null)),
                Padding(
                    padding: const EdgeInsets.only(
                        left: 30, top: 15, bottom: 15, right: 30),
                    child: LabeledTextField(
                        labelText: "Experience (years)",
                        textColour: Colors.white,
                        borderColor: Colors.white,
                        cursorColor: Colors.white,
                        textInputType: TextInputType.number,
                        textInputFormatter: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: _experienceControllers[i],
                        errorText: null)),
              ],
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
                  padding: const EdgeInsets.only(bottom: 10, top: 30),
                  child: SizedBox(
                      height: 50,
                      width: 178,
                      child: ElevatedButton(
                          onPressed: addTraineeCount,
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFD9D9D9)),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Add trainee",
                                  style: TextStyle(
                                      color: Color(0xff004576),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))))))),
          Align(
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 50, top: 30),
                  child: SizedBox(
                      height: 50,
                      width: 178,
                      child: ElevatedButton(
                          onPressed: onNextButtonPressed,
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xFFD9D9D9)),
                          child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("SignUp",
                                  style: TextStyle(
                                      color: Color(0xff004576),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)))))))
        ]));
  }
}
