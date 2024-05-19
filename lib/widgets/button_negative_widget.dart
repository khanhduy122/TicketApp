import 'package:flutter/material.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';

class ButtonNegativeWidget extends StatelessWidget {
  const ButtonNegativeWidget(
      {super.key,
      required this.title,
      required this.height,
      required this.width,
      required this.onPressed});

  final String title;
  final double height;
  final double width;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          fixedSize: MaterialStateProperty.all<Size>(Size(width, height)),
          backgroundColor:
              MaterialStateProperty.all<Color>(AppColors.textColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          foregroundColor:
              MaterialStateProperty.all<Color>(AppColors.buttonPressColor),
        ),
        child: Text(
          title,
          style: AppStyle.textButtonStyle,
        ));
  }
}
