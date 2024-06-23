import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/review.dart';

class AllReviewController extends GetxController {
  final movie = Get.arguments['movie'] as Movie;
  final ScrollController listReviewScrollController = ScrollController();
  RxList<Review> reviewsDisplay = <Review>[].obs;
  RxInt currentIndex = 0.obs;
  RxInt currentIndexIndicator = 0.obs;

  @override
  void onInit() {
    reviewsDisplay.assignAll(Get.arguments['reviews']);
    super.onInit();
  }

  void _onTapNextPage() {
    // currentIndexIndicator++;
    // listReviewScrollController.animateTo(0.0,
    //     duration: const Duration(microseconds: 100), curve: Curves.easeInOut);
    // if (allReviewsLoaded.length > (currentIndexIndicator * 10)) {
    //   setState(() {
    //     if ((currentIndexIndicator * 10) + 10 < allReviewsLoaded.length) {
    //       reviewsDisplay = allReviewsLoaded.sublist(
    //           currentIndexIndicator * 10, (currentIndexIndicator * 10) + 10);
    //     } else {
    //       reviewsDisplay = allReviewsLoaded.sublist(currentIndexIndicator * 10);
    //     }
    //   });
    // } else {
    //   reviewBloc.add(
    //       LoadMoreReviewMovieEvent(id: widget.movie.id!, rating: currentIndex));
    // }
  }

  void _onTapPreviousPage() {
    // listReviewScrollController.animateTo(0.0,
    //     duration: const Duration(microseconds: 100), curve: Curves.easeInOut);
    // setState(() {
    //   currentIndexIndicator--;
    //   reviewsDisplay = allReviewsLoaded.sublist(
    //       currentIndexIndicator * 10, (currentIndexIndicator * 10) + 10);
    // });
  }
}
