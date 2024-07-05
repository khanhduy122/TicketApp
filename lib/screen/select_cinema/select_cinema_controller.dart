import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/components/api/api_common.dart';
import 'package:ticket_app/components/api/api_const.dart';
import 'package:ticket_app/components/dialogs/dialog_confirm.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/components/service/cache_service.dart';
import 'package:ticket_app/components/utils/datetime_util.dart';
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
  List<Showtimes> showtimes = <Showtimes>[];
  RxList<Showtimes> showtimesByCinemaType = <Showtimes>[].obs;
  RxBool isLoading = false.obs;
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
    _initDays();
    await checkPermisstion();
    getCinemaCity(
        selectCity.value, listDateTime[currentSelectedDateIndex.value]);
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
    final result = await getCinemaCity(selectCity.value, listDateTime[index]);
    if (!result) return;

    currentSelectedDateIndex.value = index;
  }

  void onTapCinemaType(int index) {
    currentSelctCinemaTypeIndex.value = index;
    switch (index) {
      case 0:
        showtimesByCinemaType.value = showtimes.sublist(0);
        break;
      case 1:
        showtimesByCinemaType.value = showtimes
            .where((element) => element.cinema!.type == CinemasType.CGV)
            .toList();
        break;
      case 2:
        showtimesByCinemaType.value = showtimes
            .where((element) => element.cinema!.type == CinemasType.Lotte)
            .toList();
        break;
      case 3:
        showtimesByCinemaType.value = showtimes
            .where((element) => element.cinema!.type == CinemasType.Galaxy)
            .toList();
        break;
    }
  }

  Future<void> onChangeCity(String cityName) async {
    if (cityName == "--- chọn tính / thành phố ---") {
      return;
    }

    final result = await getCinemaCity(
      cityName,
      listDateTime[currentSelectedDateIndex.value],
    );

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
    isLoading.value = true;
    final response = await ApiCommon.get(
      url: ApiConst.getCinemaShowingMovie,
      queryParameters: {
        "movieId": movie.id,
        "date": DateTimeUtil.stringFromDateTime(dateTime),
        "cityName": cityName,
      },
    );

    if (response.data != null) {
      if (response.data.isEmpty) {
        showtimes = [];
        isLoading.value = false;
        showtimesByCinemaType.value = showtimes.sublist(0);
        onTapCinemaType(currentSelctCinemaTypeIndex.value);
        return true;
      }

      List<Showtimes> showtimesResponse = [];
      for (var element in response.data) {
        showtimesResponse.add(Showtimes.fromJson(element));
      }

      final status = await Permission.location.status;
      if (status.isGranted) {
        if (position != null) {
          getDistance(showtimesResponse, position!);
          sortShowtimes(showtimesResponse);
        }
      }

      showtimes.assignAll(showtimesResponse);
      showtimesByCinemaType.value = showtimes.sublist(0);
      onTapCinemaType(currentSelctCinemaTypeIndex.value);
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
    locationPermisstion.value = await Permission.location.status;
    if (locationPermisstion.value == PermissionStatus.permanentlyDenied &&
        isConfirm) {
      openAppSettings();
      return;
    }
    locationPermisstion.value = await Permission.location.request();
    if (locationPermisstion.value == PermissionStatus.granted) {
      position = await Geolocator.getCurrentPosition();
      getCinemaCity(
        selectCity.value,
        listDateTime[currentSelectedDateIndex.value],
      );
    }
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
}
