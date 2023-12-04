import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key, required this.title, required this.height, required this.width, required this.onPressed});

  final String title;
  final Function() onPressed;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, 
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(Size(width, height)),
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.buttonColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
        ),
        foregroundColor: MaterialStateProperty.all<Color>(AppColors.buttonPressColor),
      ),
      child: Text(
        title,
        style: AppStyle.textButtonStyle.copyWith(fontSize: height/3.5.sp),
      )
    );
  }
}