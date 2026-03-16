import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(FindMyZawjApp());
}

class FindMyZawjApp extends StatefulWidget {
  const FindMyZawjApp({super.key});

  @override
  State<FindMyZawjApp> createState() => _FindMyZawjAppState();
}

class _FindMyZawjAppState extends State<FindMyZawjApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Find My Zawj',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
