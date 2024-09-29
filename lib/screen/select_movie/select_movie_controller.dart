import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/core/utils/datetime_util.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/showtimes.dart';

class SelectMovieController extends GetxController {
  final cinema = Get.arguments as Cinema;
  RxInt currentSelectedDayIndex = 0.obs;
  List<DateTime> listDateTime = [];
  final searchCityTextController = TextEditingController();
  RxBool isLoading = true.obs;
  RxList<Showtimes> listShowtimes = <Showtimes>[].obs;

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

    debugLog(response.data.toString());

    if (response.data != null) {
      final listShowtimesResponse = <Showtimes>[];
      for (var element in response.data) {
        final showtime = Showtimes.fromJson(element);
        showtime.times.assignAll(filterTime(showtime, index));
        if (showtime.times.isNotEmpty) {
          listShowtimesResponse.add(showtime);
        }
      }
      listShowtimes.assignAll(listShowtimesResponse);
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

  List<Time> filterTime(Showtimes showtime, int index) {
    final listTimeFilter = <Time>[];

    for (var time in showtime.times) {
      List<String> times = time.time.split(" - ");

      DateFormat dateFormat = DateFormat("HH:mm");

      DateTime startTime = dateFormat.parse(times[0]);

      DateTime startDateTime = DateTime(
        listDateTime[index].year,
        listDateTime[index].month,
        listDateTime[index].day,
        startTime.hour,
        startTime.minute,
      );

      debugLog(startDateTime.toString());

      if (startDateTime.isAfter(DateTime.now())) {
        listTimeFilter.add(time);
      }
    }

    return listTimeFilter;
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
