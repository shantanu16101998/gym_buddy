import 'package:flutter/material.dart';
import 'package:gym_buddy/database/user_subscription.dart';
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/models/user_subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/custom.dart';

class SubscriptionProvider extends ChangeNotifier {
  List allCurrentUsers = [];
  List allExpiredUsers = [];
  List currentUsers = [];
  List expiredUsers = [];
  bool searchFieldLoaded = false;
  bool subcriptionAPIDataFetched = false;

  void insertUserInDb(UserSubscription userSubscription) async {
    await insertUser(userSubscription);
    print('inserted this user $userSubscription');
    await fetchSubscription();

    notifyListeners();
  }

  Future<void> fetchSubscriptionFromAPI() async {
    SubscriptionDetailsResponse subscriptionDetailsResponse =
        SubscriptionDetailsResponse.fromJson(
            await backendAPICall('/customer/getCustomers', null, "GET", true));
    allCurrentUsers = subscriptionDetailsResponse.currentUsers;
    allExpiredUsers = subscriptionDetailsResponse.expiredUsers;
    currentUsers = subscriptionDetailsResponse.currentUsers;
    expiredUsers = subscriptionDetailsResponse.expiredUsers;
    subcriptionAPIDataFetched = true;

    subscriptionDetailsResponse.currentUsers.forEach((user) {
      insertUser(user);
    });

    subscriptionDetailsResponse.expiredUsers.forEach((user) {
      insertUser(user);
    });

    notifyListeners();
  }

  Future<void> fetchSubscription() async {
    List<UserSubscription> allUsers = await getAllUsers();

    fetchSubscriptionFromAPI();

    if (allUsers.isEmpty) {
      fetchSubscriptionFromAPI();
    } else {
      allUsers.forEach((user) {
        user.expiringDays = expiringDayToShow(user.endDate);

        user.expiredDays = expiredDayToShow(user.endDate);
      });
      subcriptionAPIDataFetched = true;

      currentUsers = allUsers
          .where((user) => getDaysRemainingFromToday(user.endDate) > 0)
          .toList();

      expiredUsers = allUsers
          .where((user) => getDaysRemainingFromToday(user.endDate) <= 0)
          .toList();

      allCurrentUsers = currentUsers;
      allExpiredUsers = expiredUsers;

      notifyListeners();
    }
  }

  changeImagePath(String customerId) async {
    String customerProfilePicUrl = GetProfilePicUrl.fromJson(
            await backendAPICall('/aws/image/$customerId', {}, 'GET', true))
        .url;

    try {
      var user =
          allCurrentUsers.firstWhere((element) => element.id == customerId);
      user.profilePic = customerProfilePicUrl;
      currentUsers = allCurrentUsers;

      notifyListeners();
    } catch (e) {
      try {
        var user =
            allExpiredUsers.firstWhere((element) => element.id == customerId);
        user.profilePic = customerProfilePicUrl;
        expiredUsers = allExpiredUsers;
      } catch (e) {
        print("User with ID $customerId not found.");
      }
    }
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
