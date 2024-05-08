import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:gym_buddy/firebase_options.dart';
import 'package:gym_buddy/screens/analysis_homepage.dart';
import 'package:gym_buddy/screens/expanded_analysis.dart';
import 'package:gym_buddy/screens/owner_form.dart';
import 'package:gym_buddy/screens/profile.dart';
import 'package:gym_buddy/screens/qr_page.dart';
import 'package:gym_buddy/screens/splash_screen.dart';
import 'package:gym_buddy/screens/subscription.dart';
import 'package:gym_buddy/screens/user_sign_up.dart';
import 'package:gym_buddy/services/local_notification.dart';
import 'package:gym_buddy/utils/firebase_api.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

bool shouldEnableFirebase = false;

enum PlatForm { local, production }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications(flutterLocalNotificationsPlugin);

  if (shouldEnableFirebase) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseAPI().initNotification();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.red, primary: const Color(0xff667085)),
        primaryColor: Colors.black,
      ),
      home: const SplashScreen(),
      routes: {
        '/owner-sign-up': (context) => const OwnerForm(),
        '/user-sign-up': (context) => const UserSignUp(),
        '/subscription': (context) => const Subscription(),
        '/profile': (context) => const Profile(
              userId: '66325499462eb7c05506b543',
            ),
        '/analysis': (context) => const AnalysisHomepage(),
        'qr-page': (context) => const QrPage(),
        '/analysis-expanded': (context) =>
            const ExpandedAnalysis(label: "earnings")
      },
    );
  }
}
