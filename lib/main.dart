import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_image_picker.dart';
import 'package:gym_buddy/firebase_options.dart';
import 'package:gym_buddy/providers/subscription_provider.dart';
import 'package:gym_buddy/screens/owner/analysis_homepage.dart';
import 'package:gym_buddy/screens/owner/expanded_analysis.dart';
import 'package:gym_buddy/screens/owner/owner_form.dart';
import 'package:gym_buddy/screens/owner/profile.dart';
import 'package:gym_buddy/screens/owner/qr_page.dart';
import 'package:gym_buddy/screens/owner/splash_screen.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/screens/owner/user_sign_up.dart';
import 'package:gym_buddy/services/local_notification.dart';
import 'package:gym_buddy/utils/firebase_api.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SubscriptionProvider())
      ],
      child: MaterialApp(
        title: 'Gym Buddy',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.red, primary: const Color(0xff667085)),
          primaryColor: Colors.black,
        ),
        home: const SplashScreen(),
        routes: {
          '/owner-sign-up': (context) => const OwnerForm(),
          '/pic': (context) => const CustomImagePicker(),
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
      ),
    );
  }
}
