import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/card_information_table.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/models/table_information.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class ExerciseCard extends StatefulWidget {
  final String name;

  const ExerciseCard({
    super.key,
    required this.name,
  });

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  final TableInformation tableInformation = TableInformation([]);

  bool exerciseCompleted = false;

  List<ExerciseInformation> exerciseInformationList = [
    ExerciseInformation('10', '2kg'),
    ExerciseInformation('20', '4kg'),
  ];

  void _addSet() {
    setState(() {
      exerciseInformationList.add(ExerciseInformation('-', '-'));
      exerciseCompleted = false;
    });
  }

  void _removeSet(int setNo) {
    setState(() {
      exerciseInformationList.removeAt(setNo);
    });
  }

  void markStatus(int setNo) {
    setState(() {
      exerciseInformationList[setNo].isCompleted =
          !exerciseInformationList[setNo].isCompleted;
    });

    bool allExerciseCompleted = true;

    for (var exercise in exerciseInformationList) {
      if (!exercise.isCompleted) {
        allExerciseCompleted = false;
      }
    }
    exerciseCompleted = allExerciseCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: exerciseCompleted == true
              ? const Color.fromARGB(255, 242, 247, 241)
              : const Color(0xffffffff),
          border: Border.all(
              width: 1,
              color: exerciseCompleted == true
                  ? const Color(0xff3ABA2E)
                  : const Color(0xffDBDDE2)),
          borderRadius: BorderRadius.circular(12)),
      width: getScreenWidth(context) * 0.9,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/images/dumbbell.png"),
                    radius: 30),
                CustomText(
                    text: widget.name,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: const Color(0xff344054)),
                exerciseCompleted
                    ? const SizedBox()
                    : Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2, color: const Color(0xffC61212)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(24))),
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Color(0xffC61212),
                        ),
                      ),
              ],
            ),
            CardInformationTable(
                tableInformation: tableInformation,
                exerciseInformationList: exerciseInformationList,
                removeSet: _removeSet,
                markStatus: markStatus,
                exerciseCompleted: exerciseCompleted),
            Padding(
              padding: const EdgeInsets.only(top: 26, bottom: 11),
              child: SizedBox(
                height: 40,
                width: 120,
                child: OutlinedButton(
                  onPressed: _addSet,
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side:
                          const BorderSide(color: Color(0xffDBDDE2), width: 1)),
                  child: const CustomText(
                    text: 'Add set',
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}