class TableRow {
  String? setNo;
  bool? isSetCompleted;
  String? weight;
  String? reps;

  TableRow(this.isSetCompleted, this.reps, this.setNo, this.weight);
}

class TableInformation {
  final List<TableRow> tableRows;
  TableInformation(this.tableRows);
}

class ExerciseInformation {
  int weightIndex = 0;
  int repIndex = 0;
  bool isCompleted = false;

  ExerciseInformation(this.weightIndex, this.repIndex, this.isCompleted);
}
