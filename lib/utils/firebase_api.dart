import 'package:firebase_messaging/firebase_messaging.dart';

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
    print(firebaseCloudMessagingToken);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
