import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/screens/login_screen.dart';
import 'package:zawj_app/screens/register_screen.dart';
import 'package:zawj_app/services/preference_handler.dart';
import 'package:zawj_app/widgets/app_color.dart';
import 'package:zawj_app/widgets/custom_button.dart';
import 'package:zawj_app/widgets/onboarding_indicator.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                FadeInDown(
                  duration: Duration(milliseconds: 800),
                  child: Image.asset(
                    "assets/images/onboarding3.png",
                    width: 300,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
                FadeIn(
                  duration: Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 200),
                  child: Text(
                    "Siap Memulai?",
                    style: GoogleFonts.montaga(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  duration: Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 400),
                  child: Text(
                    "Menuju Pernikahan yang Berkah",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColor.pinkmuda,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FadeInUp(
                  duration: Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 400),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Bergabunglah dengan para Muslim dan Muslimah yang telah menemukan pasangan hidup mereka melalui Find My Zawj",
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: AppColor.abutua,
                      height: 1.7,
                    ),
                  ),
                ),
                SizedBox(height: 10),

                FadeInUp(
                  duration: Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 800),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customButton(
                        text: 'Daftar Sekarang',
                        width: 300,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      RegisterScreen(),
                              transitionsBuilder:
                                  (
                                    context,
                                    animation,
                                    secondaryAnimation,
                                    child,
                                  ) {
                                    const begin = Offset(1.0, 0.0);
                                    const end = Offset.zero;
                                    const curve = Curves.easeInOut;

                                    var tween = Tween(
                                      begin: begin,
                                      end: end,
                                    ).chain(CurveTween(curve: curve));
                                    var offsetAnimation = animation.drive(
                                      tween,
                                    );

                                    return SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    );
                                  },
                              transitionDuration: Duration(milliseconds: 500),
                            ),
                          );
                        },
                        icon: Icons.chevron_right_rounded,
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.abumuda,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () async {
                            await PreferenceHandler.sudahLewatOnboarding();
                            if (!context.mounted) return;
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        LoginScreen(),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      var tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(CurveTween(curve: curve));
                                      var offsetAnimation = animation.drive(
                                        tween,
                                      );

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                                transitionDuration: Duration(milliseconds: 500),
                              ),
                            );
                          },
                          child: Text(
                            "Sudah Punya Akun",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                OnboardingIndicator(currentIndex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
