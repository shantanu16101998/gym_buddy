import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/models/table_information.dart';
import 'package:gym_buddy/providers/excercise_provider.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CardInformationTable extends StatefulWidget {
  final int exerciseIndex;
  final Function removeSet;
  final Function markStatus;
  final bool exerciseCompleted;
  const CardInformationTable(
      {super.key,
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
  double circleWidth = 30;

  final TextEditingController weightSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = context.watch<ExerciseProvider>();

    return Selector<ExerciseProvider, List<ExerciseInformation>>(
        selector: (context, provider) =>
            provider.exerciseList[widget.exerciseIndex].exerciseInformationList,
        builder: (context, exerciseInformationList, child) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Padding(
                    padding: EdgeInsets.all(interCellDistance),
                    child: const Row(
                      children: [
                        SizedBox(width: 20),
                        CustomText(
                            text: 'Set',
                            fontSize: 16,
                            color: Color(0xff667085),
                            fontWeight: FontWeight.bold),
                      ],
                    ),
                  ),
                  for (int i = 0; i < exerciseInformationList.length; i++)
                    Padding(
                      padding: EdgeInsets.all(interSetNoDistance),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (!widget.exerciseCompleted &&
                                  exerciseProvider.isProviderDayToday()) {
                                widget.removeSet(i);
                              }
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2,
                                      color: !widget.exerciseCompleted &&
                                              exerciseProvider
                                                  .isProviderDayToday()
                                          ? const Color(0xffCE8C8C)
                                          : Colors.transparent),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(24))),
                              child: Icon(
                                Icons.close,
                                size: 15,
                                color: !widget.exerciseCompleted &&
                                        exerciseProvider.isProviderDayToday()
                                    ? const Color(0xffCE8C8C)
                                    : Colors.transparent,
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
                        text: 'Weight',
                        fontSize: 16,
                        color: Color(0xff667085),
                        fontWeight: FontWeight.bold),
                  ),
                  for (var exerciseInformationEntry
                      in exerciseInformationList.asMap().entries)
                    Padding(
                        padding: EdgeInsets.all(interCellDistance),
                        child: SizedBox(
                            height: 50,
                            // width: 70,
                            child: IgnorePointer(
                              ignoring: !(!exerciseInformationEntry
                                      .value.isCompleted &&
                                  exerciseProvider.isProviderDayToday()),
                              child: DropdownButton2(
                                underline: Container(
                                    height: 1,
                                    color: !exerciseInformationEntry
                                                .value.isCompleted &&
                                            exerciseProvider
                                                .isProviderDayToday()
                                        ? Color(0xff667085)
                                        : Colors.transparent),
                                onMenuStateChange: (isOpen) {
                                  if (!isOpen) {
                                    weightSearchController.clear();
                                  }
                                },
                                dropdownStyleData: const DropdownStyleData(
                                    maxHeight: 250,
                                    width: 100,
                                    decoration:
                                        BoxDecoration(color: Colors.white)),

                                value: defaultExerciseWeights[
                                        exerciseInformationList[
                                                exerciseInformationEntry.key]
                                            .weightIndex]
                                    .toString(), // Ensure this is a String since items are mapped to String
                                // dropdownColor: Colors.white,
                                buttonStyleData: const ButtonStyleData(),
                                iconStyleData: IconStyleData(
                                    icon: RotatedBox(
                                  quarterTurns: 3,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: !exerciseInformationEntry
                                                .value.isCompleted &&
                                            exerciseProvider
                                                .isProviderDayToday()
                                        ? Colors.black
                                        : Colors.transparent,
                                    size: 10,
                                  ),
                                )),
                                dropdownSearchData: DropdownSearchData(
                                  searchController: weightSearchController,
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
                                        controller: weightSearchController,
                                        decoration: InputDecoration(
                                          isDense: true,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          hintText: 'Search',
                                          hintStyle:
                                              const TextStyle(fontSize: 12),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      )),
                                ),

                                onChanged: (value) {
                                  Provider.of<ExerciseProvider>(context,
                                          listen: false)
                                      .updateExerciseInformationListWeight(
                                          widget.exerciseIndex,
                                          exerciseInformationEntry.key,
                                          double.parse(value!.toString()));
                                },
                                items: defaultExerciseWeights
                                    .map<DropdownMenuItem<String>>((num value) {
                                  return DropdownMenuItem<String>(
                                    value: value.toString(),
                                    child: SizedBox(
                                      child: Center(
                                        child: CustomText(
                                          text: '$value kg',
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )))
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
                      in exerciseInformationList.asMap().entries)
                    Padding(
                        padding: EdgeInsets.all(interCellDistance),
                        child: IgnorePointer(
                          ignoring:
                              !(!exerciseInformationEntry.value.isCompleted &&
                                  exerciseProvider.isProviderDayToday()),
                          child: SizedBox(
                            width: 55,
                            child: DropdownButton2(
                              onMenuStateChange: (isOpen) {
                                if (!isOpen) {
                                  weightSearchController.clear();
                                }
                              },
                              isExpanded: true,
                              underline: Container(
                                  height: 1,
                                  color: !exerciseInformationEntry
                                              .value.isCompleted &&
                                          exerciseProvider.isProviderDayToday()
                                      ? Color(0xff667085)
                                      : Colors.transparent),
                              dropdownSearchData: DropdownSearchData(
                                searchController: weightSearchController,
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
                                      controller: weightSearchController,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        hintText: 'Search',
                                        hintStyle:
                                            const TextStyle(fontSize: 14),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    )),
                              ),
                              iconStyleData: IconStyleData(
                                  icon: RotatedBox(
                                quarterTurns: 3,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 10,
                                  color: !exerciseInformationEntry
                                              .value.isCompleted &&
                                          exerciseProvider.isProviderDayToday()
                                      ? Colors.black
                                      : Colors.transparent,
                                ),
                              )),
                              dropdownStyleData: const DropdownStyleData(
                                  maxHeight: 250,
                                  width: 100,
                                  decoration:
                                      BoxDecoration(color: Colors.white)),
                              value: defaultExerciseReps[
                                      exerciseInformationEntry.value.repIndex]
                                  .toString(),
                              onChanged: (value) {
                                Provider.of<ExerciseProvider>(context,
                                        listen: false)
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
                                      child: Center(
                                    child: CustomText(
                                      text: value.toString(),
                                    ),
                                  )),
                                );
                              }).toList(),
                            ),
                          ),
                        ))
                ]),
                exerciseProvider.isProviderDayToday()
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Padding(
                              padding: EdgeInsets.all(interCellDistance),
                              child: const CustomText(
                                  text: 'Done',
                                  fontSize: 16,
                                  color: Color(0xff667085),
                                  fontWeight: FontWeight.bold),
                            ),
                            for (int i = 0;
                                i < exerciseInformationList.length;
                                i++)
                              GestureDetector(
                                onTap: () {
                                  widget.markStatus(i);
                                },
                                child: SizedBox(
                                  // width: 60,
                                  // height: 70,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: interSetNoDistance - 7,
                                        bottom: interSetNoDistance),
                                    child: Center(
                                      child: Container(
                                        width: circleWidth,
                                        height: circleWidth,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.5,
                                                color: exerciseInformationList[
                                                            i]
                                                        .isCompleted
                                                    ? const Color(0xff3ABA2E)
                                                    : headingColor),
                                            color: exerciseInformationList[i]
                                                    .isCompleted
                                                ? const Color(0xff3ABA2E)
                                                : Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(circleWidth))),
                                        child: Icon(
                                          Icons.check,
                                          color: exerciseInformationList[i]
                                                  .isCompleted
                                              ? Colors.white
                                              : headingColor,
                                          size: circleWidth / 1.1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ])
                    : const SizedBox(),
              ]);
        });
  }
}
