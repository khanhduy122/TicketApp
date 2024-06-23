import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ticket_app/components/api/api_common.dart';
import 'package:ticket_app/components/api/api_const.dart';
import 'package:ticket_app/components/const/app_key.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/components/service/cache_service.dart';
import 'package:ticket_app/components/utils/loaction_util.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/home_data.dart';

class SplashController extends GetxController {
  @override
  onInit() {
    super.onInit();
    getHomeData();
  }

  Future<void> getHomeData() async {
    final homeResponse = await ApiCommon.get(url: ApiConst.homeUrl);
    final cinemaCityResponse = await ApiCommon.get(url: ApiConst.cinemaCityUrl);
    final result = await checkPermisstion();
    Position? position;
    String? currentCityname;
    if (result) {
      position = await Geolocator.getCurrentPosition();
      currentCityname = await LocationUtil.getCurrentCity(position);
      Get.context!.read<DataAppProvider>().cityNameCurrent = currentCityname;
    }

    if (homeResponse.data != null && cinemaCityResponse.data != null) {
      final homeData = HomeData.fromJson(homeResponse.data!);
      final cinemaCities = <CinemaCity>[];
      for (var element in cinemaCityResponse.data as List) {
        final cinemaCity = CinemaCity.fromJson(element);
        if (result) {
          getDistance(cinemaCity, position!);
          sortCinemaCity(cinemaCity);
        }
        cinemaCities.add(cinemaCity);
      }
      Get.context!.read<DataAppProvider>().homeData = homeData;
      Get.context!.read<DataAppProvider>().allCinemaCity = cinemaCities;

      if (result) {
        if (currentCityname == null) return;
        Get.context!.read<DataAppProvider>().reconmmedCinemas = cinemaCities
            .firstWhere((element) => element.name == currentCityname);
        cities.removeAt(0);
      } else {
        if (CacheService.getData(AppKey.cityName) != null) {
          Get.context!.read<DataAppProvider>().cityNameCurrent =
              CacheService.getData(AppKey.cityName);
          Get.context!.read<DataAppProvider>().reconmmedCinemas =
              cinemaCities.firstWhere(
            (element) => element.name == CacheService.getData(AppKey.cityName),
          );
          cities.removeAt(0);
        }
      }
      checkIsFirst();
    } else {
      debugLog(homeResponse.error?.message ??
          '' + " " + cinemaCityResponse.error!.message);
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

  Future<void> checkIsFirst() async {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.offAllNamed(RouteName.mainScreen);
    } else {
      await SharedPreferences.getInstance().then((prefs) {
        if (prefs.getBool(AppKey.checkIsFirstKey) == null) {
          prefs.setBool(AppKey.checkIsFirstKey, true);
          Get.offAllNamed(RouteName.onBoardingScreen);
        } else {
          Get.offAllNamed(RouteName.signInScreen);
        }
      });
    }
  }

  Future<bool> checkPermisstion() async {
    final status = await Permission.location.status;

    if (status == PermissionStatus.permanentlyDenied) {
      return false;
    }

    final result = await Permission.location.request();
    return result == PermissionStatus.granted;
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
}
