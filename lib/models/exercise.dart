import 'package:gym_buddy/models/table_information.dart';

class Exercise {
  final String name;
  final String id;
  final List<ExerciseInformation> exerciseInformationList;
  bool exerciseCompleted;

  Exercise(
      {required this.name,
      required this.exerciseInformationList,
      required this.exerciseCompleted,
      required this.id});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
        name: json['exerciseName'],
        exerciseInformationList: (json['sets'] as List<dynamic>)
            .map((jsonInformation) => ExerciseInformation.fromJson(
                jsonInformation as Map<String, dynamic>))
            .toList(),
        exerciseCompleted: false,
        id: json['exerciseId']);
  }
}
