import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zawj_app/firebase_options.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
