import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/screens/login_screen.dart';
import 'package:zawj_app/screens/register_screen.dart';
import 'package:zawj_app/services/preference_handler.dart';
import 'package:zawj_app/widgets/app_color.dart';
import 'package:zawj_app/widgets/custom_button.dart';
import 'package:zawj_app/widgets/onboarding_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> data = [
    {
      "image": "assets/images/onboarding1.png",
      "title": "Cari Pasangan Halal",
      "subtitle": "Dengan Cara yang Diridhai Allah",
      "desc":
          "Temukan pasangan hidup yang sejalan\n"
          "dengan nilai-nilai islam dan tujuan\n"
          "pernikanan yang sakinah mawaddah,\n"
          "warohmah",
    },
    {
      "image": "assets/images/onboarding2.png",
      "title": "Privasi dan Keamanan",
      "subtitle": "Data Anda Terlindungi",
      "desc":
          "Kami menjaga privasi dan keamanan data pribadi Anda dengan standar tertinggi dan proses verifikasi ketat",
    },
    {
      "image": "assets/images/onboarding3.png",
      "title": "Siap Memulai?",
      "subtitle": "Menuju Pernikahan yang Berkah",
      "desc":
          "Bergabunglah dengan para Muslim dan Muslimah yang telah menemukan pasangan hidup mereka",
    },
  ];

  void nextPage() {
    if (currentIndex < data.length - 1) {
      _controller.nextPage(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding();
    }
  }

  void finishOnboarding() async {
    await PreferenceHandler.setOnboardingDone();
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final item = data[index];

                  return SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          SizedBox(height: 50),

                          FadeInDown(
                            child: Image.asset(
                              item["image"],
                              width: 300,
                              height: 350,
                            ),
                          ),

                          FadeIn(
                            child: Text(
                              item["title"],
                              style: GoogleFonts.montaga(fontSize: 30),
                            ),
                          ),

                          SizedBox(height: 10),

                          FadeInUp(
                            child: Text(
                              item["subtitle"],
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: AppColor.pinkmuda,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          SizedBox(height: 10),

                          FadeInUp(
                            child: Text(
                              item["desc"],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                color: AppColor.abutua,
                                height: 1.7,
                              ),
                            ),
                          ),

                          SizedBox(height: 30),

                          if (index == data.length - 1) ...[
                            customButton(
                              text: 'Daftar Sekarang',
                              width: 300,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RegisterScreen(),
                                  ),
                                );
                              },
                              icon: Icons.chevron_right_rounded,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: finishOnboarding,
                              child: Text("Sudah Punya Akun"),
                            ),
                          ] else ...[
                            customButton(
                              text: 'Selanjutnya',
                              width: 300,
                              onPressed: nextPage,
                              icon: Icons.chevron_right_rounded,
                            ),
                          ],

                          SizedBox(height: 50),

                          OnboardingIndicator(currentIndex: currentIndex),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
