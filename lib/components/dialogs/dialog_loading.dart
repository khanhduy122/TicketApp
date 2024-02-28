import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:lottie/lottie.dart';

class DialogLoading {
  static void show(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context, 
      builder: (context) {
        return Center(
          child: Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.h),
              color: AppColors.background
            ),
            child: Lottie.asset(AppAssets.jsonLoading),
          ),
        );
      },
    );
  }
}