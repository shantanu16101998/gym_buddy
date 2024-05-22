import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gym_buddy/components/member/card_information_table.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/models/table_information.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class ExerciseCard extends StatefulWidget {
  final String name;
  final String weight;
  final String sets;
  final String reps;
  final bool exerciseCompleted;

  const ExerciseCard(
      {super.key,
      required this.name,
      required this.sets,
      required this.reps,
      required this.weight,
      required this.exerciseCompleted});

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  final TableInformation tableInformation = TableInformation([]);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: widget.exerciseCompleted == true
              ? Color.fromARGB(255, 242, 247, 241)
              : const Color(0xffffffff),
          border: Border.all(
              width: 1,
              color: widget.exerciseCompleted == true
                  ? const Color(0xff3ABA2E)
                  : const Color(0xffDBDDE2)),
          borderRadius: BorderRadius.circular(12)),
      width: getScreenWidth(context) * 0.9,
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
                  color: Color(0xff344054)),
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    border:
                        Border.all(width: 2, color: const Color(0xffC61212)),
                    borderRadius: BorderRadius.all(Radius.circular(30))),
                child: const Icon(
                  Icons.close,
                  color: const Color(0xffC61212),
                ),
              ),
            ],
          ),
          CardInformationTable(tableInformation: tableInformation)
        ],
      ),
    );
  }
}


    // return Container(
    //   decoration: BoxDecoration(
    //       border: Border.all(
    //           width: 1,
    //           color: widget.exerciseCompleted == true
    //               ? const Color(0xff3ABA2E)
    //               : const Color(0xffDBDDE2)),
    //       borderRadius: BorderRadius.circular(12)),
    //   width: getScreenWidth(context) * 0.9,
    //   child: Padding(
    //     padding: const EdgeInsets.all(10.0),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //       children: [
    //         const CircleAvatar(
    //             backgroundColor: Colors.white,
    //             backgroundImage: AssetImage("assets/images/dumbbell.png"),
    //             radius: 30),
    //         Column(
    //           children: [
    //             CustomText(
    //                 text: widget.name,
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 22,
    //                 color: Color(0xff344054)),
    //             SizedBox(
    //               width: 180,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: [
    //                   CustomText(
    //                       text: '${widget.weight} kg',
    //                       color: Color(0xff667085),
    //                       fontSize: 16),
    //                   CustomText(
    //                       text: '${widget.sets} sets',
    //                       color: Color(0xff667085),
    //                       fontSize: 16),
    //                   CustomText(
    //                       text: '${widget.reps} reps',
    //                       color: Color(0xff667085),
    //                       fontSize: 16)
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //         Icon(Icons.check_circle,
    //             color: widget.exerciseCompleted == true
    //                 ? const Color(0xff3ABA2E)
    //                 : const Color(0xffDBDDE2))
    //       ],
    //     ),
    //   ),
    // );
