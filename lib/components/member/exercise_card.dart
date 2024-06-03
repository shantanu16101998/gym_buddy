import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/card_information_table.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/models/exercise.dart';
import 'package:gym_buddy/models/table_information.dart';
import 'package:gym_buddy/providers/excercise_provider.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:provider/provider.dart';

class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final int exerciseIndex;

  const ExerciseCard(
      {super.key, required this.exercise, required this.exerciseIndex});

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  final TableInformation tableInformation = TableInformation([]);

  List<ExerciseInformation> exerciseInformationList = [];

  @override
  void initState() {
    super.initState();
    exerciseInformationList = widget.exercise.exerciseInformationList;
  }

  void _addSet() {
    Provider.of<ExerciseProvider>(context, listen: false)
        .addSetToExercise(widget.exerciseIndex);
  }

  void _removeSet(int setNo) {
    Provider.of<ExerciseProvider>(context, listen: false)
        .removeSetFromExercise(widget.exerciseIndex, setNo);
  }

  void markStatus(int setNo) {
    Provider.of<ExerciseProvider>(context, listen: false)
        .markStatusOfSet(widget.exerciseIndex, setNo);
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: widget.exercise.exerciseCompleted == true
              ? const Color.fromARGB(255, 242, 247, 241)
              : const Color(0xffffffff),
          border: Border.all(
              width: 1,
              color: widget.exercise.exerciseCompleted == true
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
                Container(
                  alignment: Alignment.center,
                  width: getScreenWidth(context) * 0.5,
                  child: CustomText(
                      text: widget.exercise.name,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: const Color(0xff344054)),
                ),
                GestureDetector(
                  onTap: () {
                    if (!widget.exercise.exerciseCompleted) {
                      exerciseProvider.removeExercise(widget.exerciseIndex);
                    }
                  },
                  child: Container(
                    height: 24,
                    width: 24,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2, color: !widget.exercise.exerciseCompleted ? const Color(0xffC61212) : Colors.transparent),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24))),
                    child: Icon(
                      Icons.close,
                      size: 20,
                      color: !widget.exercise.exerciseCompleted ? Color(0xffC61212)  : Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
            CardInformationTable(
                exerciseIndex: widget.exerciseIndex,
                tableInformation: tableInformation,
                exerciseInformationList: exerciseInformationList,
                removeSet: _removeSet,
                markStatus: markStatus,
                exerciseCompleted: widget.exercise.exerciseCompleted),
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
