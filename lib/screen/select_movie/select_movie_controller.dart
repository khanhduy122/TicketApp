import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ticket_app/components/api/api_common.dart';
import 'package:ticket_app/components/api/api_const.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/components/utils/datetime_util.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/showtimes.dart';

class SelectMovieController extends GetxController {
  final cinema = Get.arguments as Cinema;
  RxInt currentSelectedDayIndex = 0.obs;
  List<DateTime> listDateTime = [];
  final searchCityTextController = TextEditingController();
  RxBool isLoading = true.obs;
  RxList<Showtimes> showtimes = <Showtimes>[].obs;

  @override
  void onInit() {
    _initDays();
    getMovieNowShowingInCinema(0);
    super.onInit();
  }

  @override
  void dispose() {
    searchCityTextController.dispose();
    super.dispose();
  }

  void _initDays() {
    DateTime now = DateTime.now();
    int currentDay = now.day;
    int currentMonth = now.month;
    int currentYear = now.year;
    listDateTime.add(DateTime(currentYear, currentMonth, currentDay));
    for (int i = 0; i < 14; i++) {
      currentDay++;
      if (currentMonth == 4 ||
          currentMonth == 6 ||
          currentMonth == 9 ||
          currentMonth == 11) {
        if (currentDay > 30) {
          currentDay = 1;
          currentMonth++;
        }
      }
      if (currentMonth == 1 ||
          currentMonth == 3 ||
          currentMonth == 5 ||
          currentMonth == 7 ||
          currentMonth == 8 ||
          currentMonth == 10 ||
          currentMonth == 12) {
        if (currentDay > 31) {
          currentDay = 1;
          currentMonth++;
          if (currentDay > 12) {
            currentMonth = 1;
            currentYear++;
          }
        }
      }
      listDateTime.add(DateTime(currentYear, currentMonth, currentDay));
    }
  }

  Future<bool> getMovieNowShowingInCinema(int index) async {
    isLoading.value = true;
    final response = await ApiCommon.get(
      url: ApiConst.getMovieShowingInCinema,
      queryParameters: {
        "cinemaId": cinema.id,
        "date": DateTimeUtil.stringFromDateTime(listDateTime[index])
      },
    );

    if (response.data != null) {
      final listShowtimesResponse = <Showtimes>[];
      for (var element in response.data) {
        listShowtimesResponse.add(Showtimes.fromJson(element));
      }
      showtimes.assignAll(listShowtimesResponse);
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

  void onTapSelectDay(int index) {
    getMovieNowShowingInCinema(index).then((value) {
      if (value) currentSelectedDayIndex.value = index;
    });
  }

  void onTapShowtimes(Showtimes showtimes, int index) {
    Get.toNamed(
      RouteName.selectSeatScreen,
      arguments: {
        "cinema": cinema,
        "movie": showtimes.movie,
        "showtimes": showtimes,
        "time": showtimes.times[index],
      },
    );
  }
}
