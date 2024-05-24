import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/models/table_information.dart';
import 'package:gym_buddy/providers/excercise_provider.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:provider/provider.dart';

class CardInformationTable extends StatefulWidget {
  final TableInformation tableInformation;
  final List<ExerciseInformation> exerciseInformationList;
  final int exerciseIndex;
  final Function removeSet;
  final Function markStatus;
  final bool exerciseCompleted;
  const CardInformationTable(
      {super.key,
      required this.tableInformation,
      required this.exerciseInformationList,
      required this.removeSet,
      required this.markStatus,
      required this.exerciseCompleted,
      required this.exerciseIndex});

  @override
  State<CardInformationTable> createState() => _CardInformationTableState();
}

class _CardInformationTableState extends State<CardInformationTable> {
  double interCellDistance = 8.0;
  double interSetNoDistance = 20;
  double iconSize = 25;
  double circleWidth = 23;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.all(interCellDistance),
          child: Row(
            children: [
              widget.exerciseCompleted
                  ? const SizedBox(width: 10)
                  : const SizedBox(width: 40),
              const CustomText(
                  text: 'Set',
                  fontSize: 16,
                  color: Color(0xff667085),
                  fontWeight: FontWeight.bold),
            ],
          ),
        ),
        for (int i = 0; i < widget.exerciseInformationList.length; i++)
          Padding(
            padding: EdgeInsets.all(interSetNoDistance),
            child: Row(
              children: [
                widget.exerciseCompleted
                    ? const SizedBox()
                    : GestureDetector(
                        onTap: () {
                          widget.removeSet(i);
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 2, color: const Color(0xffCE8C8C)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(24))),
                          child: const Icon(
                            Icons.close,
                            size: 15,
                            color: Color(0xffCE8C8C),
                          ),
                        ),
                      ),
                const SizedBox(width: 20),
                CustomText(
                  text: (i + 1).toString(),
                  fontSize: 16,
                  color: const Color(0xff667085),
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.all(interCellDistance),
          child: const CustomText(
              text: 'Kg',
              fontSize: 16,
              color: Color(0xff667085),
              fontWeight: FontWeight.bold),
        ),
        for (var exerciseInformationEntry
            in widget.exerciseInformationList.asMap().entries)
          Padding(
            padding: EdgeInsets.all(interCellDistance),
            child: DropdownButton(
              menuMaxHeight: 250,
              value: defaultExerciseWeights[widget
                      .exerciseInformationList[exerciseInformationEntry.key]
                      .weightIndex]
                  .toString(), // Ensure this is a String since items are mapped to String
              dropdownColor: Colors.white,
              icon: const RotatedBox(
                quarterTurns: 3,
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 10,
                ),
              ),
              onChanged: (value) {
                Provider.of<ExerciseProvider>(context, listen: false)
                    .updateExerciseInformationListWeight(
                        widget.exerciseIndex,
                        exerciseInformationEntry.key,
                        double.parse(value!.toString()));
              },
              items: defaultExerciseWeights
                  .map<DropdownMenuItem<String>>((double value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: SizedBox(
                    child: CustomText(
                      text: value.toString(),
                    ),
                  ),
                );
              }).toList(),
            ),
          )
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: EdgeInsets.all(interCellDistance),
          child: const CustomText(
              text: 'Reps',
              fontSize: 16,
              color: Color(0xff667085),
              fontWeight: FontWeight.bold),
        ),
        for (var exerciseInformationEntry
            in widget.exerciseInformationList.asMap().entries)
          Padding(
            padding: EdgeInsets.all(interCellDistance),
            child: DropdownButton(
              menuMaxHeight: 250,
              value:
                  defaultExerciseReps[exerciseInformationEntry.value.repIndex]
                      .toString(),
              dropdownColor: Colors.white,
              icon: const RotatedBox(
                  quarterTurns: 3,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 10,
                  )),
              onChanged: (value) {
                Provider.of<ExerciseProvider>(context, listen: false)
                    .updateExerciseInformationListReps(
                        widget.exerciseIndex,
                        exerciseInformationEntry.key,
                        int.parse(value!.toString()));
              },
              items: defaultExerciseReps
                  .map<DropdownMenuItem<String>>((int value) {
                return DropdownMenuItem<String>(
                  value: value.toString(),
                  child: SizedBox(
                      child: CustomText(
                    text: value.toString(),
                  )),
                );
              }).toList(),
            ),
          )
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: EdgeInsets.all(interCellDistance),
          child: const CustomText(
              text: 'Done',
              fontSize: 16,
              color: Color(0xff667085),
              fontWeight: FontWeight.bold),
        ),
        for (int i = 0; i < widget.exerciseInformationList.length; i++)
          Padding(
            padding: EdgeInsets.all(interSetNoDistance),
            child: GestureDetector(
              onTap: () {
                widget.markStatus(i);
              },
              child: Container(
                width: circleWidth,
                height: circleWidth,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: widget.exerciseInformationList[i].isCompleted
                            ? const Color(0xff3ABA2E)
                            : Colors.black),
                    color: widget.exerciseInformationList[i].isCompleted
                        ? const Color(0xff3ABA2E)
                        : Colors.white,
                    borderRadius:
                        BorderRadius.all(Radius.circular(circleWidth))),
                child: Icon(
                  Icons.check,
                  color: widget.exerciseInformationList[i].isCompleted
                      ? Colors.white
                      : Colors.black,
                  size: circleWidth / 1.1,
                ),
              ),
            ),
          ),
      ]),
    ]);
  }
}
