import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/components/api/api_common.dart';
import 'package:ticket_app/components/api/api_const.dart';
import 'package:ticket_app/components/const/net_work_info.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/review.dart';

class DetailMovieController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<Review> reviews = <Review>[].obs;
  RxBool isLoading = false.obs;
  RxString messageFaild = ''.obs;
  final movie = Get.arguments as Movie;
  late final TabController tabController = TabController(
    length: 2,
    vsync: this,
  );

  @override
  void onInit() {
    getReviewMovie();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> getReviewMovie() async {
    isLoading.value = true;

    try {
      if (!await NetWorkInfo.isConnectedToInternet()) {
        messageFaild.value = 'Không có kết nối Internet';
        isLoading.value = false;
        return;
      }

      final response = await ApiCommon.get(
        url: ApiConst.allReview,
        queryParameters: {
          "movieId": movie.id,
          "page": 1,
        },
      );

      if (response.data != null) {
        final listReviewResponse = <Review>[];
        for (var element in response.data) {
          listReviewResponse.add(Review.fromJson(element));
        }
        reviews.assignAll(listReviewResponse);
        messageFaild.value = '';
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      messageFaild.value = 'Đã có lỗi xảy ra, vui lòng thử lại';
    }
  }
}
