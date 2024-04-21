import 'package:flutter/material.dart';
import 'package:gym_buddy/screens/analysis_homepage.dart';
import 'package:gym_buddy/screens/expanded_analysis.dart';
import 'package:gym_buddy/screens/owner_form.dart';
import 'package:gym_buddy/screens/profile.dart';
import 'package:gym_buddy/screens/subscription.dart';
import 'package:gym_buddy/screens/user_sign_up.dart';

void main() {
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
      title: 'Mega Gym',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.red, primary: Color(0xff667085)),
        primaryColor: Colors.black,
      ),
      initialRoute: '/analysis-expanded',
      routes: {
        '/owner-sign-up': (context) => const OwnerForm(),
        '/user-sign-up': (context) => const UserSignUp(),
        '/subscription': (context) => const Subscription(),
        '/profile': (context) => const Profile(userId: 1),
        '/analysis': (context) => const AnalysisHomepage(),
        '/analysis-expanded': (context) =>
            const ExpandedAnalysis(label: "earnings")
      },
    );
  }
}
