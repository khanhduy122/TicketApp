
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/moduels/get_cinema_by_city/get_cinema_by_city_exception.dart';

class GetCinemasRepo {

  final FirebaseFirestore _firestore =FirebaseFirestore.instance;

  Future<CinemaCity> getCinemasByCity(String city)async{
    Position position = await _determinePosition();
    final res = await _firestore.collection("data_app").doc(city).get();
    CinemaCity cinemaCity = CinemaCity.fromJson(res.data()!);

    for (var element in cinemaCity.cgv!) {
      element.distance = Geolocator.distanceBetween(position.latitude, position.longitude, element.lat!, element.long!);
    }
    cinemaCity.cgv!.sort((a, b) => a.distance!.compareTo(b.distance!),);

    for (var element in cinemaCity.galaxy!) {
      element.distance = Geolocator.distanceBetween(position.latitude, position.longitude, element.lat!, element.long!);
    }
    cinemaCity.galaxy!.sort((a, b) => a.distance!.compareTo(b.distance!),);

    for (var element in cinemaCity.lotte!) {
      element.distance = Geolocator.distanceBetween(position.latitude, position.longitude, element.lat!, element.long!);
    }
    cinemaCity.lotte!.sort((a, b) => a.distance!.compareTo(b.distance!),);

    cinemaCity.all = cinemaCity.cgv!.sublist(0) + cinemaCity.galaxy!.sublist(0) + cinemaCity.lotte!.sublist(0);
    cinemaCity.all!.sort((a, b) => a.distance!.compareTo(b.distance!),);

    return cinemaCity;
  }

  
  
  // Future<List<Cinema>> getCinemas(String city, CinemasType cinemasType) async {
  //   List<Cinema> cinemasByCity = [];
  //   try {
  //     await _determinePosition();
  //     final respone = await _dio.post(
  //         "https://places.googleapis.com/v1/places:searchText",
  //         data: {
  //           "textQuery": "rạp phim ${cinemasType.name} $city",
  //           "includedType": "movie_theater",
  //           "maxResultCount": 20,
  //         },
  //         options: Options(
  //           headers: {
  //             "Content-Type": "application/json",
  //             "X-Goog-FieldMask": "places.displayName,places.formattedAddress,places.id,places.location",
  //             "X-Goog-Api-Key": AppKey.googleMapApiKey
  //           }
  //         )
  //       ).timeout(
  //         const Duration(seconds: 20),
  //         onTimeout: () {
  //           throw TimeOutException();
  //         },
  //       );

  //       if(respone.statusCode == 200){
  //         Map<String, dynamic> mapResponse = respone.data;
  //         mapResponse["places"].forEach((json){
  //           String name = json['displayName']["text"].toString().toLowerCase();
  //           if(name.contains("cgv".toLowerCase()) || name.contains("lotte".toLowerCase()) || name.contains("galaxy".toLowerCase())){
  //             print(name);
  //             Cinema cinema = Cinema.fromJson(json);
  //             cinemasByCity.add(cinema);
  //           }
  //         });
  //         return cinemasByCity;
  //       }else{
  //         throw Exception();
  //       }
  //   } catch (e) {
  //     print("getCinemasByCity:" + e.toString());
  //     rethrow;
  //   }
  // }

  // Future<void> setFirebase(String city, List<Cinema> cinemasCGV, List<Cinema> cinemasLotte, List<Cinema> cinemasGalaxy) async {
  //   FirebaseFirestore firestore = FirebaseFirestore.instance;
  //   List<Map<String, dynamic>> mapCinemasCgv = cinemasCGV.map((cinema) => cinema.toJson()).toList();
  //   List<Map<String, dynamic>> mapCinemasLotte = cinemasLotte.map((cinema) => cinema.toJson()).toList();
  //   List<Map<String, dynamic>> mapCinemasGalaxy = cinemasGalaxy.map((cinema) => cinema.toJson()).toList();
  //   firestore.collection("data_app").doc(city).set(
  //     {
  //       "CGV": mapCinemasCgv,
  //       "Lotte": mapCinemasLotte,
  //       "Galaxy": mapCinemasGalaxy,
  //     }
  //   );
  // }

  Future<Position> _determinePosition() async {
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
      print("_determinePosition:" + e.toString());
      rethrow;
    }
  }
}