import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/const/net_work_info.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/core/utils/datetime_util.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/review.dart';

class DetailMovieController extends GetxController
    with GetSingleTickerProviderStateMixin {
  RxList<Review> reviews = <Review>[].obs;
  RxBool isLoading = false.obs;
  RxString messageFaild = ''.obs;
  final movie = Get.arguments as Movie;
  late final TabController tabController;

  @override
  void onInit() {
    getReviewMovie();
    tabController = TabController(
      length: 2,
      vsync: this,
    );
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
          'index': 0,
          "page": 1,
        },
      );

      if (response.data != null) {
        final listReviewResponse = <Review>[];
        for (var element in response.data) {
          listReviewResponse.add(Review.fromJson(element));
        }
        listReviewResponse.sort(
          (a, b) => b.timestamp.compareTo(a.timestamp),
        );
        reviews.assignAll(listReviewResponse);
        messageFaild.value = '';
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      debugLog(e.toString());
      messageFaild.value = 'Đã có lỗi xảy ra, vui lòng thử lại';
    }
  }

  void onTapBookTicket() {
    final birthday =
        Get.context!.read<DataAppProvider>().userInfoModel!.birthDay;
    final dateTimeBirtday = DateTimeUtil.stringToDateTime(birthday);
    final yearNow = DateTime.now().year;
    final ageUser = yearNow - dateTimeBirtday.year;

    switch (movie.ban!) {
      case Ban.c13:
        if (ageUser < 13) {
          DialogError.show(
            context: Get.context!,
            message: "Bạn không đủ tuổi để có thể xem phim này",
          );
          return;
        }

      case Ban.c16:
        if (ageUser < 16) {
          DialogError.show(
            context: Get.context!,
            message: "Bạn không đủ tuổi để có thể xem phim này",
          );
        }
        return;
      case Ban.c18:
        if (ageUser < 18) {
          DialogError.show(
            context: Get.context!,
            message: "Bạn không đủ tuổi để có thể xem phim này",
          );
          return;
        }
      case Ban.p:
    }

    Get.toNamed(
      RouteName.selectCinemaScreen,
      arguments: movie,
    );
  }
}
