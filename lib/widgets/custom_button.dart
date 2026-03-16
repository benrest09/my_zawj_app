import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zawj_app/widgets/app_color.dart';

Widget customButton({
  required String text,
  required void Function()? onPressed,
  Color? backgroundColor,
  Color? textColor,
  IconData? icon,
  double? height,
  double? width,
  double? borderRadius,
}) {
  return SizedBox(
    width: width,
    height: height ?? 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColor.pinktua,
        foregroundColor: textColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 24),
        ),
        elevation: 0,
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 8),
                Text(
                  text,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor ?? Colors.white,
                  ),
                ),
                Icon(icon, size: 25),
              ],
            )
          : Text(
              text,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor ?? Colors.white,
              ),
            ),
    ),
  );
}
