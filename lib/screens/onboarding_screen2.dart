import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/screens/onboarding_screen3.dart';
import 'package:zawj_app/widgets/app_color.dart';
import 'package:zawj_app/widgets/custom_button.dart';
import 'package:zawj_app/widgets/onboarding_indicator.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
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
                SizedBox(height: 50),
                FadeInDown(
                  duration: Duration(milliseconds: 800),
                  child: Image.asset(
                    "assets/images/onboarding2.png",
                    width: 300,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                ),
                FadeIn(
                  duration: Duration(milliseconds: 800),
                  delay: Duration(milliseconds: 200),
                  child: Text(
                    "Privasi dan Keamanan",
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
                    "Data Anda Terlindungi",
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
                    "Kami menjaga privasi dan keamanan data pribadi Anda dengan standar tertinggi dan proses verifikasi ketat untuk memastikan profil yang autentik",
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      customButton(
                        text: 'Selanjutnya',
                        width: 300,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      OnboardingScreen3(),
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
                    ],
                  ),
                ),
                SizedBox(height: 50),
                OnboardingIndicator(currentIndex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
