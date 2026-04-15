import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/screens/login_screen.dart';
import 'package:zawj_app/screens/navbar.dart';
import 'package:zawj_app/screens/onboarding_screen1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = FirebaseAuth.instance.currentUser;

    // ambil onboarding dari local
    final prefs = await SharedPreferences.getInstance();
    final sudahOnboarding = prefs.getBool('onboarding') ?? false;

    if (!mounted) return;

    if (!sudahOnboarding) {
      context.pushReplacement(const OnboardingScreen1());
    } else if (user != null) {
      context.pushReplacement(const Navbar());
    } else {
      context.pushReplacement(const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 150,
          height: 150,
          child: Image.asset("assets/icons/zawj.png", fit: BoxFit.contain),
        ),
      ),
    );
  }
}
