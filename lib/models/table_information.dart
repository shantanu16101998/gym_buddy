class TableRow {
  String? setNo;
  String? previous;
  String? weight;
  String? reps;

  TableRow(this.previous, this.reps, this.setNo, this.weight);
}

class TableInformation {
  final List<TableRow> tableRows;
  TableInformation(this.tableRows);
}

class ExerciseInformation {
  final double weight;
  final int reps;
  bool isCompleted = false;

  ExerciseInformation(this.weight,this.reps);
}
