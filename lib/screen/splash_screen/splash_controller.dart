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
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/components/service/cache_service.dart';
import 'package:ticket_app/components/utils/loaction_util.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/home_data.dart';
import 'package:ticket_app/models/user_info_model.dart';

class SplashController extends GetxController {
  @override
  onInit() {
    super.onInit();
    getHomeData();
  }

  Future<void> getHomeData() async {
    final homeResponse = await ApiCommon.get(url: ApiConst.homeUrl);
    final result = await checkPermisstion();
    Position? position;
    String? currentCityname;
    if (result) {
      position = await Geolocator.getCurrentPosition();
      currentCityname = await LocationUtil.getCurrentCity(position);
      Get.context!.read<DataAppProvider>().cityNameCurrent = currentCityname;
    }

    if (homeResponse.data != null) {
      final homeData = HomeData.fromJson(homeResponse.data!);
      Get.context!.read<DataAppProvider>().homeData = homeData;

      if (currentCityname != null) {
        await getCinemaCityRecommend(
          currentCityname: currentCityname,
          position: position,
        );
      } else {
        if (CacheService.getData(AppKey.cityName) != null) {
          Get.context!.read<DataAppProvider>().cityNameCurrent =
              CacheService.getData(AppKey.cityName);
          await getCinemaCityRecommend(
            currentCityname: currentCityname,
            position: position,
          );
        }
      }

      checkIsFirst();
    } else {
      // debugLog(homeResponse.error?.message ??
      //     '' + " " + cinemaCityResponse.error!.message);
    }
  }

  Future<CinemaCity?> getCinemaCityRecommend({
    required String? currentCityname,
    required Position? position,
  }) async {
    if (currentCityname == null || position == null) return null;
    debugLog(currentCityname);
    try {
      final cinemaCityResponse = await ApiCommon.get(
        url: ApiConst.cinemaCityUrl,
        queryParameters: {
          "cityName": currentCityname,
        },
      );
      final cinemaCityRecomemed = CinemaCity.fromJson(cinemaCityResponse.data);
      getDistance(cinemaCityRecomemed, position);
      sortCinemaCity(cinemaCityRecomemed);
      Get.context!.read<DataAppProvider>().reconmmedCinemaCity =
          cinemaCityRecomemed;
      debugLog(cinemaCityRecomemed.cgv.length.toString());
      cities.removeAt(0);
      return cinemaCityRecomemed;
    } catch (e, s) {
      debugLog('${e.toString()} $s');
      return null;
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
      final respose = await getUserInfo(
        uid: FirebaseAuth.instance.currentUser!.uid,
      );
      if (respose != null) {
        Get.offAllNamed(RouteName.mainScreen);
      }
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

  Future<UserInfoModel?> getUserInfo({required String uid}) async {
    final response = await ApiCommon.get(
      url: ApiConst.signIn,
      queryParameters: {"uid": uid},
    );
    if (response.data != null) {
      final user = UserInfoModel.fromJson(response.data);
      Get.context!.read<DataAppProvider>().userInfoModel = user;
      return user;
    } else {
      DialogError.show(
        context: Get.context!,
        message: response.error!.message,
      );
      return null;
    }
  }
}
