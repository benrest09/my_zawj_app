import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/widgets/app_color.dart';

Widget kategoriButton({
  required IconData icon,
  required String label,
  required void Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 211, 208, 208),
                blurRadius: 5,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, size: 35, color: AppColor.pinktua),
        ),

        SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColor.hitam,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
