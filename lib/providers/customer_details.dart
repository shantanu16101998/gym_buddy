import 'package:flutter/material.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';

class CustomerDetailsProvider extends ChangeNotifier {
  MemberProfileResponse memberProfileResponse = MemberProfileResponse(
      name: '',
      contact: '',
      startDate: '',
      validTill: 1,
      trainerName: null,
      currentWeekAttendance: '',
      gymLocationLat: 1,
      gymLocationLon: 1);
  late IdCardResponse idCardResponse;

  Future<MemberProfileResponse> fetchMemberProfileResponse() async {
    memberProfileResponse = MemberProfileResponse.fromJson(
        await backendAPICall('/customer/details', {}, 'GET', true));
    return memberProfileResponse;
  }

  Future<IdCardResponse> fetchIdCardResponse() async {
    idCardResponse = IdCardResponse.fromJson(
        await backendAPICall('/customer/idCard', {}, 'GET', true));
    return idCardResponse;
  }
}
