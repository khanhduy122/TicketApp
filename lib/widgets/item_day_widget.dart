import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';

class ItemDayWidget extends StatelessWidget {
  const ItemDayWidget(
      {super.key,
      required this.onTap,
      required this.day,
      required this.isActive});

  final Function() onTap;
  final int day;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 60.h,
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color:
                    isActive ? AppColors.buttonColor : AppColors.darkBackground,
                borderRadius: BorderRadius.circular(10.r)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Ngày",
                  style: AppStyle.defaultStyle
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 12.sp),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  day.toString(),
                  style:
                      AppStyle.titleStyle.copyWith(fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: 10.w,
        )
      ],
    );
  }
}
