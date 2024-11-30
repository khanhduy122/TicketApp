import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class OpenImageReviewScreen extends StatefulWidget {
  const OpenImageReviewScreen({
    super.key,
    required this.images,
    required this.index,
  });

  final List<String> images;
  final int index;

  @override
  State<OpenImageReviewScreen> createState() => _OpenImageScreenState();
}

class _OpenImageScreenState extends State<OpenImageReviewScreen> {
  late final PageController pageController;
  @override
  void initState() {
    pageController = PageController(initialPage: widget.index);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Positioned(
            top: 40.h,
            left: 30.h,
            child: GestureDetector(
              onTap: () => Get.back(),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.white,
                size: 25.h,
              ),
            ),
          ),
          Positioned.fill(
            child: PageView.builder(
              controller: pageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return ImageNetworkWidget(url: widget.images[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
