import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_colors.dart';

class AppStyle {
  static TextStyle get titleStyle {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 24.sp
    );
  }

  static TextStyle get defaultStyle {
    return TextStyle(
      color: AppColors.textColor,
      fontWeight: FontWeight.w300,
      fontSize: 18.sp
    );
  }

  static TextStyle get textButtonStyle {
    return TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 18.sp
    );
  }
}