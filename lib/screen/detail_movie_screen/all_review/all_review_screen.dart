import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/screen/detail_movie_screen/all_review/all_review_controllerr.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
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
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            GestureDetector(
              onTap: () => controller.onTabTabbar(0),
              child: Row(children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  decoration: BoxDecoration(
                      color: controller.currentIndex.value == 0
                          ? AppColors.buttonColor
                          : AppColors.darkBackground,
                      borderRadius: BorderRadius.circular(10.r)),
                  child: Text(
                    "Tất cả",
                    style: AppStyle.subTitleStyle,
                  ),
                ),
                SizedBox(
                  width: 12.w,
                )
              ]),
            ),
            GestureDetector(
              onTap: () => controller.onTabTabbar(1),
              child: Row(children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
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
              onTap: () => controller.onTabTabbar(2),
            ),
            _itemTabBar(
              title: "4",
              isSelected: controller.currentIndex.value == 3,
              onTap: () => controller.onTabTabbar(3),
            ),
            _itemTabBar(
              title: "3",
              isSelected: controller.currentIndex.value == 4,
              onTap: () => controller.onTabTabbar(4),
            ),
            _itemTabBar(
              title: "2",
              isSelected: controller.currentIndex.value == 5,
              onTap: () => controller.onTabTabbar(5),
            ),
            _itemTabBar(
              title: "1",
              isSelected: controller.currentIndex.value == 6,
              onTap: () => controller.onTabTabbar(6),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemTabBar({
    required String title,
    required bool isSelected,
    required Function() onTap,
  }) {
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
    return Obx(
      () => controller.isLoading.value
          ? const Expanded(
              child: Center(
              child: CircularProgressIndicator(
                color: AppColors.buttonColor,
              ),
            ))
          : Expanded(
              child: ScrollablePositionedList.builder(
                itemScrollController: controller.itemScrollController,
                itemPositionsListener: controller.itemPositionsListener,
                itemCount: controller.reviewsDisplay.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      _buildItemReview(
                          review: controller.reviewsDisplay[index]),
                      index == controller.reviewsDisplay.length - 1
                          ? SizedBox(
                              height: 20.h,
                            )
                          : Container(),
                      index == controller.reviewsDisplay.length - 1 &&
                              controller.isLoadingMore.value
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 10.h,
                                  width: 1.sw,
                                ),
                                const CircularProgressIndicator(
                                  color: AppColors.buttonColor,
                                )
                              ],
                            )
                          : Container(),
                    ],
                  );
                },
              ),
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
                                onTap: () {
                                  Get.toNamed(
                                    RouteName.openImageReview,
                                    arguments: {
                                      'images': review.images,
                                      'index': review.images!.indexOf(image),
                                    },
                                  );
                                },
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
}
