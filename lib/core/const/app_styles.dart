import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/core/const/app_colors.dart';

class AppStyle {
  static TextStyle get titleStyle {
    return TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.sp);
  }

  static TextStyle get subTitleStyle {
    return TextStyle(
        color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14.sp);
  }

  static TextStyle get defaultStyle {
    return TextStyle(
        color: AppColors.textColor,
        fontWeight: FontWeight.w300,
        fontSize: 14.sp);
  }

  static TextStyle get textButtonStyle {
    return TextStyle(
        color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14.sp);
  }
}
