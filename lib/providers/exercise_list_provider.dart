import 'package:flutter/material.dart';
import 'package:gym_buddy/models/responses.dart';

import 'package:gym_buddy/utils/backend_api_call.dart';

class ExerciseListProvider extends ChangeNotifier {
  List<ExercisesTableInformation> allExercisesTableInformation = [
    ExercisesTableInformation(id: '0', name: 'Select exercise')
  ];

  List<ExercisesTableInformation> analysisExerciseTableInformation = [
    ExercisesTableInformation(id: '0', name: 'Select exercise')
  ];

  Future<void> fetchExercise() async {
    if (allExercisesTableInformation.length == 1) {
      GetAllExerciseResponse getAllExerciseResponse =
          GetAllExerciseResponse.fromJson(
              await backendAPICall('/exercise/allExercise', {}, 'GET', false));
      allExercisesTableInformation = allExercisesTableInformation +
          getAllExerciseResponse.exerciseInformation;
      notifyListeners();
    }
  }

  Future<void> fetchUserExercise() async {
    GetAllExerciseResponse getAllExerciseResponse =
        GetAllExerciseResponse.fromJson(
            await backendAPICall('/exercise/userExercises', {}, 'GET', true));
    analysisExerciseTableInformation =
        getAllExerciseResponse.exerciseInformation;
    notifyListeners();
  }
}
