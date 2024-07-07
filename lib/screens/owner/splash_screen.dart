import 'package:flutter/material.dart';
import 'package:gym_buddy/components/common/app_scaffold.dart';
import 'package:gym_buddy/constants/environment.dart';
import 'package:gym_buddy/screens/common/test.dart';
import 'package:gym_buddy/screens/member/member.dart';
import 'package:gym_buddy/screens/member/member_login_form.dart';
import 'package:gym_buddy/screens/owner/owner.dart';
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
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const OwnerForm()));
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Subscription()));
        }
      }
    } else if (appEnvironment == AppEnvironment.member) {
      if (sharedPreferences.getString("jwtToken") == null) {
        if (mounted) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MemberLoginForm()));
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MemberScreen(
                      customerScreens: CustomerScreens.homepage)));
        }
      }
    } else if (appEnvironment == AppEnvironment.test) {
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Test()));
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
