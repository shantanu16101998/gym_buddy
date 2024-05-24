import 'package:flutter/material.dart';
import 'package:gym_buddy/models/exercise.dart';

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
}
