import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/components/owner/text_box.dart';
import 'package:gym_buddy/models/table_information.dart';

class CardInformationTable extends StatefulWidget {
  final TableInformation tableInformation;
  final List<ExerciseInformation> exerciseInformationList;
  final Function removeSet;
  final Function markStatus;
  final bool exerciseCompleted;
  const CardInformationTable(
      {super.key,
      required this.tableInformation,
      required this.exerciseInformationList,
      required this.removeSet,
      required this.markStatus,
      required this.exerciseCompleted});

  @override
  State<CardInformationTable> createState() => _CardInformationTableState();
}

class _CardInformationTableState extends State<CardInformationTable> {
  double interCellDistance = 8.0;
  double iconSize = 25;
  double circleWidth = 23;
  /*
  editingList = [(setNo,object)]
  eg:
    (1,'weight') means edit weight of set1

  */
  List editingList = [0, 'weight'];
  TextEditingController editingController = TextEditingController();

  bool isCurrentlyEditing(int setNo, String object) {
    if (editingList.length == 2 &&
        editingList.first == setNo &&
        editingList.last == object) {
      return true;
    }
    return false;
  }

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
            padding: EdgeInsets.all(interCellDistance),
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
              text: 'Weight',
              fontSize: 16,
              color: Color(0xff667085),
              fontWeight: FontWeight.bold),
        ),
        // for (var _exerciseInformation in widget.exerciseInformationList)
        for (var exerciseInformationEntry
            in widget.exerciseInformationList.asMap().entries)
          Padding(
            padding: EdgeInsets.all(interCellDistance),
            child: GestureDetector(
              onTap: () => {
                setState(() {
                  editingList = [exerciseInformationEntry.key, 'weight'];
                  editingController.text =
                      exerciseInformationEntry.value.weight;
                })
              },
              child: Row(
                children: [
                  isCurrentlyEditing(exerciseInformationEntry.key, 'weight')
                      ? CustomText(
                          text: exerciseInformationEntry.value.weight,
                          fontSize: 16,
                          color: const Color(0xff667085),
                          fontWeight: FontWeight.bold)
                      : CustomText(
                          text: exerciseInformationEntry.value.weight,
                          fontSize: 16,
                          color: const Color(0xff667085),
                          fontWeight: FontWeight.bold),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
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
        for (var exerciseInformation in widget.exerciseInformationList)
          Padding(
            padding: EdgeInsets.all(interCellDistance),
            child: Row(
              children: [
                CustomText(
                    text: exerciseInformation.reps,
                    fontSize: 16,
                    color: const Color(0xff667085),
                    fontWeight: FontWeight.bold),
                const Icon(Icons.arrow_drop_down)
              ],
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
            padding: EdgeInsets.all(interCellDistance),
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
