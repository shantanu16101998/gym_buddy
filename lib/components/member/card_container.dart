import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/exercise_card.dart';

class CardContainer extends StatefulWidget {
  const CardContainer({super.key});

  @override
  State<CardContainer> createState() => _CardContainerState();
}

// const ExerciseCard(name: 'Lateral Raises',sets: '2',reps: '20',weight: '10',)

class _CardContainerState extends State<CardContainer> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ExerciseCard(
              name: 'Lateral Raises',
              sets: '2',
              reps: '20',
              weight: '10',
              exerciseCompleted: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ExerciseCard(
              name: 'Front Raise',
              sets: '2',
              reps: '20',
              weight: '10',
              exerciseCompleted: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ExerciseCard(
              name: 'Bench Press',
              sets: '2',
              reps: '20',
              weight: '10',
              exerciseCompleted: false,
            ),
          )
        ],
      ),
    );
  }
}
