import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/models/exercise.dart';
import 'package:gym_buddy/models/table_information.dart';
import 'package:gym_buddy/providers/excercise_provider.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:provider/provider.dart';

class AddExercisedDialog extends StatefulWidget {
  const AddExercisedDialog({super.key});

  @override
  State<AddExercisedDialog> createState() => _AddExercisedDialogState();
}

class _AddExercisedDialogState extends State<AddExercisedDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bodyPartController = TextEditingController();

  String? nameError;
  String? bodyPartError;

  bool validateForm() {
    setState(() {
      nameError = validateSimpleText(_nameController.text, "Name");
    });
    if (nameError != null) {
      return false;
    }
    return true;
  }

  void _onAddPressed() {
    if (validateForm()) {
      Provider.of<ExerciseProvider>(context, listen: false).addExercise(
          Exercise(
              _nameController.text,
              [
                ExerciseInformation(0, 5),
                ExerciseInformation(0, 5),
                ExerciseInformation(0, 5)
              ],
              false));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text("Add exercise",
                  style: GoogleFonts.inter(
                      textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color(0xff344054)))),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 30, top: 15, right: 30),
                child: SizedBox(
                  width: 340,
                  child: LabeledTextField.homepageText(
                      labelText: "Name",
                      controller: _nameController,
                      errorText: nameError),
                )),
            Padding(
                padding: const EdgeInsets.only(left: 30, top: 15, right: 30),
                child: SizedBox(
                  width: 340,
                  child: LabeledTextField.homepageText(
                      labelText: "Body Part",
                      controller: _bodyPartController,
                      errorText: bodyPartError),
                )),
            Align(
                alignment: Alignment.center,
                child: Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: SizedBox(
                        height: 50,
                        width: 340,
                        child: ElevatedButton(
                            onPressed: _onAddPressed,
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xFFD9D9D9)),
                            child: const Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Add",
                                    style: TextStyle(
                                        color: Color(0xff004576),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)))))))
          ]),
        ));
  }
}
