import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAPI {
  final firebaseMesaging = FirebaseMessaging.instance;

  Future<void> handleBackgroundMessage(RemoteMessage remoteMessage) {
    print('Title ${remoteMessage.notification?.title}');
    print('Title ${remoteMessage.notification?.body}');
    return Future.value();
  }

  Future<void> initNotification() async {
    await firebaseMesaging.requestPermission();
    final firebaseCloudMessagingToken = await firebaseMesaging.getToken();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("fcmToken", firebaseCloudMessagingToken ?? "");
    print("fcm token is $firebaseCloudMessagingToken");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
