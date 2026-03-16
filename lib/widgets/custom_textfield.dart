import 'package:flutter/material.dart';
import 'package:zawj_app/widgets/app_color.dart';

InputDecoration customTextField({
  required String hintText,
  Color? color,
  BorderSide? borderSide,
}) {
  return InputDecoration(
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide:
          borderSide ?? BorderSide(color: color ?? AppColor.borderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide:
          borderSide ?? BorderSide(color: color ?? AppColor.borderColor),
    ),
  );
}
