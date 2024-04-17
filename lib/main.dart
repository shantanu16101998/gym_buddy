import 'package:flutter/material.dart';
import 'package:gym_buddy/screens/owner_sign_up.dart';
import 'package:gym_buddy/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  String initialRoute = '/owner-sign-up';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.red,
          primary: Colors.blue
        ),
        primaryColor: Colors.black,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const Login(),
        '/owner-sign-up' : (context) => const OwnerSignUp()
      },
    );
  }
}
