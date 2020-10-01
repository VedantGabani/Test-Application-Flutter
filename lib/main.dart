import 'package:flutter/material.dart';
import 'package:test_application/HomePage.dart';
import 'package:test_application/LoginPage.dart';
import 'package:test_application/RegistrationPage.dart';
import 'package:test_application/mainDashboard.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Demo Application',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        MainDashboard.id: (context) => MainDashboard(),
      },
    );
  }
}
