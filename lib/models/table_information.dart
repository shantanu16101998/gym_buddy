import 'package:gym_buddy/utils/ui_constants.dart';

class ExerciseTableRow {
  String? setNo;
  bool? isSetCompleted;
  String? weight;
  String? reps;

  ExerciseTableRow(this.isSetCompleted, this.reps, this.setNo, this.weight);
}

class TableInformation {
  final List<ExerciseTableRow> tableRows;
  TableInformation(this.tableRows);
}

class ExerciseInformation {
  int weightIndex = 0;
  int repIndex = 0;
  bool isCompleted = false;
  String exerciseDescriptionId;

  ExerciseInformation(
      {required this.weightIndex,
      required this.repIndex,
      required this.isCompleted,
      required this.exerciseDescriptionId});

  factory ExerciseInformation.fromJson(Map<String, dynamic> json) {
    return ExerciseInformation(
        weightIndex: defaultExerciseWeights.indexOf(json['weight']),
        repIndex: defaultExerciseReps.indexOf(json['reps']),
        exerciseDescriptionId: json['exerciseDescriptionId'],
        isCompleted: false);
  }
}
