import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/app_key.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/core/service/cache_service.dart';
import 'package:ticket_app/core/service/notification_service.dart';
import 'package:ticket_app/core/utils/loaction_util.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/home_data.dart';
import 'package:ticket_app/models/ticket_prices.dart';
import 'package:ticket_app/models/user_info_model.dart';

class SplashController extends GetxController {
  Position? position;
  String cityName = '';

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    await getHomeData();
    await getTicketPrices();
    await getCurrentCityName();
    await getCinemaCityRecommend();
    await checkIsFirst();
  }

  Future<void> getCurrentCityName() async {
    final result = await checkPermisstion();
    if (result) {
      position = await Geolocator.getCurrentPosition();
      cityName = await LocationUtil.getCurrentCity(position!);

      if (cityName.isNotEmpty) {
        if (!cities.contains(cityName)) {
          cityName = await getCacheCityName();
        } else {
          cities.removeWhere(
            (element) => element == '--- chọn tính / thành phố ---',
          );
        }
      } else {
        cityName = await getCacheCityName();
      }
    } else {
      cityName = await getCacheCityName();
    }

    Get.context!.read<DataAppProvider>().cityNameCurrent = cityName;

    debugLog(cityName);
  }

  Future<void> getHomeData() async {
    await NotificationService.requestPermission();

    final homeResponse = await ApiCommon.get(url: ApiConst.homeUrl);

    if (homeResponse.data != null) {
      final homeData = HomeData.fromJson(homeResponse.data!);
      Get.context!.read<DataAppProvider>().homeData = homeData;
    } else {
      DialogError.show(
        context: Get.context!,
        message: homeResponse.error?.message ??
            'Đã có lỗi xảy ra vui lòng thử lại sao',
        onTap: () => SystemNavigator.pop(),
      );
    }
  }

  Future<String> getCacheCityName() async {
    String result = '';
    final response = await CacheService.getData(AppKey.cityName);

    if (response != null) {
      result = response;
      cities.removeWhere(
        (element) => element == '--- chọn tính / thành phố ---',
      );
    } else {
      result = cities.first;
    }

    return result;
  }

  Future<void> getCinemaCityRecommend() async {
    if (cityName.isEmpty && position == null) return;

    if (cityName == '--- chọn tính / thành phố ---') return;

    if (cityName.isEmpty) return;

    try {
      final cinemaCityResponse = await ApiCommon.get(
        url: ApiConst.cinemaCityUrl,
        queryParameters: {
          "cityName": cityName,
        },
      );

      if (cinemaCityResponse.error != null) return;

      final cinemaCityRecomemed = CinemaCity.fromJson(cinemaCityResponse.data);

      if (position != null) {
        getDistance(cinemaCityRecomemed, position!);
        sortCinemaCity(cinemaCityRecomemed);
      }

      Get.context!.read<DataAppProvider>().reconmmedCinemaCity =
          cinemaCityRecomemed;
    } catch (e, s) {
      debugLog('${e.toString()} $s');
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
    if (Get.context!.read<DataAppProvider>().homeData == null) return;

    if (FirebaseAuth.instance.currentUser != null) {
      final response = await getUserInfo(
        uid: FirebaseAuth.instance.currentUser!.uid,
      );

      if (response != null) {
        Get.offAllNamed(RouteName.mainScreen);
      } else {
        Get.offAllNamed(RouteName.signInScreen);
      }
    } else {
      Get.offAllNamed(RouteName.signInScreen);
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
      debugLog(response.error.toString());
      return null;
    }
  }

  Future<void> getTicketPrices() async {
    final now = DateTime.now();
    final response = await ApiCommon.get(
      url: ApiConst.getTicketPrices,
      queryParameters: {
        "date": "${now.day}/${now.month}/${now.year}",
      },
    );

    debugLog(response.data.toString());

    if (response.data != null) {
      Get.context!.read<DataAppProvider>().ticketPrices =
          TicketPrices.fromJson(response.data);
    }
  }
}
