import 'package:gym_buddy/models/exercise.dart';
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
  final String currentWeekAttendance;
  MemberProfileResponse(
      {required this.name,
      required this.contact,
      required this.startDate,
      required this.validTill,
      required this.trainerName,
      required this.currentWeekAttendance});

  factory MemberProfileResponse.fromJson(Map<String, dynamic> json) {
    return MemberProfileResponse(
        name: json['name'] ?? "",
        contact: json['contact'] ?? "",
        startDate: json['currentBeginDate'] ?? "",
        trainerName: json['trainerName'] ?? "None",
        validTill: json['validTill'] ?? 0,
        currentWeekAttendance: json['currentWeekAttendance']);
  }
}

class ComparisionData {
  List<String> titles;
  List<int> data;
  int maxLimitOfData;
  int minLimitOfData;
  double top;
  int highlightTitle;

  ComparisionData(
      {required this.titles,
      required this.data,
      required this.maxLimitOfData,
      required this.top,
      required this.minLimitOfData,
      required this.highlightTitle});

  factory ComparisionData.fromJson(Map<String, dynamic> json) {
    return ComparisionData(
        titles: List<String>.from(json['titles']),
        data: List<int>.from(json['data']),
        maxLimitOfData: json['maxLimitOfData'],
        minLimitOfData: json['minLimitOfData'],
        highlightTitle: json['highlightTitle'],
        top: json['top']);
  }
}

class GrowthData {
  List<String> titles;
  List<int> data;
  int maxLimitOfData;
  int minLimitOfData;

  GrowthData(
      {required this.titles,
      required this.data,
      required this.maxLimitOfData,
      required this.minLimitOfData});

  factory GrowthData.fromJson(Map<String, dynamic> json) {
    return GrowthData(
      titles: List<String>.from(json['titles']),
      data: List<int>.from(json['data']),
      minLimitOfData: json['minLimitOfData'],
      maxLimitOfData: json['maxLimitOfData'],
    );
  }
}

class WorkoutAnalysisResponse {
  ComparisionData comparisionData;
  GrowthData growthData;

  WorkoutAnalysisResponse(
      {required this.comparisionData, required this.growthData});

  factory WorkoutAnalysisResponse.fromJson(Map<String, dynamic> json) {
    return WorkoutAnalysisResponse(
        comparisionData: ComparisionData.fromJson(json['comparisionData']),
        growthData: GrowthData.fromJson(json['growthData']));
  }
}

class IdCardResponse {
  String gymName;
  String gymContact;
  String memberName;
  String planDue;
  int planDuration;
  String planid;
  String customerPic;
  String? error;

  IdCardResponse(
      {required this.customerPic,
      required this.gymContact,
      required this.memberName,
      required this.planDue,
      required this.planDuration,
      required this.planid,
      required this.gymName});

  factory IdCardResponse.fromJson(Map<String, dynamic> json) {
    return IdCardResponse(
        customerPic: json['customerPic'],
        gymContact: json['gymContact'],
        memberName: json['memberName'],
        planDue: json['planDue'],
        planDuration: json['planDuration'],
        planid: json['planid'],
        gymName: json['gymName']);
  }
}

class ExercisesTableInformation {
  String id;
  String name;

  ExercisesTableInformation({required this.id, required this.name});

  factory ExercisesTableInformation.fromJson(Map<String, dynamic> json) {
    return ExercisesTableInformation(id: json['_id'], name: json['name']);
  }
}

class GetAllExerciseResponse {
  List<ExercisesTableInformation> exerciseInformation;

  GetAllExerciseResponse({required this.exerciseInformation});

  factory GetAllExerciseResponse.fromJson(Map<String, dynamic> json) {
    final List<ExercisesTableInformation> exerciseInformation =
        (json["exercises"] as List<dynamic>)
            .map((information) => ExercisesTableInformation.fromJson(
                information as Map<String, dynamic>))
            .toList();

    return GetAllExerciseResponse(exerciseInformation: exerciseInformation);
  }
}

class GetInviteCodeResponse {
  String referralCode;

  GetInviteCodeResponse({required this.referralCode});

  factory GetInviteCodeResponse.fromJson(Map<String, dynamic> json) {
    return GetInviteCodeResponse(referralCode: json['referralCode']);
  }
}

class GetExerciseForDayResponse {
  List<Exercise> exercises;
  GetExerciseForDayResponse({required this.exercises});
  factory GetExerciseForDayResponse.fromJson(Map<String, dynamic> json) {
    return GetExerciseForDayResponse(
        exercises: (json['exercises'] as List<dynamic>)
            .map((exercise) =>
                Exercise.fromJson(exercise as Map<String, dynamic>))
            .toList());
  }
}