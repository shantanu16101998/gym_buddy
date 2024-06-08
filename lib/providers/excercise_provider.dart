import 'package:flutter/material.dart';
import 'package:gym_buddy/models/exercise.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/models/table_information.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/ui_constants.dart';

class ExerciseProvider extends ChangeNotifier {
  List<Exercise> exerciseList = [];

  Exercise lastRemovedExercise = Exercise(
      name: 'dumi',
      exerciseInformationList: [],
      exerciseCompleted: false,
      id: '');

  void addExercise(Exercise exercise) {
    exerciseList.add(exercise);
    backendAPICall(
        '/template/addExerciseToTemplate',
        {'exerciseId': exercise.id, 'exerciseName': exercise.name},
        'POST',
        true);
    notifyListeners();
  }

  void undoRemoveExercise() {
    exerciseList.add(lastRemovedExercise);
    notifyListeners();
  }

  void removeExercise(int index) {
    backendAPICall('/template/removeExercise',
        {'exerciseId': exerciseList[index].id}, 'DELETE', true);

    lastRemovedExercise = exerciseList[index];

    exerciseList.removeAt(index);
    notifyListeners();
  }

  void initDefaultExercise() {
    exerciseList.add(Exercise(
        name: 'Incline Bench Press (dumbbell)',
        id: '66614fdc062ac001a7662f91',
        exerciseInformationList: [
          ExerciseInformation(
              weightIndex: 0,
              repIndex: 0,
              isCompleted: false,
              exerciseDescriptionId: '')
        ],
        exerciseCompleted: false));
  }

  void initExercise() async {
    GetExerciseForDayResponse getExerciseForDayResponse =
        GetExerciseForDayResponse.fromJson(await backendAPICall(
            '/template/getExercisesForDay', {}, 'GET', true));
    exerciseList = getExerciseForDayResponse.exercises;
    notifyListeners();
  }

  void updateExerciseInformationListWeight(
      int exerciseIndex, int setNo, double value) {
    exerciseList[exerciseIndex].exerciseInformationList[setNo].weightIndex =
        defaultExerciseWeights.indexOf(value);

    backendAPICall(
        '/template/updateRepsAndWeight',
        {
          'exerciseName': exerciseList[exerciseIndex].name,
          'reps': defaultExerciseReps[exerciseList[exerciseIndex]
              .exerciseInformationList[setNo]
              .repIndex],
          'weight': defaultExerciseWeights[exerciseList[exerciseIndex]
              .exerciseInformationList[setNo]
              .weightIndex],
          'setNo': setNo,
          'exerciseId': exerciseList[exerciseIndex].id
        },
        'PUT',
        true);
    notifyListeners();
  }

  void updateExerciseInformationListReps(
      int exerciseIndex, int setNo, int value) {
    exerciseList[exerciseIndex].exerciseInformationList[setNo].repIndex =
        defaultExerciseReps.indexOf(value);

    backendAPICall(
        '/template/updateRepsAndWeight',
        {
          'exerciseName': exerciseList[exerciseIndex].name,
          'reps': defaultExerciseReps[exerciseList[exerciseIndex]
              .exerciseInformationList[setNo]
              .repIndex],
          'weight': defaultExerciseWeights[exerciseList[exerciseIndex]
              .exerciseInformationList[setNo]
              .weightIndex],
          'setNo': setNo,
          'exerciseId': exerciseList[exerciseIndex].id
        },
        'PUT',
        true);
    notifyListeners();
  }

  void addSetToExercise(int exerciseIndex) {
    exerciseList[exerciseIndex].exerciseInformationList.add(ExerciseInformation(
        weightIndex: 0,
        repIndex: 0,
        isCompleted: false,
        exerciseDescriptionId: ''));

    areAllExerciseCompleted(exerciseIndex);
    notifyListeners();

    backendAPICall(
        '/template/addSetToExercise',
        {
          'exerciseId': exerciseList[exerciseIndex].id,
          'exerciseName': exerciseList[exerciseIndex].name,
          'reps': defaultExerciseReps[0],
          'weight': defaultExerciseWeights[0]
        },
        'POST',
        true);
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
    backendAPICall(
        '/workoutLog/removeLogs',
        {"exerciseName": exerciseList[exerciseIndex].name, "setIndex": setNo},
        'DELETE',
        true);

    backendAPICall(
        '/template/removeSetFromExercise',
        {
          'exerciseDescriptionId': exerciseList[exerciseIndex]
              .exerciseInformationList[setNo]
              .exerciseDescriptionId
        },
        'DELETE',
        true);

    exerciseList[exerciseIndex].exerciseInformationList.removeAt(setNo);
    areAllExerciseCompleted(exerciseIndex);
    notifyListeners();
  }

  void markStatusOfSet(int exerciseIndex, int setNo) {
    if (!exerciseList[exerciseIndex]
        .exerciseInformationList[setNo]
        .isCompleted) {
      backendAPICall(
          '/workoutLog/addLogs',
          {
            "exerciseName": exerciseList[exerciseIndex].name,
            "setIndex": setNo,
            "weight": defaultExerciseWeights[exerciseList[exerciseIndex]
                .exerciseInformationList[setNo]
                .weightIndex],
            "reps": defaultExerciseReps[exerciseList[exerciseIndex]
                .exerciseInformationList[setNo]
                .repIndex]
          },
          'POST',
          true);
      exerciseList[exerciseIndex].exerciseInformationList[setNo].isCompleted =
          true;
    } else {
      backendAPICall(
          '/workoutLog/removeLogs',
          {"exerciseName": exerciseList[exerciseIndex].name, "setIndex": setNo},
          'DELETE',
          true);

      exerciseList[exerciseIndex].exerciseInformationList[setNo].isCompleted =
          false;
    }

    areAllExerciseCompleted(exerciseIndex);
    notifyListeners();
  }
}
