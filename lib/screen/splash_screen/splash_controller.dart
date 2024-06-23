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
import 'package:ticket_app/models/cinema_city.dart';
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

    if (homeResponse.data != null && cinemaCityResponse.data != null) {
      final homeData = HomeData.fromJson(homeResponse.data!);
      final cinemaCities = <CinemaCity>[];
      for (var element in cinemaCityResponse.data as List) {
        cinemaCities.add(CinemaCity.fromJson(element));
      }
      Get.context!.read<DataAppProvider>().homeData = homeData;
      Get.context!.read<DataAppProvider>().allCinemaCity = cinemaCities;

      final result = await checkPermisstion();
      debugLog(result.toString());
      if (result) {
        final Position position = await Geolocator.getCurrentPosition();
        final currentCityname = await getCurrentCity(position);
        if (currentCityname == null) return;
        Get.context!.read<DataAppProvider>().cityNameCurrent = currentCityname;
        Get.context!.read<DataAppProvider>().reconmmedCinemas = cinemaCities
            .firstWhere((element) => element.name == currentCityname);
      }
      checkIsFirst();
    } else {
      debugLog(homeResponse.error?.message ??
          '' + " " + cinemaCityResponse.error!.message);
    }
  }

  Future<void> checkIsFirst() async {
    if (FirebaseAuth.instance.currentUser != null) {
      Get.offAllNamed(RouteName.mainScreen);
      // Get.toNamed(RouteName.mainScreen);
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

  Future<String?> getCurrentCity(Position position) async {
    return 'Thành phố Hồ Chí Minh';
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      debugLog(placemarks.first.toString());

      if (placemarks.isNotEmpty) {
        String? cityName = placemarks[0].administrativeArea;
        CacheService.saveData(AppKey.cityName, cityName);
        return cityName;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
