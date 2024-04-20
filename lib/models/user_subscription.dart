class UserSubscription {
  int? id;
  String? name;
  String? startDate;
  String? endDate;
  int? expiringDays;
  int? expiredDays;
  UserSubscription(this.name, this.startDate, this.endDate, this.expiringDays,
      this.expiredDays, this.id);

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    final String? name = json["name"];
    final String? startDate = json["startDate"];
    final String? endDate = json["endDate"];
    final int? expiringDays = json["expiringDays"];
    final int? expiredDays = json["expiredDays"];
    final int? id = json["id"];

    return UserSubscription(
        name, startDate, endDate, expiringDays, expiredDays, id);
  }
}
