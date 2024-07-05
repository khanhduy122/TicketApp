import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/models/showtimes.dart';
import 'package:ticket_app/widgets/item_time_widget.dart';

class BuildListShowtimnes extends StatelessWidget {
  const BuildListShowtimnes(
      {super.key,
      required this.movieTimes,
      required this.title,
      required this.onTap,
      this.crossAxisCount});

  final List<Time> movieTimes;
  final String title;
  final int? crossAxisCount;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyle.defaultStyle,
        ),
        SizedBox(
          height: 10.h,
        ),
        SizedBox(
          height: crossAxisCount == null
              ? (movieTimes.length % 2 == 0
                  ? (movieTimes.length / 2) * 50.h
                  : (movieTimes.length / 2 + 1) * 50.h)
              : ((movieTimes.length % 3 == 0
                  ? (movieTimes.length / 3) * 50.h
                  : (movieTimes.length / 3 + 1) * 50.h)),
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount ?? 2,
                mainAxisSpacing: 10.h,
                mainAxisExtent: 40.h),
            itemCount: movieTimes.length,
            itemBuilder: (context, index) {
              return ItemTimeWidget(
                time: movieTimes[index].time,
                isActive: false,
                onTap: () => onTap(index),
              );
            },
          ),
        ),
      ],
    );
  }
}
