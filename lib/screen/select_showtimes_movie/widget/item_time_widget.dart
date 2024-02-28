import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';

class ItemTimeWidget extends StatelessWidget {
  const ItemTimeWidget({super.key, required this.onTap, required this.time, required this.isActive});

  final Function() onTap;
  final String time;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 40.h,
            width: 90.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? AppColors.buttonColor : AppColors.darkBackground,
              borderRadius: BorderRadius.circular(10.r)
            ),
            child: Text(time, style: AppStyle.defaultStyle.copyWith(fontSize: 12.sp),),
          ),
        ),
        SizedBox(width: 10.w,)
      ],
    );
  }
}
