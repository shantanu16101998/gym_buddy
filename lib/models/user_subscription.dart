class UserSubscription {
  String? id;
  String? name;
  String? startDate;
  String? endDate;
  int? expiringDays;
  int? expiredDays;
  UserSubscription(this.name, this.startDate, this.endDate, this.expiringDays,
      this.expiredDays, this.id);

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    final String? name = json["customerName"];
    final String? startDate = json["currentBeginDate"];
    final String? endDate = json["currentFinishDate"];
    final int? expiringDays = json["expiring"];
    final int? expiredDays = json["expired"];
    final String? id = json["id"];

    return UserSubscription(
        name, startDate, endDate, expiringDays, expiredDays, id);
  }
}
