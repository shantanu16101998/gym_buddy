const String exerciseCompletionKey = "exercise_completed";

// Map key = date month year
class ExerciseDayInformation {
  String date;
  Set<String> exerciseCompletionList;
  ExerciseDayInformation(
      {required this.date, required this.exerciseCompletionList});

  factory ExerciseDayInformation.fromJson(Map<String, dynamic> json) {
    return ExerciseDayInformation(
      date: json['date'],
      exerciseCompletionList: Set<String>.from(json['exerciseCompletionList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'exerciseCompletionList': exerciseCompletionList.toList(),
    };
  }
}
