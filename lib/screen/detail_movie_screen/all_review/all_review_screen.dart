import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/screen/detail_movie_screen/all_review/all_review_controllerr.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_outline_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/rating_widget.dart';

class AllReviewScreen extends GetView<AllReviewController> {
  const AllReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: "Đánh Giá"),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.h,
            ),
            _buildTabBar(),
            SizedBox(
              height: 20.h,
            ),
            const Divider(
              color: AppColors.grey,
            ),
            SizedBox(
              height: 20.h,
            ),
            _buildTabView(),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (controller.currentIndex.value != 0) {
                controller.currentIndex.value = 0;
                controller.currentIndexIndicator.value = 0;
              }
            },
            child: Row(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                decoration: BoxDecoration(
                    color: controller.currentIndex.value == 0
                        ? AppColors.buttonColor
                        : AppColors.darkBackground,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Row(
                  children: [
                    Text(
                      "Tất cả",
                      style: AppStyle.subTitleStyle,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "(${controller.movie.totalReview})",
                      style: AppStyle.defaultStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12.w,
              )
            ]),
          ),
          GestureDetector(
            onTap: () {
              if (controller.currentIndex.value != 1) {
                controller.currentIndex.value = 1;
                controller.currentIndexIndicator.value = 1;
              }
            },
            child: Row(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                decoration: BoxDecoration(
                    color: controller.currentIndex.value == 1
                        ? AppColors.buttonColor
                        : AppColors.darkBackground,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Row(
                  children: [
                    Text(
                      "Có Hình Ảnh",
                      style: AppStyle.subTitleStyle,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "(${controller.movie.totalRatingWithPicture})",
                      style: AppStyle.defaultStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12.w,
              )
            ]),
          ),
          _itemTabBar(
            title: "5",
            isSelected: controller.currentIndex.value == 2,
            total: controller.movie.totalFiveRating ?? 0,
            onTap: () {
              if (controller.currentIndex.value != 2) {
                controller.currentIndex.value = 2;
                controller.currentIndexIndicator.value = 2;
              }
            },
          ),
          _itemTabBar(
            title: "4",
            isSelected: controller.currentIndex.value == 3,
            total: controller.movie.totalFourRating ?? 0,
            onTap: () {
              if (controller.currentIndex.value != 3) {
                controller.currentIndex.value = 3;
                controller.currentIndexIndicator.value = 3;
              }
            },
          ),
          _itemTabBar(
            title: "3",
            isSelected: controller.currentIndex.value == 4,
            total: controller.movie.totalThreeRating ?? 0,
            onTap: () {
              if (controller.currentIndex.value != 4) {
                controller.currentIndex.value = 4;
                controller.currentIndexIndicator.value = 4;
              }
            },
          ),
          _itemTabBar(
            title: "2",
            isSelected: controller.currentIndex.value == 5,
            total: controller.movie.totalTwoRating ?? 0,
            onTap: () {
              if (controller.currentIndex.value != 5) {
                controller.currentIndex.value = 5;
                controller.currentIndexIndicator.value = 5;
              }
            },
          ),
          _itemTabBar(
            title: "1",
            isSelected: controller.currentIndex.value == 6,
            total: controller.movie.totalOneRating ?? 0,
            onTap: () {
              if (controller.currentIndex.value != 6) {
                controller.currentIndex.value = 6;
                controller.currentIndexIndicator.value = 6;
              }
            },
          )
        ],
      ),
    );
  }

  Widget _itemTabBar(
      {required String title,
      required bool isSelected,
      required int total,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.buttonColor
                    : AppColors.darkBackground,
                borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              children: [
                Text(
                  title,
                  style: AppStyle.subTitleStyle,
                ),
                Icon(
                  Icons.star,
                  color: AppColors.rating,
                  size: 15.h,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "($total)",
                  style: AppStyle.defaultStyle,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 12.w,
          )
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return Expanded(
      child: ListView.builder(
        controller: controller.listReviewScrollController,
        itemCount: controller.reviewsDisplay.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildItemReview(review: controller.reviewsDisplay[index]),
              index == controller.reviewsDisplay.length - 1
                  ? SizedBox(
                      height: 20.h,
                    )
                  : Container(),
              index == controller.reviewsDisplay.length - 1
                  ? _buildIndicator()
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemReview({required Review review}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            review.userPhoto == null
                ? SizedBox(
                    height: 40.h,
                    width: 40.w,
                    child: Image.asset(AppAssets.imgAvatarDefault))
                : ImageNetworkWidget(
                    url: review.userPhoto!,
                    height: 40.h,
                    width: 40.w,
                    borderRadius: 30.r,
                  ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName,
                    style: AppStyle.subTitleStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  RatingWidget(rating: review.rating),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    review.content,
                    style: AppStyle.defaultStyle,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  (review.images != null)
                      ? Wrap(
                          spacing: 10.w,
                          runSpacing: 10.h,
                          children: [
                            for (var image in review.images!)
                              GestureDetector(
                                onTap: () {},
                                child: ImageNetworkWidget(
                                  url: image,
                                  height: 80.h,
                                  width: 80.w,
                                ),
                              )
                          ],
                        )
                      : Container()
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        const Divider(
          color: AppColors.grey,
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget _buildIndicator() {
    int totaIndex = 0;

    switch (controller.currentIndex.value) {
      case 0:
        if (controller.movie.totalReview! ~/ 10 == 0 &&
            controller.movie.totalReview! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = controller.movie.totalReview! ~/ 10;
        if (controller.movie.totalReview! % 10 != 0) {
          totaIndex + 1;
        }
        break;
      case 1:
        if (controller.movie.totalRatingWithPicture! ~/ 10 == 0 &&
            controller.movie.totalRatingWithPicture! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = controller.movie.totalRatingWithPicture! ~/ 10;
        if (controller.movie.totalRatingWithPicture! % 10 != 0) {
          totaIndex += 1;
        }
        break;
      case 2:
        if (controller.movie.totalFiveRating! ~/ 10 == 0 &&
            controller.movie.totalFiveRating! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = controller.movie.totalFiveRating! ~/ 10;
        if (controller.movie.totalFiveRating! % 10 != 0) {
          totaIndex += 1;
        }
        break;
      case 3:
        if (controller.movie.totalFourRating! ~/ 10 == 0 &&
            controller.movie.totalFourRating! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = controller.movie.totalFourRating! ~/ 10;
        if (controller.movie.totalFourRating! % 10 != 0) {
          totaIndex += 1;
        }
        break;
      case 4:
        if (controller.movie.totalThreeRating! ~/ 10 == 0 &&
            controller.movie.totalThreeRating! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = controller.movie.totalThreeRating! ~/ 10;

        if (controller.movie.totalThreeRating! % 10 != 0) {
          totaIndex += 1;
        }
        break;
      case 5:
        if (controller.movie.totalTwoRating! ~/ 10 == 0 &&
            controller.movie.totalTwoRating! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = controller.movie.totalTwoRating! ~/ 10;
        if (controller.movie.totalTwoRating! % 10 != 0) {
          totaIndex += 1;
        }
        break;
      case 6:
        if (controller.movie.totalOneRating! ~/ 10 == 0 &&
            controller.movie.totalOneRating! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = controller.movie.totalOneRating! ~/ 10;
        if (controller.movie.totalOneRating! % 10 != 0) {
          totaIndex += 1;
        }
        break;
    }

    return Row(
      mainAxisAlignment: controller.currentIndexIndicator.value == 0 ||
              controller.currentIndexIndicator.value + 1 == totaIndex
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceAround,
      children: [
        controller.currentIndexIndicator.value != 0
            ? ButtonOutlineWidget(
                title: "Trước",
                height: 50.h,
                width: 100.w,
                onPressed: () {},
              )
            : Container(),
        controller.currentIndexIndicator.value + 1 != totaIndex
            ? ButtonWidget(
                title: "Tiếp Theo",
                height: 50.h,
                width: 100.w,
                onPressed: () {},
              )
            : Container()
      ],
    );
  }
}
