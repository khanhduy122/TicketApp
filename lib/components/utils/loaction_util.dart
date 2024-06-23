import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/components/const/app_key.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/service/cache_service.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';

class LocationUtil {
  static Future<String?> getCurrentCity(Position position) async {
    return 'Thành phố Hồ Chí Minh';
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      debugLog(placemarks.first.toString());

      if (placemarks.isNotEmpty) {
        String? cityName = placemarks[0].administrativeArea;
        CacheService.saveData(AppKey.cityName, cityName);
        Get.context!.read<DataAppProvider>().cityNameCurrent = cityName;
        if (cityName != null) {
          cities.remove(cities.first);
        }
        return cityName;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
