import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/widgets/app_color.dart';

Widget ayatHarian() {
  final List<Map<String, String>> ayatList = [
    {
      'arab':
          'وَمِنْ آيَاتِهِ أَنْ خَلَقَ لَكُم مِّنْ أَنفُسِكُمْ أَزْوَاجًا لِّتَسْكُنُوا إِلَيْهَا',
      'terjemah':
          '"Dan di antara tanda-tanda kekuasaan-Nya ialah Dia menciptakan untukmu isteri-isteri dari jenismu sendiri, supaya kamu cenderung dan merasa tenteram kepadanya"',
      'ayat': '(QS. Ar-Rum: 21)',
    },
    {
      'arab':
          'رَبَّنَا هَبْ لَنَا مِنْ أَزْوَاجِنَا وَذُرِّيَّاتِنَا قُرَّةَ أَعْيُنٍ',
      'terjemah':
          '"Ya Tuhan kami, anugerahkanlah kepada kami pasangan dan keturunan yang menyenangkan hati"',
      'ayat': '(QS. Al-Furqan: 74)',
    },
    {
      'arab':
          'وَأَنكِحُوا الْأَيَامَىٰ مِنكُمْ وَالصَّالِحِينَ مِنْ عِبَادِكُمْ وَإِمَائِكُمْ',
      'terjemah':
          '"Dan kawinkanlah orang-orang yang sendirian di antara kamu, dan orang-orang yang layak dari hamba-hambamu"',
      'ayat': '(QS. An-Nur: 32)',
    },
    {
      'arab':
          'يَا أَيُّهَا النَّاسُ اتَّقُوا رَبَّكُمُ الَّذِي خَلَقَكُم مِّن نَّفْسٍ وَاحِدَةٍ وَخَلَقَ مِنْهَا زَوْجَهَا',
      'terjemah':
          '"Hai manusia, bertakwalah kepada Tuhanmu yang telah menciptakan kamu dari diri yang satu, dan daripadanya Allah menciptakan isterinya"',
      'ayat': '(QS. An-Nisa: 1)',
    },
    {
      'arab':
          'وَمِن كُلِّ شَيْءٍ خَلَقْنَا زَوْجَيْنِ لَعَلَّكُمْ تَذَكَّرُونَ',
      'terjemah':
          '"Dan segala sesuatu Kami ciptakan berpasang-pasangan supaya kamu mengingat kebesaran Allah"',
      'ayat': '(QS. Adh-Dhariyat: 49)',
    },
    {
      'arab': 'يَا أَيُّهَا النَّاسُ إِنَّا خَلَقْنَاكُم مِّن ذَكَرٍ وَأُنثَىٰ',
      'terjemah':
          '"Hai manusia, sesungguhnya Kami menciptakan kamu dari seorang laki-laki dan seorang perempuan"',
      'ayat': '(QS. Al-Hujurat: 13)',
    },
  ];

  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColor.pinkmuda, width: 1),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColor.pinktua,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.school_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Ayat Harian',
              style: GoogleFonts.montaga(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColor.hitam,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),

        SizedBox(
          height: 270,
          child: PageView.builder(
            itemCount: ayatList.length,
            itemBuilder: (context, index) {
              final doa = ayatList[index];
              return ayatCard(
                arab: doa['arab']!,
                terjemah: doa['terjemah']!,
                ayat: doa['ayat']!,
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            ayatList.length,
            (index) => Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColor.pinktua,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget ayatCard({
  required String arab,
  required String terjemah,
  required String ayat,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          arab,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Amiri',
            height: 2.2,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        Text(
          terjemah,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
            height: 1.6,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 8),

        Text(
          ayat,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: AppColor.pinktua,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
