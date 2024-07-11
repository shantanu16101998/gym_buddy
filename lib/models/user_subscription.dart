class UserSubscription {
  String? id;
  String? name;
  String? startDate;
  String endDate;
  int? expiringDays;
  int? expiredDays;
  String? profilePic;
  String? contact;
  String? experience;
  UserSubscription(
      this.name,
      this.startDate,
      this.endDate,
      this.expiringDays,
      this.expiredDays,
      this.id,
      this.profilePic,
      this.contact,
      this.experience);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      if(expiringDays != null) 'expiringDays': expiringDays,
      if(expiredDays != null) 'expiredDays': expiredDays,
      if(profilePic != null) 'profilePic': profilePic,
      if(contact != null) 'contact': contact,
      if(experience != null) 'experience': experience,
    };
  }

  @override
  String toString() {
    return 'UserSubscription{id: $id, name: $name, expiringDays: $expiringDays, currentFinishDate: $endDate  }';
  }

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    final String? name = json["customerName"] ?? json["name"];
    final String? startDate = json["currentBeginDate"];
    final String endDate = json["currentFinishDate"];
    final int? expiringDays = json["expiring"];
    final int? expiredDays = json["expired"];
    final String? id = json["id"] ?? json["_id"];
    final String? profilePic = json["profilePic"];
    final String? contact = json['contact'];
    final String? experience = json['experience'];

    return UserSubscription(name, startDate, endDate, expiringDays, expiredDays,
        id, profilePic, contact, experience);
  }
}
