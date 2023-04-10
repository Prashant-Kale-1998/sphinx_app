import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sphinx_app/home_screen/home_screen.dart';
import 'package:sphinx_app/map/map_screen.dart';
import 'package:sphinx_app/splash_screen/done_screen.dart';
import 'package:sphinx_app/splash_screen/splash_screen.dart';
import 'package:sphinx_app/user_verification/phone_verification/phone_number_screen.dart';
import 'package:sphinx_app/user_verification/true_caller_verification/true_caller_verification.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'splashscreen',
    routes: {
      'splashscreen': (context) => SplashScreen(),
      'done': (context) => DoneScreen(),
      'truecallerverify' : (context) => TrueCallerVerification(),
      'phone': (context) => PhoneNumberScreen(),
      'home': (context) => HomeScreen(),
      'map' : (context) => MapScreen()
    },
  ));
}