import 'package:flutter/material.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';

class SubscriptionProvider extends ChangeNotifier {
  List allCurrentUsers = [];
  List allExpiredUsers = [];
  List currentUsers = [];
  List expiredUsers = [];
  bool searchFieldLoaded = false;
  bool subcriptionAPIDataFetched = false;

  Future<void> fetchSubscription() async {
    SubscriptionDetailsResponse subscriptionDetailsResponse =
        SubscriptionDetailsResponse.fromJson(
            await backendAPICall('/customer/getCustomers', null, "GET", true));
    allCurrentUsers = subscriptionDetailsResponse.currentUsers;
    allExpiredUsers = subscriptionDetailsResponse.expiredUsers;
    currentUsers = subscriptionDetailsResponse.currentUsers;
    expiredUsers = subscriptionDetailsResponse.expiredUsers;
    subcriptionAPIDataFetched = true;
    notifyListeners();
  }

  onSearchTextFieldChanged(String currentText) {
    if (searchFieldLoaded) {
      currentUsers = allCurrentUsers
          .where((currentUser) =>
              currentUser.name.toLowerCase()!.contains(currentText))
          .toList();
      expiredUsers = allExpiredUsers
          .where((expiredUser) =>
              expiredUser.name.toLowerCase()!.contains(currentText))
          .toList();
      notifyListeners();
    } else {
      searchFieldLoaded = true;
    }
  }
}
