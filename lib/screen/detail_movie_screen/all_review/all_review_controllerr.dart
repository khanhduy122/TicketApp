import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ticket_app/components/api/api_common.dart';
import 'package:ticket_app/components/api/api_const.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/const/net_work_info.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/review.dart';

class AllReviewController extends GetxController {
  final movie = Get.arguments['movie'] as Movie;
  final ScrollController listReviewScrollController = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  RxList<Review> reviewsDisplay = <Review>[].obs;
  RxInt currentIndex = 0.obs;
  int totalPage = 0;
  int currentPage = 1;
  RxBool isLoadingMore = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    reviewsDisplay.assignAll(Get.arguments['reviews']);
    totalPage = movie.totalReview! ~/ 10;
    if (totalPage == 0 || totalPage * 10 < movie.totalReview!) {
      totalPage++;
    }
    listenerScrollMessages();
    super.onInit();
  }

  Future<void> listenerScrollMessages() async {
    itemPositionsListener.itemPositions.addListener(() async {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        if (positions.last.index >= 5 * currentPage &&
            !isLoadingMore.value &&
            currentPage < totalPage) {
          isLoadingMore.value = true;
          await loadMoreReview();
          debugLog('loadmore');
        }
      }
    });
  }

  Future<bool> getInitReview(int index) async {
    isLoading.value = true;
    final param = {
      'page': 1,
      'index': index,
      'movieId': movie.id,
    };

    debugLog(currentIndex.value.toString());

    final response = await ApiCommon.get(
      url: ApiConst.allReview,
      queryParameters: param,
    );

    if (response.data != null) {
      if (response.data.isEmpty) {
        isLoading.value = false;
        reviewsDisplay.value = [];
        return true;
      }
      debugLog(response.data.toString());

      List<Review> listReviewResponse = [];

      for (var element in response.data) {
        listReviewResponse.add(Review.fromJson(element));
      }

      reviewsDisplay.assignAll(listReviewResponse);

      isLoading.value = false;
      return true;
    } else {
      isLoading.value = false;
      DialogError.show(
        context: Get.context!,
        message: response.error!.message,
      );
      return false;
    }
  }

  Future<void> loadMoreReview() async {
    final param = {
      'page': currentPage + 1,
      'index': currentIndex.value,
      'movieId': movie.id,
    };

    final response = await ApiCommon.get(
      url: ApiConst.allReview,
      queryParameters: param,
    );

    if (response.data != null) {
      if (response.data.isEmpty) {
        return;
      }

      List<Review> listReviewResponse = [];

      for (var element in response.data) {
        listReviewResponse.add(Review.fromJson(element));
      }

      if (reviewsDisplay.isEmpty) {
        reviewsDisplay.assignAll(listReviewResponse);
      } else {
        reviewsDisplay.insertAll(reviewsDisplay.length, listReviewResponse);
      }
      currentPage++;
      isLoadingMore.value = false;
    } else {
      isLoadingMore.value = false;
    }
  }

  Future<void> onTabTabbar(int index) async {
    final result = await getInitReview(index);
    if (!result) return;
    isLoadingMore.value = false;
    currentPage = 1;
    switch (index) {
      case 0:
        totalPage = movie.totalReview! ~/ 10;
        if (totalPage == 0 || totalPage * 10 < movie.totalReview!) {
          totalPage++;
        }
      case 1:
        totalPage = movie.totalRatingWithPicture! ~/ 10;
        if (totalPage == 0 || totalPage * 10 < movie.totalRatingWithPicture!) {
          totalPage++;
        }
      case 2:
        totalPage = movie.totalFiveRating! ~/ 10;
        if (totalPage == 0 || totalPage * 10 < movie.totalFiveRating!) {
          totalPage++;
        }
      case 3:
        totalPage = movie.totalFourRating! ~/ 10;
        if (totalPage == 0 || totalPage * 10 < movie.totalFourRating!) {
          totalPage++;
        }
      case 4:
        totalPage = movie.totalThreeRating! ~/ 10;
        if (totalPage == 0 || totalPage * 10 < movie.totalThreeRating!) {
          totalPage++;
        }
      case 5:
        totalPage = movie.totalTwoRating! ~/ 10;
        if (totalPage == 0 || totalPage * 10 < movie.totalTwoRating!) {
          totalPage++;
        }
      case 6:
        totalPage = movie.totalOneRating! ~/ 10;
        if (totalPage == 0 || totalPage * 10 < movie.totalOneRating!) {
          totalPage++;
        }
    }
    if (currentIndex.value != index) {
      currentIndex.value = index;
    }
  }
}
