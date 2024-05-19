import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_completed.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/moduels/auth/auth_exception.dart';
import 'package:ticket_app/moduels/review/review_bloc.dart';
import 'package:ticket_app/moduels/review/review_event.dart';
import 'package:ticket_app/moduels/review/review_state.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key, required this.ticket});

  final Ticket ticket;

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int rating = 0;
  String contentReview = "";
  List<File> imagesSelected = [];
  ReviewBloc reviewBloc = ReviewBloc();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: reviewBloc,
      listener: (context, state) {
        if (state is AddReviewState) {
          if (state.isLoading == true) {
            DialogLoading.show(context);
          }
          if (state.isSuccess == true) {
            Navigator.pop(context);
            DialogConpleted.show(
                context: context,
                message: "Cảm ơn bạn đã đánh giá",
                onTap: () {
                  Navigator.of(context).popUntil(
                    (route) => route.settings.name == RouteName.mainScreen,
                  );
                });
          }
          if (state.error != null) {
            Navigator.pop(context);
            if (state.error is TimeOutException) {
              DialogError.show(
                  context: context,
                  message:
                      "Đã có lỗi xẩy ra, vui lòng kiểm tra lại đường truyền");
            } else {
              DialogError.show(
                  context: context,
                  message: "Đã có lỗi xảy ra vui lòng thử lại sao");
            }
          }
        }
      },
      child: Scaffold(
        appBar: appBarWidget(title: widget.ticket.movie!.name!),
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
                ButtonWidget(
                    title: "Đánh Giá",
                    height: 50.h,
                    width: 250.w,
                    color: rating == 0
                        ? AppColors.darkBackground
                        : AppColors.buttonColor,
                    onPressed: () {
                      if (rating != 0) {
                        reviewBloc.add(AddReviewEvent(
                            contentReview: contentReview,
                            rating: rating,
                            images: imagesSelected,
                            ticket: widget.ticket));
                      }
                    })
              ],
            ),
          ),
        )),
      ),
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
            setState(() {
              rating = ratingChange.toInt();
            });
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
          setState(() {
            contentReview = value;
          });
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
      onTap: _onTapSelectPhoto,
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
    return SizedBox(
      height: 70.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagesSelected.length,
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
                          image: FileImage(imagesSelected[index]),
                          fit: BoxFit.cover)),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        imagesSelected.removeAt(index);
                      });
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
    );
  }

  void _onTapSelectPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> image = await picker.pickMultiImage();
      if (image.isNotEmpty) {
        setState(() {
          imagesSelected.addAll(image.map((e) => File(e.path)).toList());
        });
      }
    } catch (e) {
      imagesSelected = [];
    }
  }
}
