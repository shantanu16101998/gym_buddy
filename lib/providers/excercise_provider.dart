import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gym_buddy/models/exercise.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/models/shared_preference_objects.dart';
import 'package:gym_buddy/models/table_information.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/ui_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseProvider extends ChangeNotifier {
  List<Exercise> exerciseList = [];
  bool exerciseFirstTimeInitialized = false;
  bool currentWeekDayExerciseInitialized = false;
  int providerDay = DateTime.now().weekday;

  Exercise lastRemovedExercise = Exercise(
      name: 'dumi',
      exerciseInformationList: [],
      exerciseCompleted: false,
      id: '');

  Future<bool> addExercise(Exercise exercise) async {
    AddExerciseResponse addExerciseResponse = AddExerciseResponse.fromJson(
        await backendAPICall(
            '/template/addExerciseToTemplate',
            {'exerciseId': exercise.id, 'exerciseName': exercise.name},
            'POST',
            true));

    if (addExerciseResponse.message == "EXERCISE_ALREADY_ADDED") {
      return false;
    } else {
      exerciseList.add(exercise);
      notifyListeners();
      return true;
    }
  }

  bool isProviderDayToday() {
    return providerDay == DateTime.now().weekday;
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

  void initExercise(int weekDay) async {
    GetExerciseForDayResponse getExerciseForDayResponse =
        GetExerciseForDayResponse.fromJson(await backendAPICall(
            '/template/getExercisesForDay', {'day': weekDay}, 'POST', true));

    providerDay = weekDay;

    if (weekDay == DateTime.now().weekday) {
      exerciseList =
          await updateCompletedExercises(getExerciseForDayResponse.exercises);

      for (var entry in exerciseList.asMap().entries) {
        areAllExerciseCompleted(entry.key);
      }
    } else {
      exerciseList = getExerciseForDayResponse.exercises;
    }

    if (!exerciseFirstTimeInitialized) {
      exerciseFirstTimeInitialized = true;
    }

    currentWeekDayExerciseInitialized = true;
    notifyListeners();
  }

  void increaseProviderDay() async {
    providerDay = providerDay + 1;
    currentWeekDayExerciseInitialized = false;
    notifyListeners();
    initExercise(providerDay);
  }

  void decreaseProviderDay() async {
    providerDay = providerDay - 1;
    currentWeekDayExerciseInitialized = false;
    notifyListeners();
    initExercise(providerDay);
  }

  Future<List<Exercise>> updateCompletedExercises(
      List<Exercise> exerciseList) async {
    var key =
        '${DateTime.now().day} ${DateTime.now().month} ${DateTime.now().year}';
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String value = sharedPreferences.getString(exerciseCompletionKey) ?? "";

    if (value != "") {
      Map<String, dynamic> json = jsonDecode(value);

      ExerciseDayInformation exerciseDayInformation =
          ExerciseDayInformation.fromJson(json);

      if (exerciseDayInformation.date == key) {
        for (var exercise in exerciseList) {
          for (var exerciseInformation in exercise.exerciseInformationList) {
            if (exerciseDayInformation.exerciseCompletionList
                .contains(exerciseInformation.exerciseDescriptionId)) {
              exerciseInformation.isCompleted = true;
            }
          }
        }

        return exerciseList;
      } else {
        ExerciseDayInformation exerciseDayInformation = ExerciseDayInformation(
            date: key, exerciseCompletionList: <String>{});

        sharedPreferences.setString(
            exerciseCompletionKey, jsonEncode(exerciseDayInformation.toJson()));
        return exerciseList;
      }
    } else {
      ExerciseDayInformation exerciseDayInformation =
          ExerciseDayInformation(date: key, exerciseCompletionList: <String>{});

      sharedPreferences.setString(
          exerciseCompletionKey, jsonEncode(exerciseDayInformation.toJson()));

      return exerciseList;
    }
  }

  void updateExerciseInformationListWeight(
      int exerciseIndex, int setNo, double value) {
    exerciseList[exerciseIndex].exerciseInformationList[setNo].weightIndex =
        defaultExerciseWeights.indexOf(value);

    backendAPICall(
        '/template/updateSet',
        {
          'exerciseName': exerciseList[exerciseIndex].name,
          'reps': defaultExerciseReps[exerciseList[exerciseIndex]
              .exerciseInformationList[setNo]
              .repIndex],
          'weight': defaultExerciseWeights[exerciseList[exerciseIndex]
              .exerciseInformationList[setNo]
              .weightIndex],
          'setNo': setNo,
          'exerciseDescriptionId': exerciseList[exerciseIndex]
              .exerciseInformationList[setNo]
              .exerciseDescriptionId
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
        '/template/updateSet',
        {
          'exerciseName': exerciseList[exerciseIndex].name,
          'reps': defaultExerciseReps[exerciseList[exerciseIndex]
              .exerciseInformationList[setNo]
              .repIndex],
          'weight': defaultExerciseWeights[exerciseList[exerciseIndex]
              .exerciseInformationList[setNo]
              .weightIndex],
          'setNo': setNo,
          'exerciseDescriptionId': exerciseList[exerciseIndex]
              .exerciseInformationList[setNo]
              .exerciseDescriptionId
        },
        'PUT',
        true);
    notifyListeners();
  }

  ExerciseInformation getLastExerciseInformation(int exerciseIndex) {
    if (exerciseList[exerciseIndex].exerciseInformationList.isEmpty) {
      return ExerciseInformation(
          weightIndex: 0,
          repIndex: 0,
          isCompleted: false,
          exerciseDescriptionId: '');
    } else {
      return ExerciseInformation(
          weightIndex: exerciseList[exerciseIndex]
              .exerciseInformationList
              .last
              .weightIndex,
          repIndex:
              exerciseList[exerciseIndex].exerciseInformationList.last.repIndex,
          isCompleted: false,
          exerciseDescriptionId: '');
    }
  }

  void addSetToExercise(int exerciseIndex) async {
    exerciseList[exerciseIndex]
        .exerciseInformationList
        .add(getLastExerciseInformation(exerciseIndex));

    areAllExerciseCompleted(exerciseIndex);
    notifyListeners();

    AddSetResponse addSetResponse =
        AddSetResponse.fromJson(await backendAPICall(
            '/template/addSetToExercise',
            {
              'exerciseId': exerciseList[exerciseIndex].id,
              'exerciseName': exerciseList[exerciseIndex].name,
              'reps': defaultExerciseReps[0],
              'weight': defaultExerciseWeights[0]
            },
            'POST',
            true));

    exerciseList[exerciseIndex]
        .exerciseInformationList
        .last
        .exerciseDescriptionId = addSetResponse.exerciseDescriptionId;
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

  void markStatusOfSet(int exerciseIndex, int setNo) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

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

      var value = sharedPreferences.getString(exerciseCompletionKey) ?? "";

      if (value != "") {
        ExerciseDayInformation exerciseDayInformation =
            ExerciseDayInformation.fromJson(jsonDecode(value));

        exerciseDayInformation.exerciseCompletionList.add(
            exerciseList[exerciseIndex]
                .exerciseInformationList[setNo]
                .exerciseDescriptionId);

        sharedPreferences.setString(
            exerciseCompletionKey, jsonEncode(exerciseDayInformation.toJson()));
      }
    } else {
      backendAPICall(
          '/workoutLog/removeLogs',
          {"exerciseName": exerciseList[exerciseIndex].name, "setIndex": setNo},
          'DELETE',
          true);

      exerciseList[exerciseIndex].exerciseInformationList[setNo].isCompleted =
          false;

      var value = sharedPreferences.getString(exerciseCompletionKey) ?? "";

      if (value != "") {
        ExerciseDayInformation exerciseDayInformation =
            ExerciseDayInformation.fromJson(jsonDecode(value));

        exerciseDayInformation.exerciseCompletionList.remove(
            exerciseList[exerciseIndex]
                .exerciseInformationList[setNo]
                .exerciseDescriptionId);

        sharedPreferences.setString(
            exerciseCompletionKey, jsonEncode(exerciseDayInformation.toJson()));
      }
    }

    areAllExerciseCompleted(exerciseIndex);
    notifyListeners();
  }
}
