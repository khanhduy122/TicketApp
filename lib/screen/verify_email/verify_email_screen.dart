import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/screen/verify_email/verify_email_controller.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class VerifyEmailScreen extends GetView<VerifyEmailController> {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        controller.onWillPop();
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250.h,
                  width: 200.w,
                  child: Image.asset(
                    AppAssets.imgVerifyCode,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  "Xác Nhận",
                  style: AppStyle.titleStyle,
                ),
                SizedBox(
                  height: 20.h,
                ),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        text: "Chúng tôi đã gửi email đến ",
                        style: AppStyle.defaultStyle,
                        children: [
                          TextSpan(
                              text: controller.email,
                              style: AppStyle.defaultStyle
                                  .copyWith(color: AppColors.buttonColor)),
                          TextSpan(
                              text:
                                  " kèm theo liên kết để truy cập lại vào tài khoản của bạn.",
                              style: AppStyle.defaultStyle),
                        ])),
                SizedBox(
                  height: 20.h,
                ),
                ButtonWidget(
                  title: "Hủy",
                  height: 50.h,
                  width: 250.w,
                  onPressed: () async => await controller.onWillPop(),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}
