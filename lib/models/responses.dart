import 'package:gym_buddy/models/user_subscription.dart';

class LoginResponse {
  final String? jwtToken;
  final String? name;
  final String? gymName;
  final String? contact;
  final String? lat;
  final String? lon;

  const LoginResponse(
      {this.jwtToken,
      this.name,
      this.gymName,
      this.contact,
      this.lat,
      this.lon});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final String? jwtToken = json['token'];
    final String? name = json['name'];
    final String? gymName = json['gymName'];
    final String? contact = json['contact'];
    final String? lat = json['lat'];
    final String? lon = json['lon'];

    return LoginResponse(
        jwtToken: jwtToken,
        name: name,
        gymName: gymName,
        contact: contact,
        lat: lat,
        lon: lon);
  }
}

class OwnerRegistrationResponse {
  final String? jwtToken;
  final String? gymName;
  final String? contact;

  const OwnerRegistrationResponse({this.jwtToken, this.gymName, this.contact});

  factory OwnerRegistrationResponse.fromJson(Map<String, dynamic> json) {
    final String? jwtToken = json['token'];
    final String? gymName = json['owner']['gymName'];
    final String? contact = json['owner']['contact'];

    return OwnerRegistrationResponse(
        jwtToken: jwtToken, gymName: gymName, contact: contact);
  }
}

class SubscriptionDetailsResponse {
  final List<dynamic> currentUsers;
  final List<dynamic> expiredUsers;

  const SubscriptionDetailsResponse(
      {required this.currentUsers, required this.expiredUsers});

  factory SubscriptionDetailsResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> currentUsers = json["current"]
        .map((userJson) => UserSubscription.fromJson(userJson))
        .toList();
    final List<dynamic> expiredUsers = json["expired"]
        .map((userJson) => UserSubscription.fromJson(userJson))
        .toList();
    return SubscriptionDetailsResponse(
        currentUsers: currentUsers, expiredUsers: expiredUsers);
  }
}

class OwnerDeeplinkResponse {
  final String upiId;

  const OwnerDeeplinkResponse({required this.upiId});

  factory OwnerDeeplinkResponse.fromJson(Map<String, dynamic> json) {
    return OwnerDeeplinkResponse(upiId: json["upiId"]);
  }
}

class UserProfileResponse {
  final String name;
  final String phone;
  final String? profilePic;
  final String? startDate;
  final int? validTill;
  final String? traineeName;

  const UserProfileResponse(
      {required this.name,
      required this.phone,
      required this.profilePic,
      required this.validTill,
      required this.startDate,
      required this.traineeName});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
        name: json["name"] ?? "",
        phone: json["contact"].toString(),
        validTill: json["validTill"],
        startDate: json["currentBeginDate"],
        traineeName: json["trainerName"],
        profilePic: json["profilePic"]);
  }
}

class AnalysisHomepageResponse {
  final int earnings;
  final int numberOfPeople;
  final int averageMonth;
  final int males;
  final int females;

  const AnalysisHomepageResponse(
      {required this.earnings,
      required this.numberOfPeople,
      required this.averageMonth,
      required this.males,
      required this.females});

  factory AnalysisHomepageResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisHomepageResponse(
      earnings: json["earnings"],
      numberOfPeople: json["numberOfPeople"],
      averageMonth: json["averageMonth"],
      males: json["males"],
      females: json["females"],
    );
  }
}

class ExpandedAnalysisResponse {
  final List<String> titles;
  final List<int> data;
  final String average;
  final String total;
  final num maxLimitOfData;

  ExpandedAnalysisResponse(
      {required this.titles,
      required this.data,
      required this.average,
      required this.total,
      required this.maxLimitOfData});

  factory ExpandedAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return ExpandedAnalysisResponse(
        average: json["average"],
        titles: List<String>.from(json["titles"]),
        data: List<int>.from(json["data"]),
        maxLimitOfData: json["maxLimitOfData"],
        total: json["total"]);
  }
}

class DuplicateEmailCheckResponse {
  final bool unique;

  DuplicateEmailCheckResponse({required this.unique});

  factory DuplicateEmailCheckResponse.fromJson(Map<String, dynamic> json) {
    return DuplicateEmailCheckResponse(unique: json['unique']);
  }
}

class RegisterCustomerResponse {
  final String? profilePic;

  RegisterCustomerResponse({this.profilePic});

  factory RegisterCustomerResponse.fromJson(Map<String, dynamic> json) {
    return RegisterCustomerResponse(profilePic: json['profilePic']);
  }
}

class MemberLoginResponse {
  final String? name;
  final String token;

  MemberLoginResponse({this.name, required this.token});

  factory MemberLoginResponse.fromJson(Map<String, dynamic> json) {
    return MemberLoginResponse(name: json['name'], token: json['token']);
  }
}

class MonthData {
  final String year;
  final String month;
  final List<int> days;

  MonthData({required this.year, required this.month, required this.days});

  factory MonthData.fromJson(Map<String, dynamic> json) {
    return MonthData(
      year: json['year'],
      month: json['month'],
      days: List<int>.from(json['days']),
    );
  }
}

class AttendanceResponse {
  final List<MonthData> attendanceData;

  AttendanceResponse({required this.attendanceData});

  factory AttendanceResponse.fromJson(List<dynamic> json) {
    List<MonthData> data =
        json.map((monthJson) => MonthData.fromJson(monthJson)).toList();
    return AttendanceResponse(attendanceData: data);
  }
}

class TraineeDetailsResponse {
  final String name;
  final int experience;
  final String id;

  TraineeDetailsResponse(
      {required this.name, required this.experience, required this.id});

  factory TraineeDetailsResponse.fromJson(Map<String, dynamic> json) {
    return TraineeDetailsResponse(
      name: json['name'] as String,
      experience: json['experience'] as int,
      id: json['_id'] as String,
    );
  }
}

class OwnerDetails {
  final String name;
  final String gymName;
  final String contact;
  final List<TraineeDetailsResponse> traineeDetails;

  OwnerDetails({
    required this.name,
    required this.contact,
    required this.gymName,
    required this.traineeDetails,
  });

  factory OwnerDetails.fromJson(Map<String, dynamic> json) {
    final List<TraineeDetailsResponse> trainees =
        (json['trainees'] as List<dynamic>?)
                ?.map((e) =>
                    TraineeDetailsResponse.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [];

    return OwnerDetails(
      name: json['name'] as String,
      gymName: json['gymName'] as String,
      contact: json['contact'] as String,
      traineeDetails: trainees,
    );
  }
}

class MemberProfileResponse {
  final String name;
  final String contact;
  final String startDate;
  final int validTill;
  final String trainerName;
  MemberProfileResponse(
      {required this.name,
      required this.contact,
      required this.startDate,
      required this.validTill,
      required this.trainerName});

  factory MemberProfileResponse.fromJson(Map<String, dynamic> json) {
    return MemberProfileResponse(
        name: json['name'] ?? "",
        contact: json['contact'] ?? "",
        startDate: json['currentBeginDate'] ?? "",
        trainerName: json['trainerName'] ?? "None",
        validTill: json['validTill'] ?? 0);
  }
}
