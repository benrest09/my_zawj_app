import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/widgets/app_color.dart';

class ArtikelScreen extends StatelessWidget {
  const ArtikelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, AppColor.pinkmuda.withOpacity(0.3)],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Find My Zawj',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.pinktua,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.favorite, color: AppColor.pinktua, size: 20),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/edukasi.jpg',
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColor.pinktua,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Edukasi Pernikahan',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Membangun Rumah Tangga Sakinah Mawaddah Warrahmah',
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '5 menit baca',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        '12 Maret 2026',
                        style: GoogleFonts.montserrat(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.pinktua.withOpacity(0.9),
                          AppColor.pinktua,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.pinktua.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.menu_book,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Ayat Pilihan',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'وَمِنْ آيَاتِهِ أَنْ خَلَقَ لَكُم مِّنْ أَنفُسِكُمْ أَزْوَاجًا لِّتَسْكُنُوا إِلَيْهَا وَجَعَلَ بَيْنَكُم مَّوَدَّةً وَرَحْمَةً',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.amiri(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 2.2,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Dan di antara tanda-tanda kekuasaan-Nya ialah Dia menciptakan untukmu pasangan hidup dari jenismu sendiri, supaya kamu cenderung dan merasa tenteram kepadanya, dan dijadikan-Nya di antaramu rasa kasih dan sayang.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.white.withOpacity(0.95),
                              height: 1.6,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'QS. Ar-Rum: 21',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Pendahuluan',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.pinktua,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Pernikahan dalam Islam bukan sekadar ikatan duniawi, melainkan sebuah ibadah dan perjanjian yang agung (mitsaqan ghalizan). Melalui pernikahan, Allah SWT menjanjikan ketenangan jiwa, cinta kasih, dan rahmat yang melimpah bagi pasangan yang menjalaninya dengan benar.',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      height: 1.8,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '3 Pilar Rumah Tangga Sakinah',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.pinktua,
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildPrincipleCard(
                    icon: Icons.home,
                    title: 'Sakinah (Ketenteraman)',
                    description:
                        'Ketenteraman hati yang dirasakan ketika bersama pasangan. Sakinah tercapai ketika kedua belah pihak saling menerima, menghargai, dan menciptakan suasana rumah yang damai dari konflik yang tidak perlu.',
                    tips: [
                      'Komunikasikan perasaan dengan lembut',
                      'Jadikan rumah sebagai tempat yang nyaman',
                      'Hindari membawa masalah luar ke dalam rumah',
                    ],
                  ),
                  _buildPrincipleCard(
                    icon: Icons.favorite,
                    title: 'Mawaddah (Cinta Kasih)',
                    description:
                        'Cinta yang tulus dan kasih sayang yang terus tumbuh. Mawaddah adalah fondasi emosional yang membuat pasangan tetap saling mencintai meski menghadapi ujian.',
                    tips: [
                      'Ungkapkan apresiasi secara rutin',
                      'Berikan kejutan kecil yang bermakna',
                      'Jaga keintiman dengan cara yang halal',
                    ],
                  ),
                  _buildPrincipleCard(
                    icon: Icons.volunteer_activism,
                    title: 'Warahmah (Rahmat & Kasih Sayang)',
                    description:
                        'Rahmat Allah yang tercurah melalui sikap saling mengasihi, memaafkan, dan merawat satu sama lain. Warahmah adalah buah dari ketaatan bersama kepada Allah.',
                    tips: [
                      'Saling mendoakan dalam kebaikan',
                      'Maafkan kesalahan dengan ikhlas',
                      'Bersabar menghadapi kekurangan pasangan',
                    ],
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColor.pinkmuda.withOpacity(0.3),
                          Colors.white,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColor.pinktua.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lightbulb,
                              color: AppColor.pinktua,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Tips Praktis Membangun\n'
                              'Keluarga Islami',
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.pinktua,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildTipItem('1', 'Sholat Berjamaah'),
                        _buildTipItem('2', 'Musyawarah dalam Keputusan'),
                        _buildTipItem('3', 'Menjaga Pandangan & Kehormatan'),
                        _buildTipItem('4', 'Bersedekah Bersama'),
                        _buildTipItem('5', 'Mencari Ilmu Agama Bersama'),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColor.pinktua.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColor.pinktua.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.handshake,
                              color: AppColor.pinktua,
                              size: 24,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Doa untuk Pasangan',
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColor.pinktua,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ وَاجْعَلْنَا لِلْمُتَّقِينَ إِمَامًا',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.amiri(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            height: 2,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          '"Ya Tuhan kami, anugerahkanlah kepada kami pasangan kami dan keturunan kami sebagai penyenang hati, dan jadikanlah kami pemimpin bagi orang-orang yang bertakwa."',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'QS. Al-Furqan: 74',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColor.pinktua,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Penutup',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColor.pinktua,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Membangun rumah tangga sakinah mawaddah warahmah adalah perjalanan seumur hidup yang membutuhkan komitmen, kesabaran, dan keikhlasan. Dengan menjadikan Allah sebagai pusat dari setiap langkah, insyaAllah keluarga yang dibangun akan menjadi sumber keberkahan dunia dan akhirat.',
                    style: GoogleFonts.montserrat(
                      fontSize: 15,
                      height: 1.8,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrincipleCard({
    required IconData icon,
    required String title,
    required String description,
    required List<String> tips,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColor.roseBeige,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppColor.pinktua, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              description,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                height: 1.7,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 12),
            ...tips.map(
              (tip) => Padding(
                padding: EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.check_circle, size: 16, color: AppColor.pinktua),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        tip,
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String number, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColor.pinktua,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
