import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/widgets/button_negative_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class DialogConfirm {
  static Future<bool> show(
      {required BuildContext context,
      required String message,
      String? titlePositive,
      String? titleNegative}) async {
    bool isConfirm = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return SimpleDialog(backgroundColor: Colors.transparent, children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20.h)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
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
                  "Xác Nhận",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ButtonNegativeWidget(
                        title: titleNegative ?? "No",
                        height: 40.h,
                        radius: 10.r,
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      child: ButtonWidget(
                        title: titlePositive ?? "OK",
                        height: 40.h,
                        radius: 10.r,
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]);
      },
    );
    return isConfirm;
  }
}
