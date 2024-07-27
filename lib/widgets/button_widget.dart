import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      required this.title,
      this.height,
      this.width,
      required this.onPressed,
      this.color,
      this.radius});

  final String title;
  final Function() onPressed;
  final Color? color;
  final double? height;
  final double? width;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          fixedSize: WidgetStateProperty.all<Size>(
              Size(width ?? 1.sw, height ?? 50.h)),
          backgroundColor:
              WidgetStateProperty.all<Color>(color ?? AppColors.buttonColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? 20.r))),
          foregroundColor:
              WidgetStateProperty.all<Color>(AppColors.buttonPressColor),
        ),
        child: Text(
          title,
          style: AppStyle.textButtonStyle.copyWith(fontSize: 12.sp),
        ));
  }
}
