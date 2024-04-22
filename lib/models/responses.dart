import 'package:gym_buddy/models/user_subscription.dart';

class LoginResponse {
  final String? jwtToken;

  const LoginResponse({this.jwtToken});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final String? jwtToken = json['jwtToken'];

    if (jwtToken != null) {
      return LoginResponse(jwtToken: jwtToken);
    } else {
      return const LoginResponse(jwtToken: null);
    }
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

class UserProfileResponse {
  final String name;
  final String email;
  final String address;
  final String age;
  final String phone;
  final String bloodGroup;
  final String gender;

  const UserProfileResponse(
      {required this.name,
      required this.email,
      required this.address,
      required this.age,
      required this.phone,
      required this.bloodGroup,
      required this.gender});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
        name: json["name"] ?? "",
        email: json["email"] ?? "",
        address: json["address"] ?? "",
        age: json["age"] ?? "",
        bloodGroup: json["blood group"] ?? "",
        phone: json["phone"] ?? "",
        gender: json["gender"] ?? "");
  }
}

class AnalysisHomepageResponse {
  final int earnings;
  final int numberOfPeople;
  final String averageMonth;
  final String genderRatio;

  const AnalysisHomepageResponse(
      {required this.earnings,
      required this.numberOfPeople,
      required this.averageMonth,
      required this.genderRatio});

  factory AnalysisHomepageResponse.fromJson(Map<String, dynamic> json) {
    return AnalysisHomepageResponse(
        earnings: json["earnings"],
        numberOfPeople: json["numberOfPeople"],
        averageMonth: json["averageMonth"],
        genderRatio: json["genderRatio"]);
  }
}

class ExpandedAnalysisResponse {
  final List<String> titles;
  final List<int> data;
  final String average;
  final String total;
  final int maxLimitOfData;

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
