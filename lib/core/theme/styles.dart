import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mta_app/core/theme/colors.dart';

class AppStyles {
  static BoxDecoration backgroundBox = BoxDecoration(
      color: AppColors.lightDark,
      borderRadius: const BorderRadius.all(Radius.circular(12)));
  static TextStyle textStyle = GoogleFonts.montserrat(color: AppColors.white);
  static InputDecoration inputFieldStyle = InputDecoration(
      focusedBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: AppColors.white)),
      fillColor: Colors.green[600],
      focusColor: Colors.grey[600],
      labelStyle: GoogleFonts.montserrat(color: Colors.white54, fontSize: 16),
      errorStyle: GoogleFonts.montserrat(color: AppColors.red, fontSize: 12));
}
