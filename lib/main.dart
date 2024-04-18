import 'package:flutter/material.dart';
import 'package:gym_buddy/screens/owner_form.dart';
import 'package:gym_buddy/screens/user_sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.red, primary: Colors.blue),
        primaryColor: Colors.black,
      ),
      initialRoute: '/owner-sign-up',
      routes: {
        '/owner-sign-up': (context) => const OwnerForm(),
        '/user-sign-up': (context) => const UserSignUp()
      },
    );
  }
}
