import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/constants/environment.dart';
import 'package:gym_buddy/screens/member/homepage.dart';
import 'package:gym_buddy/screens/member/member_login_form.dart';
import 'package:gym_buddy/screens/owner/owner_form.dart';
import 'package:gym_buddy/screens/owner/subscription.dart';
import 'package:gym_buddy/utils/enums.dart';
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

    if (appEnvironment == AppEnvironment.owner) {
      if (sharedPreferences.getString("jwtToken") == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const OwnerForm()));
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const Subscription()));
      }
    } else if (appEnvironment == AppEnvironment.member) {
      if (sharedPreferences.getString("jwtToken") == null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MemberLoginForm()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Homepage()));
      }
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
