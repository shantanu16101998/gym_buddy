import 'package:flutter/material.dart';
import 'package:gym_buddy/components/owner/app_scaffold.dart';
import 'package:gym_buddy/screens/owner/owner_form.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    decideRoute();
  }

  decideRoute() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString("jwtToken") == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const OwnerForm()));
    } else {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const Subscription()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold.noHeader(
      isApiDataLoaded: true,
      child: Container(),
    );
  }
}
