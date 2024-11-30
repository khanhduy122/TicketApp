import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/const/net_work_info.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
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
  int currentPage = 0;
  RxBool isLoadingMore = false.obs;
  RxBool isLoading = false.obs;
  bool isCanLoadMore = true;

  @override
  void onInit() {
    getInitReview(0);
    listenerScrollMessages();
    super.onInit();
  }

  Future<void> listenerScrollMessages() async {
    itemPositionsListener.itemPositions.addListener(() async {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isNotEmpty) {
        if (positions.last.index >= (5 + (currentPage * 10)) &&
            !isLoadingMore.value &&
            isCanLoadMore) {
          isLoadingMore.value = true;
          debugLog("loadmore aaaaaa");
          await loadMoreReview();
        }
      }
    });
  }

  Future<bool> getInitReview(int index) async {
    isCanLoadMore = true;
    isLoading.value = true;

    final param = {
      'page': 0,
      'index': index,
      'movieId': movie.id,
    };

    final response = await ApiCommon.get(
      url: ApiConst.allReview,
      queryParameters: param,
    );

    debugLog((response.data as List).length.toString());

    if (response.data != null) {
      if (response.data.isEmpty) {
        isLoading.value = false;
        isCanLoadMore = false;
        reviewsDisplay.value = [];
        return true;
      }

      List<Review> listReviewResponse = [];

      for (var element in response.data) {
        listReviewResponse.add(Review.fromJson(element));
      }

      listReviewResponse.sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      );
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
        isCanLoadMore = false;
        return;
      }

      List<Review> listReviewResponse = [];

      for (var element in response.data) {
        listReviewResponse.add(Review.fromJson(element));
      }

      listReviewResponse.sort(
        (a, b) => b.timestamp.compareTo(a.timestamp),
      );

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
    currentPage = 0;
    if (currentIndex.value != index) {
      currentIndex.value = index;
    }
  }
}
