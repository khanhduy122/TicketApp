import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class DialogConpleted {
  static Future<void> show(
      {required BuildContext context,
      required String message,
      required Function() onTap}) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(backgroundColor: Colors.transparent, children: [
          Container(
            height: 300.h,
            width: 300.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20.h)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: Image.asset(
                    AppAssets.imgLogo,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Hoàn Thành",
                  style: AppStyle.titleStyle,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  message,
                  style: AppStyle.defaultStyle.copyWith(fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40.h,
                ),
                ButtonWidget(
                    title: "Tiếp Tục",
                    height: 50.h,
                    width: 200.w,
                    onPressed: onTap)
              ],
            ),
          ),
        ]);
      },
    );
  }
}
