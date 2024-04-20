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
