import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/custom_image_picker.dart';
import 'package:gym_buddy/components/owner/user_payment_form.dart';
import 'package:gym_buddy/constants/environment.dart';
import 'package:gym_buddy/firebase_options.dart';
import 'package:gym_buddy/providers/api_data_loaded.dart';
import 'package:gym_buddy/providers/customer_details.dart';
import 'package:gym_buddy/providers/excercise_provider.dart';
import 'package:gym_buddy/providers/exercise_list_provider.dart';
import 'package:gym_buddy/providers/subscription_provider.dart';
import 'package:gym_buddy/components/member/homepage.dart';
import 'package:gym_buddy/components/member/profile.dart' as MemberProfile;
import 'package:gym_buddy/components/member/workout_analysis.dart';
import 'package:gym_buddy/screens/owner/analysis_homepage.dart';
import 'package:gym_buddy/screens/owner/expanded_analysis.dart';
import 'package:gym_buddy/screens/owner/owner_form.dart';
import 'package:gym_buddy/screens/owner/profile.dart';
import 'package:gym_buddy/screens/owner/qr_page.dart';
import 'package:gym_buddy/screens/owner/owner.dart';
import 'package:gym_buddy/screens/owner/splash_screen.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/screens/owner/user_sign_up.dart';
import 'package:gym_buddy/services/local_notification.dart';
import 'package:gym_buddy/utils/enums.dart';
import 'package:gym_buddy/utils/firebase_api.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/* 
  IMP: Uncheck in production
*/
bool shouldEnableFirebase = !kIsWeb;

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
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() {
    return _MyAppState();
  }
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
        ChangeNotifierProvider(create: (context) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (context) => ExerciseProvider()),
        ChangeNotifierProvider(create: (context) => ExerciseListProvider()),
        ChangeNotifierProvider(create: (context) => ApiDataLoadedProvider()),
        ChangeNotifierProvider(create: (context) => CustomerDetailsProvider()),
      ],
      child: MaterialApp(
        title:
            appEnvironment == AppEnvironment.owner ? 'Gymania AI' : 'Gymania',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.red, primary: const Color(0xff667085)),
          primaryColor: const Color.fromARGB(255, 248, 248, 248),
        ),
        // uncomment when in prod
        home:  const SplashScreen(),
        // home: UserSignUp(),
        // home: Subscription(),
        // home: OwnerScreen(ownerScreens: OwnerScreens.analysis),
        // home: const Profile(userId: '667869fd29d826816fd0aa6e'),
        // home: UserPaymentForm(nextPageToShow: const Subscription()),
        routes: {
          '/owner-sign-up': (context) => const OwnerForm(),
          '/pic': (context) => const CustomImagePicker(),
          '/user-sign-up': (context) => const UserSignUp(),
          '/analysis': (context) => const AnalysisHomepage(),
          'qr-page': (context) => const QrPage(),
          '/analysis-expanded': (context) =>
              const ExpandedAnalysis(label: "earnings"),
          '/member/homepage': (context) => const Homepage(),
          '/member/analysis': (context) => const WorkoutAnalayis(),
          '/member/profile': (context) => const MemberProfile.Profile()
        },
      ),
    );
  }
}
