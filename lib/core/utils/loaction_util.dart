import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/core/const/app_key.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/service/cache_service.dart';
import 'package:ticket_app/models/data_app_provider.dart';

class LocationUtil {
  static Future<String> getCurrentCity(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        String? cityName = placemarks[0].administrativeArea;
        Get.context!.read<DataAppProvider>().cityNameCurrent = cityName;
        return cityName ?? '';
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }
}
