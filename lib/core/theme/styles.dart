import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mta_app/core/theme/colors.dart';

class AppStyles {
  static BoxDecoration backgroundBox = BoxDecoration(
      color: AppColors.lightDark,
      borderRadius: const BorderRadius.all(Radius.circular(12)));
  static TextStyle textStyle = GoogleFonts.montserrat(color: AppColors.white);
  static InputDecoration inputFieldStyle = InputDecoration(
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.white),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accentViolet),
          borderRadius: const BorderRadius.all(Radius.circular(12))),
      labelStyle: GoogleFonts.montserrat(color: Colors.white38, fontSize: 16),
      errorStyle:
          GoogleFonts.montserrat(color: Colors.redAccent, fontSize: 12));
}
