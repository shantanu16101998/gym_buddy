import 'package:flutter/material.dart';
import 'package:gym_buddy/models/exercise.dart';
import 'package:gym_buddy/models/table_information.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class ExerciseProvider extends ChangeNotifier {
  List<Exercise> exerciseList = [];

  void addExercise(Exercise exercise) {
    exerciseList.add(exercise);
    notifyListeners();
  }

  void removeExercise(int index) {
    exerciseList.removeAt(index);
    notifyListeners();
  }

  void initDefaultExercise() {
    exerciseList
        .add(Exercise('Lateral Raise', [ExerciseInformation(0, 0)], false));
    exerciseList
        .add(Exercise('Front Raise', [ExerciseInformation(0, 0)], false));
    // notifyListeners();
  }

  void updateExerciseInformationListWeight(
      int exerciseIndex, int setNo, double value) {
    exerciseList[exerciseIndex].exerciseInformationList[setNo].weightIndex =
        defaultExerciseWeights.indexOf(value);
    notifyListeners();
  }

  void updateExerciseInformationListReps(
      int exerciseIndex, int setNo, int value) {
    exerciseList[exerciseIndex].exerciseInformationList[setNo].repIndex =
        defaultExerciseReps.indexOf(value);
    notifyListeners();
  }

  void addSetToExercise(int exerciseIndex) {
    exerciseList[exerciseIndex]
        .exerciseInformationList
        .add(ExerciseInformation(0, 0));
    areAllExerciseCompleted(exerciseIndex);
    notifyListeners();
  }

  void areAllExerciseCompleted(int exerciseIndex) {
    if (exerciseList[exerciseIndex].exerciseInformationList.isEmpty) {
      exerciseList[exerciseIndex].exerciseCompleted = false;
      notifyListeners();
      return;
    }

    for (var exercise in exerciseList[exerciseIndex].exerciseInformationList) {
      if (!exercise.isCompleted) {
        exerciseList[exerciseIndex].exerciseCompleted = false;
        notifyListeners();
        return;
      }
    }
    exerciseList[exerciseIndex].exerciseCompleted = true;
    notifyListeners();
    return;
  }

  void removeSetFromExercise(int exerciseIndex, int setNo) {
    exerciseList[exerciseIndex].exerciseInformationList.removeAt(setNo);
    areAllExerciseCompleted(exerciseIndex);
    notifyListeners();
  }

  void markStatusOfSet(int exerciseIndex, int setNo) {
    exerciseList[exerciseIndex].exerciseInformationList[setNo].isCompleted =
        !exerciseList[exerciseIndex].exerciseInformationList[setNo].isCompleted;
    areAllExerciseCompleted(exerciseIndex);
    notifyListeners();
  }
}
