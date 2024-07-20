import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget(
      {super.key, required this.rating, this.total, this.isCenter});

  final double rating;
  final int? total;
  final bool? isCenter;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isCenter == true ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, index) => const Icon(
            Icons.star,
            color: AppColors.rating,
          ),
          unratedColor: AppColors.white,
          itemCount: 5,
          itemSize: 15.h,
          direction: Axis.horizontal,
        ),
        SizedBox(
          width: 10.w,
        ),
        total != null
            ? Text(
                "(${formatTotal(total!)})",
                style: AppStyle.defaultStyle.copyWith(fontSize: 12),
              )
            : Container()
      ],
    );
  }

  String formatTotal(int total) {
    if (total >= 1000) {
      return "${total ~/ 1000}k${(total % 1000) ~/ 100}";
    } else {
      return total.toString();
    }
  }
}
