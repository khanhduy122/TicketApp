import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/models/showtimes.dart';
import 'package:ticket_app/screen/select_movie/select_movie_controller.dart';
import 'package:ticket_app/widgets/item_day_widget.dart';
import 'package:ticket_app/widgets/item_list_showtimes.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class SelectMovieScreen extends GetView<SelectMovieController> {
  const SelectMovieScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: controller.cinema.name),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            _buildSelectDay(),
            SizedBox(
              height: 20.h,
            ),
            Expanded(child: _buildSlectMovie())
          ],
        ),
      )),
    );
  }

  Widget _buildSelectDay() {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.listDateTime.length,
        itemBuilder: (context, index) {
          return Obx(
            () => ItemDayWidget(
              day: controller.listDateTime[index].day,
              isActive: index == controller.currentSelectedDayIndex.value,
              onTap: () => controller.onTapSelectDay(index),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlectMovie() {
    return Obx(
      () => controller.isLoading.value
          ? _buildLoading()
          : controller.listShowtimes.isEmpty
              ? _buildListEmpty()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: ListView.builder(
                      itemCount: controller.listShowtimes.length,
                      itemBuilder: (context, index) {
                        return _buildListTypeTiket(
                          showtimes: controller.listShowtimes[index],
                        );
                      },
                    ))
                  ],
                ),
    );
  }

  Widget _buildLoading() => const Center(
        child: CircularProgressIndicator(
          color: AppColors.buttonColor,
        ),
      );

  Widget _buildListTypeTiket({required Showtimes showtimes}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          showtimes.movie!.name!,
          style: AppStyle.titleStyle,
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageNetworkWidget(
              url: showtimes.movie!.thumbnail!,
              width: 100.w,
              height: 150.h,
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Column(
                children: [
                  BuildListShowtimnes(
                    movieTimes: showtimes.times,
                    title: "Phim 2D Phụ Đề",
                    onTap: (index) => controller.onTapShowtimes(
                      showtimes,
                      index,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }

  Widget _buildListEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(AppAssets.imgEmpty),
        SizedBox(
          height: 20.h,
        ),
        Text(
          "Không phim nào đang chiếu tại thời điểm này",
          style: AppStyle.defaultStyle,
        )
      ],
    );
  }
}
