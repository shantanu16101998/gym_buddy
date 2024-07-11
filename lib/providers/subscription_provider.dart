import 'package:flutter/material.dart';
import 'package:gym_buddy/database/user_subscription.dart' as db;
import 'package:gym_buddy/models/responses.dart';
import 'package:gym_buddy/models/user_subscription.dart';
import 'package:gym_buddy/utils/backend_api_call.dart';
import 'package:gym_buddy/utils/custom.dart';

class SubscriptionProvider extends ChangeNotifier {
  List<UserSubscription> allCurrentUsers = [];
  List<UserSubscription> allExpiredUsers = [];
  List<UserSubscription> currentUsers = [];
  List<UserSubscription> expiredUsers = [];
  bool searchFieldLoaded = false;
  bool subcriptionAPIDataFetched = false;

  void insertUserInDb(UserSubscription userSubscription) async {
    await db.insertUser(userSubscription);
    print('inserted this user $userSubscription');
    await fetchSubscription();

    notifyListeners();
  }

  updateSubscription(
      String userId, String startDate, String endMonth, String charges) async {
    await backendAPICall(
        '/customer/updateSubscription/$userId',
        {
          'currentBeginDate': startDate,
          if (tryParseInt(endMonth) != null) 'validTill': tryParseInt(endMonth),
          'charges': charges
        },
        'PUT',
        true);

    UserProfileResponse userProfileApiResponse = UserProfileResponse.fromJson(
        await backendAPICall(
            '/customer/getCustomerProfile/$userId', null, 'GET', true));

    allCurrentUsers.forEach((element) async {
      if (element.id == userId) {
        element.startDate = userProfileApiResponse.startDate;
        element.endDate = userProfileApiResponse.endDate;
        await db.updateUser(element);
      }
    });

    allExpiredUsers.forEach((element) async {
      if (element.id == userId) {
        element.startDate = userProfileApiResponse.startDate;
        element.endDate = userProfileApiResponse.endDate;
        await db.updateUser(element);
      }
    });

    currentUsers = allCurrentUsers;
    expiredUsers = allExpiredUsers;

    print('current user ixi $currentUsers');
    notifyListeners();
  }

  addedProfilePicOfUser(String userId) async {
    UserProfileResponse userProfileApiResponse = UserProfileResponse.fromJson(
        await backendAPICall(
            '/customer/getCustomerProfile/$userId', null, 'GET', true));

    allCurrentUsers.forEach((element) async {
      if (element.id == userId) {
        element.profilePic = userProfileApiResponse.profilePic;
        await db.updateUser(element);
      }
    });

    allExpiredUsers.forEach((element) async {
      if (element.id == userId) {
        element.profilePic = userProfileApiResponse.profilePic;
        await db.updateUser(element);
      }
    });

    currentUsers = allCurrentUsers;
    expiredUsers = allExpiredUsers;

    print('current user ixi $currentUsers');
    notifyListeners();
  }

  Future<void> deleteUser(String id) async {
    backendAPICall("/customer/deleteCustomer/$id", {}, "DELETE", true);

    await db.deleteUser(id);
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
      db.insertUser(user);
    });

    subscriptionDetailsResponse.expiredUsers.forEach((user) {
      db.insertUser(user);
    });

    notifyListeners();
  }

  Future<void> fetchSubscription() async {
    List<UserSubscription> allUsers = await db.getAllUsers();

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
