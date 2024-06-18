import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';

class ButtonBackWidget extends StatelessWidget {
  const ButtonBackWidget({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: onTap,
      color: AppColors.white,
    );
  }
}
