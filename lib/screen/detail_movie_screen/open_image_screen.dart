import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/rating_widget.dart';

class OpenImageScree extends StatefulWidget {
  const OpenImageScree({super.key, required this.review, required this.index});

  final Review review;
  final int index;

  @override
  State<OpenImageScree> createState() => _OpenImageScreeState();
}

class _OpenImageScreeState extends State<OpenImageScree> {
  late final pageContronller;

  @override
  void initState() {
    pageContronller = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
          child: SizedBox.expand(
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildPageView(),
            ),
            _buildUser(),
            Positioned(bottom: 0, child: _buildContentReview())
          ],
        ),
      )),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: pageContronller,
      itemCount: widget.review.images!.length,
      itemBuilder: (context, index) {
        return ImageNetworkWidget(
          url: widget.review.images![index],
          boxFit: BoxFit.contain,
        );
      },
    );
  }

  Widget _buildUser() {
    return Container(
      color: AppColors.black.withOpacity(0.7),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          children: [
            const BackButton(),
            SizedBox(
              width: 20.w,
            ),
            SizedBox(
              height: 50.h,
              width: 50.h,
              child: ImageNetworkWidget(
                url: widget.review.userPhoto!,
                borderRadius: 25.h,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              widget.review.userName,
              style: AppStyle.defaultStyle,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContentReview() {
    return Container(
      width: 1.sw,
      color: AppColors.black.withOpacity(0.7),
      padding: EdgeInsets.all(20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          RatingWidget(rating: widget.review.rating),
          SizedBox(
            height: 10.h,
          ),
          Text(
            widget.review.content,
            style: AppStyle.defaultStyle,
          )
        ],
      ),
    );
  }
}
