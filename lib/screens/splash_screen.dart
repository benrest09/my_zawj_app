import 'package:flutter/material.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/screens/login_screen.dart';
import 'package:zawj_app/screens/navbar.dart';
import 'package:zawj_app/screens/onboarding_screen1.dart';
import 'package:zawj_app/services/preference_handler.dart';

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

    final sudahLogin = await PreferenceHandler.sudahLogin();
    final sudahOnboarding = await PreferenceHandler.sudahLewatOnboarding();

    if (!mounted) return;

    if (sudahLogin) {
      context.pushReplacement(const Navbar());
    } else if (!sudahOnboarding) {
      context.pushReplacement(const OnboardingScreen1());
    } else {
      context.pushReplacement(const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          child: Image.asset("assets/icons/zawj.png", fit: BoxFit.contain),
        ),
      ),
    );
  }
}
