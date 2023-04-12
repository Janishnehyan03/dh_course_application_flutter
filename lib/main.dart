import 'package:dh_course_application/screens/HomeScreen.dart';
import 'package:dh_course_application/screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'Course App',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      // home: HomeScreen(),
    );
  }
}
