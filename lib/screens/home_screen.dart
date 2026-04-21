import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/extention/navigator.dart';
import 'package:zawj_app/screens/artikel_screen.dart';
import 'package:zawj_app/widgets/app_color.dart';
import 'package:zawj_app/widgets/ayat_harian.dart';
import 'package:zawj_app/widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        title: Column(
          children: [
            Row(
              children: [
                Text(
                  'Find My Zawj',
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFE76CA3),
                  ),
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.favorite,
                  color: Color.fromARGB(255, 239, 97, 144),
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.0),
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 211, 208, 208),
                    blurRadius: 15,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRect(
                        child: Image.asset(
                          'assets/images/edukasi.jpg',
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 15,
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: AppColor.pinktua,
                          ),
                          child: Text(
                            "Edukasi Pernikahan",
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  Text(
                    "Membangun Rumah Tangga Sakinah Mawaddah Warrahmah",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColor.hitam,
                    ),
                  ),
                  SizedBox(height: 10),

                  Text(
                    "Pelajari prinsip-prinsip Islam dalam membangun keluarga yang penuh cinta, kasih sayang,",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColor.abutua,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 20),
                  Center(
                    child: customButton(
                      text: "Baca Selengkapnya",
                      width: 350,
                      onPressed: () {
                        context.push(ArtikelScreen());
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(12.0),
                  margin: EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(255, 211, 208, 208),
                        blurRadius: 15,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [ayatHarian()],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
