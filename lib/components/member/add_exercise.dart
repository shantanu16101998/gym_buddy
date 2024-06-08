import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/models/exercise.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/providers/excercise_provider.dart';
import 'package:gym_buddy/providers/exercise_list_provider.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:gym_buddy/utils/validator.dart';
import 'package:provider/provider.dart';

class AddExercisedDialog extends StatefulWidget {
  const AddExercisedDialog({super.key});

  @override
  State<AddExercisedDialog> createState() => _AddExercisedDialogState();
}

class _AddExercisedDialogState extends State<AddExercisedDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _exerciseIdController = TextEditingController();
  final TextEditingController _bodyPartController = TextEditingController();

  String? nameError;
  String? bodyPartError;
  bool isNewExercise = false;
  TextEditingController searchController = TextEditingController();
  int exerciseIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchAddExercises();
  }

  fetchAddExercises() async {
    await Provider.of<ExerciseListProvider>(context, listen: false)
        .fetchExercise();

    setState(() {
      _nameController.text =
          Provider.of<ExerciseListProvider>(context, listen: false)
              .exercisesTableInformation[exerciseIndex]
              .name;
      _exerciseIdController.text =
          Provider.of<ExerciseListProvider>(context, listen: false)
              .exercisesTableInformation[exerciseIndex]
              .id;
    });
  }

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
    if (!isNewExercise || validateForm()) {
      Provider.of<ExerciseProvider>(context, listen: false)
          .addExercise(Exercise(
              name: _nameController.text,
              id: _exerciseIdController.text,
              exerciseInformationList: [
                // ExerciseInformation(0, 5, false),
                // ExerciseInformation(0, 5, false),
                // ExerciseInformation(0, 5, false)
              ],
              exerciseCompleted: false));
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
            isNewExercise == true
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 15, right: 30),
                    child: SizedBox(
                      width: 340,
                      child: LabeledTextField.homepageText(
                          labelText: "Name",
                          controller: _nameController,
                          errorText: nameError),
                    ))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton2<ExercisesTableInformation>(
                      buttonStyleData: ButtonStyleData(width: 350),
                      dropdownSearchData: DropdownSearchData(
                        searchMatchFn: (item, searchValue) {
                          return item.value?.name
                                  .toString()
                                  .toLowerCase()
                                  .contains(searchValue.toLowerCase()) ??
                              false;
                        },
                        searchController: searchController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 4,
                              right: 8,
                              left: 8,
                            ),
                            child: TextFormField(
                              expands: true,
                              maxLines: null,
                              controller: searchController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                hintText: 'Search',
                                hintStyle: const TextStyle(fontSize: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            )),
                      ),
                      iconStyleData: const IconStyleData(
                          icon: RotatedBox(
                        quarterTurns: 3,
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 10,
                        ),
                      )),
                      dropdownStyleData: DropdownStyleData(
                          // maxHeight: 250,
                          width: getScreenWidth(context) * 0.6,
                          decoration: const BoxDecoration(color: Colors.white)),
                      value: context
                          .watch<ExerciseListProvider>()
                          .exercisesTableInformation[exerciseIndex],
                      onChanged: (ExercisesTableInformation? value) {
                        if (value != null) {
                          setState(() {
                            exerciseIndex = Provider.of<ExerciseListProvider>(
                                    context,
                                    listen: false)
                                .exercisesTableInformation
                                .indexOf(value);

                            _nameController.text =
                                Provider.of<ExerciseListProvider>(context,
                                        listen: false)
                                    .exercisesTableInformation[exerciseIndex]
                                    .name;
                            _exerciseIdController.text =
                                Provider.of<ExerciseListProvider>(context,
                                        listen: false)
                                    .exercisesTableInformation[exerciseIndex]
                                    .id;
                          });
                        }
                      },
                      items: context
                          .watch<ExerciseListProvider>()
                          .exercisesTableInformation
                          .map<DropdownMenuItem<ExercisesTableInformation>>(
                              (ExercisesTableInformation value) {
                        return DropdownMenuItem<ExercisesTableInformation>(
                          value: value,
                          child: SizedBox(
                              width: getScreenWidth(context) * 0.6,
                              child: CustomText(
                                text: value.name,
                              )),
                        );
                      }).toList(),
                    ),
                  ),
            isNewExercise == true
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 15, right: 30),
                    child: SizedBox(
                      width: 340,
                      child: LabeledTextField.homepageText(
                          labelText: "Body Part",
                          controller: _bodyPartController,
                          errorText: bodyPartError),
                    ))
                : const SizedBox(),
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
