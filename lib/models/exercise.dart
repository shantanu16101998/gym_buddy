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
}
