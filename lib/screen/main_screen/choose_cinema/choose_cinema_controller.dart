import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/dialogs/dialog_confirm.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/dialogs/dialog_loading.dart';
import 'package:ticket_app/core/service/cache_service.dart';
import 'package:ticket_app/core/utils/loaction_util.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';

class ChooseCinemaController extends GetxController {
  Rx<String> selectCity = ''.obs;
  DateTime dateTime = DateTime.now();
  final searchCityTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Rx<CinemaCity?> currentCinemaCity =
      Get.context!.read<DataAppProvider>().reconmmedCinemaCity.obs;
  RxList<Cinema> fillterCinema = <Cinema>[].obs;
  RxInt currentIndexCinemaType = 0.obs;
  Rx<PermissionStatus> locationPermisstion = PermissionStatus.denied.obs;
  Position? position;

  @override
  void onInit() {
    checkLocationPermission();
    selectCity.value =
        Get.context!.read<DataAppProvider>().cityNameCurrent ?? cities[0];
    currentCinemaCity.value =
        Get.context!.read<DataAppProvider>().reconmmedCinemaCity;
    if (currentCinemaCity.value != null) {
      fillterCinema.value = currentCinemaCity.value!.all.sublist(0);
    }
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchCityTextController.dispose();
    super.onClose();
  }

  Future<void> checkLocationPermission() async {
    locationPermisstion.value = await Permission.location.status;
    if (locationPermisstion.value == PermissionStatus.granted) {
      position = await Geolocator.getCurrentPosition();
    }
    debugLog(locationPermisstion.string);
  }

  void onSelectCinemaType(int index) {
    if (selectCity.value == '--- chọn tính / thành phố ---') return;
    if (index == 0) {
      currentIndexCinemaType.value = 0;
      fillterCinema.clear();
      fillterCinema.value = currentCinemaCity.value!.all.sublist(0);
      if (fillterCinema.isNotEmpty && scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    }

    if (index == 1) {
      currentIndexCinemaType.value = 1;
      fillterCinema.clear();
      fillterCinema.value = currentCinemaCity.value!.cgv.sublist(0);
      if (fillterCinema.isNotEmpty && scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    }

    if (index == 2) {
      currentIndexCinemaType.value = 2;
      fillterCinema.clear();
      fillterCinema.value = currentCinemaCity.value!.lotte.sublist(0);
      if (fillterCinema.isNotEmpty && scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    }
    if (index == 3) {
      currentIndexCinemaType.value = 3;
      fillterCinema.clear();
      fillterCinema.value = currentCinemaCity.value!.galaxy.sublist(0);
      if (fillterCinema.isNotEmpty && scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
    }
  }

  Future<void> resquestPermission(BuildContext context) async {
    final isConfirm = await DialogConfirm.show(
      context: context,
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
      DialogLoading.show(Get.context!);
      position = await Geolocator.getCurrentPosition();
      final currentCityName = await LocationUtil.getCurrentCity(position!);
      if (currentCityName != null) {
        selectCity.value = currentCityName;
        final cinemaCityResponse = await getCinemaCity(
          currentCityname: currentCityName,
          position: position,
        );

        if (cinemaCityResponse != null) {
          Get.context!.read<DataAppProvider>().reconmmedCinemaCity =
              currentCinemaCity.value =
                  Get.context!.read<DataAppProvider>().reconmmedCinemaCity;
          fillterCinema.value = currentCinemaCity.value!.all.sublist(0);
        }
      }
      Get.back();
    }
  }

  Future<CinemaCity?> getCinemaCity({
    required String? currentCityname,
    required Position? position,
  }) async {
    if (currentCityname == null) return null;
    DialogLoading.show(Get.context!);

    final cinemaCityResponse = await ApiCommon.get(
      url: ApiConst.cinemaCityUrl,
      queryParameters: {
        "cityName": currentCityname,
      },
    );

    if (cinemaCityResponse.data != null) {
      final cinemaCityRecomemed = CinemaCity.fromJson(cinemaCityResponse.data);
      if (position != null) {
        getDistance(cinemaCityRecomemed, position);
        sortCinemaCity(cinemaCityRecomemed);
      }
      Get.back();
      return cinemaCityRecomemed;
    } else {
      Get.back();
      DialogError.show(
        context: Get.context!,
        message: cinemaCityResponse.error!.message,
      );
      return null;
    }
  }

  void sortCinemaCity(CinemaCity cinemaCity) {
    cinemaCity.cgv.sort(
      (a, b) => a.distance!.compareTo(b.distance!),
    );
    cinemaCity.galaxy.sort(
      (a, b) => a.distance!.compareTo(b.distance!),
    );
    cinemaCity.lotte.sort(
      (a, b) => a.distance!.compareTo(b.distance!),
    );
    cinemaCity.all.sort(
      (a, b) => a.distance!.compareTo(b.distance!),
    );
  }

  void getDistance(CinemaCity cinemaCity, Position position) async {
    for (var element in cinemaCity.cgv) {
      element.distance = Geolocator.distanceBetween(
        element.lat,
        element.long,
        position.latitude,
        position.longitude,
      );
    }
    for (var element in cinemaCity.galaxy) {
      element.distance = Geolocator.distanceBetween(
        element.lat,
        element.long,
        position.latitude,
        position.longitude,
      );
    }
    for (var element in cinemaCity.lotte) {
      element.distance = Geolocator.distanceBetween(
        element.lat,
        element.long,
        position.latitude,
        position.longitude,
      );
    }
    cinemaCity.all = cinemaCity.cgv.sublist(0) +
        cinemaCity.lotte.sublist(0) +
        cinemaCity.galaxy.sublist(0);
  }

  void onChangeCity(String cityName, Position? position) async {
    if (cityName == "--- chọn tính / thành phố ---") {
      return;
    }

    final response =
        await getCinemaCity(currentCityname: cityName, position: position);
    if (response == null) return;

    if (cities.first == '--- chọn tính / thành phố ---') {
      Get.context!.read<DataAppProvider>().cityNameCurrent = cityName;
      cities.removeAt(0);
    }
    selectCity.value = cityName;
    CacheService.saveData("cityName", cityName);
    currentCinemaCity.value = response;
    currentIndexCinemaType.value = 0;
    fillterCinema.value = currentCinemaCity.value!.all.sublist(0);
  }

  String formatPrice(int price) {
    return "${price ~/ 1000}K";
  }
}
