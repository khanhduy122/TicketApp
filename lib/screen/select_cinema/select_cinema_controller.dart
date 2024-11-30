import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/dialogs/dialog_confirm.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/core/service/cache_service.dart';
import 'package:ticket_app/core/utils/datetime_util.dart';
import 'package:ticket_app/core/utils/loaction_util.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/showtimes.dart';

class SelectCinemaController extends GetxController {
  RxString selectCity =
      (Get.context!.read<DataAppProvider>().cityNameCurrent ?? cities[0]).obs;
  final movie = Get.arguments as Movie;
  RxInt currentSelectedDateIndex = 0.obs;
  RxInt currentSelectedMovieTimeIndex = 0.obs;
  RxInt currentSelctCinemaTypeIndex = 0.obs;
  final List<DateTime> listDateTime = [];
  final searchCityTextController = TextEditingController();
  final DateTime currentDate = DateTime.now();
  List<Showtimes> showtimesAll = <Showtimes>[];
  Rxn<List<Showtimes>> showtimesFilter = Rxn(null);
  RxBool isLoading = true.obs;
  Rx<PermissionStatus> locationPermisstion = PermissionStatus.denied.obs;
  Position? position;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  @override
  void onClose() {
    searchCityTextController.dispose();
    super.onClose();
  }

  Future<void> init() async {
    _initDays();
    await checkPermisstion();
    await getCinemaCity(
      selectCity.value,
      listDateTime[currentSelectedDateIndex.value],
    );
    isLoading.value = false;
  }

  Future<void> checkPermisstion() async {
    locationPermisstion.value = await Permission.location.status;
    if (locationPermisstion.value == PermissionStatus.granted) {
      position = await Geolocator.getCurrentPosition();
    }
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

  Future<void> onTapSelectDate(int index) async {
    debugLog(listDateTime[index].toString());
    isLoading.value = true;
    final result = await getCinemaCity(selectCity.value, listDateTime[index]);
    isLoading.value = false;
    if (!result) return;

    currentSelectedDateIndex.value = index;
  }

  void onTapCinemaType(int index) {
    currentSelctCinemaTypeIndex.value = index;

    switch (index) {
      case 0:
        showtimesFilter?.value = showtimesAll.sublist(0);
        break;
      case 1:
        showtimesFilter?.value = showtimesAll
            .where((element) => element.cinema!.type == CinemasType.CGV)
            .toList()
            .sublist(0);
        break;
      case 2:
        showtimesFilter?.value = showtimesAll
            .where((element) => element.cinema!.type == CinemasType.Lotte)
            .toList()
            .sublist(0);
        break;
      case 3:
        showtimesFilter?.value = showtimesAll
            .where((element) => element.cinema!.type == CinemasType.Galaxy)
            .toList()
            .sublist(0);
        break;
    }
  }

  Future<void> onChangeCity(String cityName) async {
    if (cityName == "--- chọn tính / thành phố ---") {
      return;
    }

    isLoading.value = true;
    final result = await getCinemaCity(
      cityName,
      listDateTime[currentSelectedDateIndex.value],
    );

    isLoading.value = false;

    if (!result) return;

    if (cities.first == '--- chọn tính / thành phố ---') {
      Get.context!.read<DataAppProvider>().cityNameCurrent = cityName;
      cities.removeAt(0);
    }
    selectCity.value = cityName;
    CacheService.saveData("cityName", cityName);
  }

  Future<bool> getCinemaCity(String cityName, DateTime dateTime) async {
    if (cityName == '--- chọn tính / thành phố ---') return false;

    final response = await ApiCommon.get(
      url: ApiConst.getCinemaShowingMovie,
      queryParameters: {
        "movieId": movie.id,
        "date": DateTimeUtil.stringFromDateTime(dateTime),
        "cityName": cityName,
      },
    );

    if (response.data != null) {
      List<Showtimes> showtimesResponse = [];

      for (var element in response.data) {
        final showtime = Showtimes.fromJson(element);
        showtime.times.assignAll(filterTime(showtime, dateTime));
        if (showtime.times.isNotEmpty) {
          showtimesResponse.add(showtime);
        }
      }

      debugLog(showtimesResponse.toString());

      if (position != null) {
        getDistance(showtimesResponse, position!);
        sortShowtimes(showtimesResponse);
      }

      showtimesAll.assignAll(showtimesResponse);
      showtimesFilter.value = showtimesResponse.sublist(0);
      // debugLog(showtimesResponse.toString());
      // debugLog(showtimesFilter?.length.toString() ?? 'null');
      onTapCinemaType(0);
      return true;
    } else {
      DialogError.show(
        context: Get.context!,
        message: response.error!.message,
      );
      return false;
    }
  }

  List<Time> filterTime(Showtimes showtime, DateTime dateTime) {
    final listTimeFilter = <Time>[];

    for (var time in showtime.times) {
      List<String> times = time.time.split(" - ");

      DateFormat dateFormat = DateFormat("HH:mm");

      DateTime startTime = dateFormat.parse(times[0]);

      DateTime startDateTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        startTime.hour,
        startTime.minute,
      );

      if (startDateTime.isAfter(DateTime.now())) {
        listTimeFilter.add(time);
      }
    }

    return listTimeFilter;
  }

  void sortShowtimes(List<Showtimes> showtimes) {
    showtimes.sort(
      (a, b) => a.cinema!.distance!.compareTo(b.cinema!.distance!),
    );
  }

  void getDistance(List<Showtimes> showtimes, Position position) async {
    for (var element in showtimes) {
      element.cinema!.distance = Geolocator.distanceBetween(
        element.cinema!.lat,
        element.cinema!.long,
        position.latitude,
        position.longitude,
      );
    }
  }

  Future<void> resquestPermission() async {
    final isConfirm = await DialogConfirm.show(
      context: Get.context!,
      message:
          'Cho phép truy cập vào vị trí mở mục cài đặt của điện thoại để MovieTicket có thể gợi ý cho bạn rạp phim gần nhất',
      titleNegative: 'Hủy',
      titlePositive: 'Cho phép',
    );

    if (!isConfirm) return;

    locationPermisstion.value = await Permission.location.status;

    if (locationPermisstion.value == PermissionStatus.permanentlyDenied &&
        isConfirm) {
      openAppSettings();
      return;
    }

    final result = await Permission.location.request();
    if (result == PermissionStatus.granted) {
      isLoading.value = true;
      position = await Geolocator.getCurrentPosition();

      if (selectCity.value == '--- chọn tính / thành phố ---') {
        final cityName = await LocationUtil.getCurrentCity(position!);
        if (cityName.isNotEmpty && cities.contains(cityName)) {
          selectCity.value = cityName;
        }
      }

      await getCinemaCity(
        selectCity.value,
        listDateTime[currentSelectedDateIndex.value],
      );
    }

    locationPermisstion.value = result;
    isLoading.value = false;
  }

  void onTapShowtimes(Showtimes showtimes, int index) {
    Get.toNamed(
      RouteName.selectSeatScreen,
      arguments: {
        "cinema": showtimes.cinema,
        "movie": movie,
        "showtimes": showtimes,
        "time": showtimes.times[index],
      },
    );
  }

  String formatPrice(int price) {
    return '${price ~/ 1000}K';
  }

  Future<void> onTapWaring() async {}
}
