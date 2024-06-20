import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/exercise_card.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/providers/excercise_provider.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:provider/provider.dart';

class CardContainer extends StatefulWidget {
  const CardContainer({super.key});

  @override
  State<CardContainer> createState() => _CardContainerState();
}

class _CardContainerState extends State<CardContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = context.watch<ExerciseProvider>();

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          exerciseProvider.exerciseList.isNotEmpty
              ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomText(
                    text: 'Your Workouts',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: headingColor
                  ),
              )
              : const SizedBox(),
          for (var exercise in exerciseProvider.exerciseList.asMap().entries)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExerciseCard(
                exercise: exercise.value,
                exerciseIndex: exercise.key,
              ),
            ),
        ],
      ),
    );
  }
}
