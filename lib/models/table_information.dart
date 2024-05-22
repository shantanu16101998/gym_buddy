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
