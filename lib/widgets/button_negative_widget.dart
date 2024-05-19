import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';

class ButtonNegativeWidget extends StatelessWidget {
  const ButtonNegativeWidget({
    super.key,
    required this.title,
    this.height,
    this.width,
    required this.onPressed,
    this.radius,
  });

  final String title;
  final double? height;
  final double? width;
  final double? radius;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(
              Size(width ?? double.infinity, height ?? 50.h)),
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColors.textColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(radius ?? 20))),
          foregroundColor:
              MaterialStateProperty.all<Color>(AppColors.buttonPressColor),
        ),
        child: Text(
          title,
          style: AppStyle.textButtonStyle,
        ));
  }
}
