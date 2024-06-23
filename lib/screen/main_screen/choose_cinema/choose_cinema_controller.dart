import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/components/const/app_key.dart';
import 'package:ticket_app/components/dialogs/dialog_confirm.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/service/cache_service.dart';
import 'package:ticket_app/components/utils/loaction_util.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';

class ChooseCinemaController extends GetxController {
  Rx<String> selectCity = ''.obs;
  DateTime dateTime = DateTime.now();
  final searchCityTextController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<CinemaCity> allCinemaCity =
      Get.context!.read<DataAppProvider>().allCinemaCity ?? [];
  Rx<CinemaCity?> currentCinemaCity =
      Get.context!.read<DataAppProvider>().reconmmedCinemas.obs;
  RxList<Cinema> fillterCinema = <Cinema>[].obs;
  RxInt currentIndexCinemaType = 0.obs;
  Rx<PermissionStatus> locationPermisstion = PermissionStatus.denied.obs;

  @override
  void onInit() {
    checkLocationPermission();
    if (Get.context!.read<DataAppProvider>().cityNameCurrent == null) {
      if (CacheService.getData(AppKey.cityName) != null) {
        selectCity.value = CacheService.getData(AppKey.cityName);
        currentCinemaCity.value = allCinemaCity.firstWhere(
          (element) => element.name == selectCity.value,
        );
      } else {
        selectCity.value = cities.first;
      }
    } else {
      selectCity.value = Get.context!.read<DataAppProvider>().cityNameCurrent!;
    }
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
      final position = await Geolocator.getCurrentPosition();
      final currentCityName = await LocationUtil.getCurrentCity(position);
      if (currentCityName != null) {
        selectCity.value = currentCityName;
        for (var cinemaCity in allCinemaCity) {
          getDistance(cinemaCity, position);
        }
        Get.context!.read<DataAppProvider>().reconmmedCinemas = allCinemaCity
            .firstWhere((element) => element.name == currentCityName);
        currentCinemaCity.value =
            Get.context!.read<DataAppProvider>().reconmmedCinemas;
        fillterCinema.value = currentCinemaCity.value!.all.sublist(0);
      }
      Get.back();
    }
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

  void onChangeCity() {
    currentCinemaCity.value =
        allCinemaCity.firstWhere((element) => element.name == selectCity.value);
    currentIndexCinemaType.value = 0;
    fillterCinema.value = currentCinemaCity.value!.all.sublist(0);
  }
}
