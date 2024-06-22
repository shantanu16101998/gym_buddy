class TraineeDetails {
  final String name;
  final String experience;

  TraineeDetails({required this.name, required this.experience});

  Map<String, dynamic> toJson() {
    return {
      'name': name.toString().trim(),
      if (experience != '') 'experience': experience.toString().trim(),
    };
  }
}
