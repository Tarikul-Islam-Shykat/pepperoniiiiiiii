import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

Widget tilte_text_heading(String text) {
  return Center(
    child: Transform(
      transform: Matrix4.identity()
        ..rotateZ(-0.04), // Small rotation to make it slightly tilted
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 60),
        decoration: BoxDecoration(
          color: const Color(0xFF0D9DAB), // Teal color
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Transform(
          transform: Matrix4.identity()..rotateZ(0.05),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
