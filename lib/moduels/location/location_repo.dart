
import 'package:geolocator/geolocator.dart';
import 'package:ticket_app/moduels/get_cinema_in_city/get_cinema_in_city_exception.dart';

class LocationRepo{

  static Future<Position> determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openAppSettings().then((isServiceEnabled) {
          if(!isServiceEnabled){
            throw LocationServiceDisableException();
          }
        });
      }
      
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw DeniedPermissionPositionException();
        }
      }

      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print("_determinePosition:$e");
      rethrow;
    }
  }

}