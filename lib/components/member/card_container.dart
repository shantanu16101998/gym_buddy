import 'package:flutter/material.dart';
import 'package:gym_buddy/components/member/exercise_card.dart';
import 'package:gym_buddy/components/owner/custom_text.dart';
import 'package:gym_buddy/providers/excercise_provider.dart';
import 'package:gym_buddy/utils/colors.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
    int currentDay = DateTime.now().weekday;
    final exerciseProvider = context.watch<ExerciseProvider>();

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    style: ElevatedButton.styleFrom(elevation: 0),
                    onPressed: () {
                      if (exerciseProvider.providerDay > 1)
                        exerciseProvider.decreaseProviderDay();
                    },
                    child: Icon(Icons.arrow_left,
                        size: 40,
                        color: exerciseProvider.providerDay > 1
                            ? headerColor
                            : headerColor.withOpacity(0.5))),
                const CustomText(
                    text: 'Workouts',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: headerColor),
                OutlinedButton(
                    style: ElevatedButton.styleFrom(elevation: 0),
                    onPressed: () {
                      if (exerciseProvider.providerDay < currentDay) {
                        exerciseProvider.increaseProviderDay();
                      }
                    },
                    child: Icon(Icons.arrow_right,
                        size: 40,
                        color: exerciseProvider.providerDay < currentDay
                            ? headerColor
                            : headerColor.withOpacity(0.5))),
              ],
            ),
          ),
          exerciseProvider.currentWeekDayExerciseInitialized
              ? Column(
                  children: [
                    for (var exercise
                        in exerciseProvider.exerciseList.asMap().entries)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExerciseCard(
                          exercise: exercise.value,
                          exerciseIndex: exercise.key,
                        ),
                      )
                  ],
                )
              : Column(
                  children: [
                    for (int i = 0; i < 3; i++)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
                          child: Container(
                            width: getScreenWidth(context) * 0.9,
                            height: 200,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12))),
                          ),
                          baseColor: const Color.fromARGB(255, 255, 255, 255),
                          highlightColor:
                              const Color.fromARGB(255, 227, 227, 226),
                        ),
                      )
                  ],
                )
        ],
      ),
    );
  }
}
