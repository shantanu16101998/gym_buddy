import 'package:gym_buddy/models/table_information.dart';

class Exercise {
  final String name;
  final List<ExerciseInformation> exerciseInformationList;
  bool exerciseCompleted;

  Exercise(this.name, this.exerciseInformationList, this.exerciseCompleted);
}
