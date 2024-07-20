import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/dialogs/dialog_completed.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/dialogs/dialog_loading.dart';
import 'package:ticket_app/core/exceptions/exception.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/screen/write_review_screen/write_review_controller.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class WriteReviewScreen extends GetView<WriteReviewController> {
  const WriteReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: controller.ticket.movie!.name!),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              _buildRatingBar(),
              SizedBox(
                height: 20.h,
              ),
              _buildReviewField(),
              SizedBox(
                height: 20.h,
              ),
              _buildButtonSelectImage(),
              SizedBox(
                height: 10.h,
              ),
              _buildImageSelected(),
              SizedBox(
                height: 40.h,
              ),
              Obx(
                () => ButtonWidget(
                  title: "Đánh Giá",
                  height: 50.h,
                  width: 250.w,
                  color: controller.rating.value == 0
                      ? AppColors.darkBackground
                      : AppColors.buttonColor,
                  onPressed: () => controller.addReview(),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildRatingBar() {
    return Column(
      children: [
        Text(
          "Đánh giá của bạn",
          style: AppStyle.defaultStyle.copyWith(fontSize: 14.sp),
        ),
        RatingBar.builder(
          initialRating: 0,
          minRating: 0,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          unratedColor: AppColors.grey,
          onRatingUpdate: (ratingChange) {
            controller.rating.value = ratingChange.toInt();
          },
        ),
      ],
    );
  }

  Widget _buildReviewField() {
    return Container(
      height: 250.h,
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey)),
      child: TextField(
        maxLines: 100,
        onChanged: (value) {
          controller.contentReview = value;
        },
        style: AppStyle.defaultStyle.copyWith(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: "Nhập đánh giá của bạn",
          hintStyle: AppStyle.defaultStyle.copyWith(fontSize: 14.sp),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildButtonSelectImage() {
    return GestureDetector(
      onTap: () => controller.onTapSelectPhoto(),
      child: Container(
          height: 50.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.grey)),
          child: Row(
            children: [
              SizedBox(
                width: 10.h,
              ),
              Icon(
                Icons.add,
                color: AppColors.grey,
                size: 30.w,
              ),
              SizedBox(
                width: 10.h,
              ),
              Text(
                "Thêm ảnh",
                style: AppStyle.defaultStyle.copyWith(fontSize: 14.sp),
              )
            ],
          )),
    );
  }

  Widget _buildImageSelected() {
    return Obx(
      () => SizedBox(
        height: 70.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.imagesSelected.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Stack(
                children: [
                  Container(
                    height: 70.h,
                    width: 70.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: FileImage(controller.imagesSelected[index]),
                            fit: BoxFit.cover)),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        controller.imagesSelected.removeAt(index);
                      },
                      child: Icon(
                        Icons.close,
                        color: AppColors.white,
                        size: 20.w,
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
