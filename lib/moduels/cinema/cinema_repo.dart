import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as Location;
import 'package:ticket_app/components/app_key.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/components/service/cache_service.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/movie_showing_in_cinema.dart';
import 'package:ticket_app/moduels/location/location_repo.dart';

class CinemaRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocationRepo _locationRepo = LocationRepo();
  Location.Location _location = Location.Location();
  bool _serviceEnabled = false;
  Location.PermissionStatus _permissionGranted = Location.PermissionStatus.denied;

  Future<CinemaCity> getCinemasCity(String city, BuildContext context) async {
    try {
      Position? position;
      _serviceEnabled = await _location.serviceEnabled();
      _permissionGranted = await _location.hasPermission();
      
      if(!_serviceEnabled && _permissionGranted == Location.PermissionStatus.denied){
         position = await _locationRepo.determinePosition(context);
      }
     
      final res = await _firestore.collection("Cinemas").doc(city).get();
      CinemaCity cinemaCity = CinemaCity.fromJson(res.data()!);

      for (var element in cinemaCity.cgv!) {
        if(position != null){
          element.distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, element.lat, element.long);
        }
      }

      for (var element in cinemaCity.galaxy!) {
        if(position != null){
          element.distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, element.lat, element.long);
        }
      }

      for (var element in cinemaCity.lotte!) {
        if(position != null){
          element.distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, element.lat, element.long);
        }
      }

      if(position != null){
        cinemaCity.cgv!.sort(
          (a, b) => a.distance!.compareTo(b.distance!),
        );
        cinemaCity.galaxy!.sort(
          (a, b) => a.distance!.compareTo(b.distance!),
        );
        cinemaCity.lotte!.sort(
          (a, b) => a.distance!.compareTo(b.distance!),
        );
      }
      

      cinemaCity.all = cinemaCity.cgv!.sublist(0) +
          cinemaCity.galaxy!.sublist(0) +
          cinemaCity.lotte!.sublist(0);
        
      if(position != null){
        cinemaCity.all!.sort(
          (a, b) => a.distance!.compareTo(b.distance!),
        );
      }

      return cinemaCity;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieShowinginCinema>> getAllMovieReleasedCinema(
      {required Cinema cinema,
      required String cityName,
      required String date}) async {
    List<MovieShowinginCinema> movies = [];

    try {
      final res = await _firestore
          .collection("Cinemas")
          .doc(cityName)
          .collection(cinema.type.name)
          .doc(cinema.id)
          .collection(date)
          .get();
      for (var element in res.docs) {
        MovieShowinginCinema movieShowinginCinema =
            MovieShowinginCinema.fromJson(element.data());

        if (movieShowinginCinema.subtitle_2D != null) {
          final resut = movieShowinginCinema.subtitle_2D!
              .where(
                (element) => isValidShowtimes(
                  element.time,
                  DateTime(
                    int.parse(date.substring(6)),
                    int.parse(date.substring(3, 5)),
                    int.parse(
                      date.substring(0, 2),
                    ),
                  ),
                ),
              )
              .toList();
          movieShowinginCinema.subtitle_2D = resut.sublist(0);
        }

        if (movieShowinginCinema.voice_2D != null) {
          final resut = movieShowinginCinema.voice_2D!
              .where((element) => isValidShowtimes(
                    element.time,
                    DateTime(
                      int.parse(date.substring(6)),
                      int.parse(date.substring(3, 5)),
                      int.parse(
                        date.substring(0, 2),
                      ),
                    ),
                  ))
              .toList();
          movieShowinginCinema.voice_2D = resut.sublist(0);
        }

        if (movieShowinginCinema.subtitle_3D != null) {
          final resut = movieShowinginCinema.subtitle_3D!
              .where((element) => isValidShowtimes(
                    element.time,
                    DateTime(
                      int.parse(date.substring(6)),
                      int.parse(date.substring(3, 5)),
                      int.parse(
                        date.substring(0, 2),
                      ),
                    ),
                  ))
              .toList();
          movieShowinginCinema.subtitle_3D = resut.sublist(0);
        }

        if (movieShowinginCinema.voice_3D != null) {
          final resut = movieShowinginCinema.voice_3D!
              .where((element) => isValidShowtimes(
                    element.time,
                    DateTime(
                      int.parse(date.substring(6)),
                      int.parse(date.substring(3, 5)),
                      int.parse(
                        date.substring(0, 2),
                      ),
                    ),
                  ))
              .toList();
          movieShowinginCinema.voice_3D = resut.sublist(0);
        }

        if ((movieShowinginCinema.subtitle_2D != null &&
                movieShowinginCinema.subtitle_2D!.isNotEmpty) ||
            (movieShowinginCinema.voice_2D != null &&
                movieShowinginCinema.voice_2D!.isNotEmpty) ||
            (movieShowinginCinema.subtitle_3D != null &&
                movieShowinginCinema.subtitle_3D!.isNotEmpty) ||
            (movieShowinginCinema.voice_3D != null &&
                movieShowinginCinema.voice_3D!.isNotEmpty)) {
          movies.add(movieShowinginCinema);
        }
      }

      return movies;
    } catch (e) {
      rethrow;
    }
  }

  bool isValidShowtimes(String showtimes, DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime showtime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        int.parse(showtimes.substring(0, 2)),
        int.parse(showtimes.substring(3, 5)));
    return now.isBefore(showtime);
  }

  Future<CinemaCity?> getCinemasRecommended(BuildContext context) async {
    try {
      Position? position = await _locationRepo.determinePosition(context);

      if(position == null){
        final cityName = CacheService.getData(AppKey.cityName);
        if(cityName != null){
          final res = await getCinemasCity(cityName, context);
          return res;
        }
        cities.insert(0, '----Chọn tĩnh / thành phố----');
        return null;
      }

      String cityName = await getCurrentCity(position);

      debugLog(cityName);

      final res = await _firestore.collection("Cinemas").doc(cityName).get();

      CinemaCity cinemaCity = CinemaCity.fromJson(res.data()!);

      for (var element in cinemaCity.cgv!) {
        element.distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, element.lat, element.long);
      }
      cinemaCity.cgv!.sort(
        (a, b) => a.distance!.compareTo(b.distance!),
      );

      for (var element in cinemaCity.galaxy!) {
        element.distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, element.lat, element.long);
      }
      cinemaCity.galaxy!.sort(
        (a, b) => a.distance!.compareTo(b.distance!),
      );

      for (var element in cinemaCity.lotte!) {
        element.distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, element.lat, element.long);
      }
      cinemaCity.lotte!.sort(
        (a, b) => a.distance!.compareTo(b.distance!),
      );

      cinemaCity.all = cinemaCity.cgv!.sublist(0) +
          cinemaCity.galaxy!.sublist(0) +
          cinemaCity.lotte!.sublist(0);

      cinemaCity.all!.sort(
        (a, b) => a.distance!.compareTo(b.distance!),
      );

      return cinemaCity;
    } catch (e) {
      debugLog("getCinemasRecommended: ${e.toString()}");
      rethrow;
    }
  }

  Future<String> getCurrentCity(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      debugLog(placemarks.first.toString());

      if (placemarks.isNotEmpty) {
        String? cityName = placemarks[0].administrativeArea;
        CacheService.saveData(AppKey.cityName, cityName);
        return cityName ?? "";
      } else {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CinemaCity> getAllCinemasShowingMovie(
      {required String city,
      required String movieID,
      required String date,
      required BuildContext context}) async {
    try {
      Position? position;
      _serviceEnabled = await _location.serviceEnabled();
      _permissionGranted = await _location.hasPermission();

      if(_serviceEnabled && _permissionGranted == Location.PermissionStatus.granted){
        position = await _locationRepo.determinePosition(context);
      }

      final res = await _firestore.collection("Cinemas").doc(city).get();
      CinemaCity cinemaCity = CinemaCity.fromJson(res.data()!);

      for (var element in cinemaCity.cgv!) {
        element.movieShowinginCinema = await getMovieTimeAtCinema(
            cinema: element, cityName: city, date: date, movieID: movieID);
        if(position != null){
          element.distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, element.lat, element.long);
        }
      }

      for (var element in cinemaCity.galaxy!) {
        element.movieShowinginCinema = await getMovieTimeAtCinema(
            cinema: element, cityName: city, date: date, movieID: movieID);
        if(position != null){
          element.distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, element.lat, element.long);
        }
      }

      for (var element in cinemaCity.lotte!) {
        element.movieShowinginCinema = await getMovieTimeAtCinema(
            cinema: element, cityName: city, date: date, movieID: movieID);
        if(position != null){
          element.distance = Geolocator.distanceBetween(
            position.latitude, position.longitude, element.lat, element.long);
        }
      }

      cinemaCity.cgv = cinemaCity.cgv!
          .where((element) => element.movieShowinginCinema!.isNotEmpty)
          .toList();
      cinemaCity.lotte = cinemaCity.lotte!
          .where((element) => element.movieShowinginCinema!.isNotEmpty)
          .toList();
      cinemaCity.galaxy = cinemaCity.galaxy!
          .where((element) => element.movieShowinginCinema!.isNotEmpty)
          .toList();

      if(position != null){
        cinemaCity.cgv!.sort(
          (a, b) => a.distance!.compareTo(b.distance!),
        );
        cinemaCity.galaxy!.sort(
          (a, b) => a.distance!.compareTo(b.distance!),
        );
        cinemaCity.lotte!.sort(
          (a, b) => a.distance!.compareTo(b.distance!),
        );
      }
      

      cinemaCity.all = cinemaCity.cgv!.sublist(0) +
          cinemaCity.galaxy!.sublist(0) +
          cinemaCity.lotte!.sublist(0);

      if(position != null){
        cinemaCity.all!.sort(
          (a, b) => a.distance!.compareTo(b.distance!),
        );
      }

      return cinemaCity;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieShowinginCinema>> getMovieTimeAtCinema(
      {required Cinema cinema,
      required String cityName,
      required String date,
      required String movieID}) async {
    List<MovieShowinginCinema> movieShowinginCinema = [];
    try {
      final res = await _firestore
          .collection("Cinemas")
          .doc(cityName)
          .collection(cinema.type.name)
          .doc(cinema.id)
          .collection(date)
          .doc(movieID)
          .get();
      if (res.exists) {
        movieShowinginCinema.add(MovieShowinginCinema.fromJson(res.data()!));
        if (movieShowinginCinema[0].subtitle_2D != null) {
          movieShowinginCinema[0].subtitle_2D = movieShowinginCinema[0]
              .subtitle_2D!
              .where((element) => isValidShowtimes(
                    element.time,
                    DateTime(
                      int.parse(date.substring(6)),
                      int.parse(date.substring(3, 5)),
                      int.parse(
                        date.substring(0, 2),
                      ),
                    ),
                  ))
              .toList();
        }
        if (movieShowinginCinema[0].voice_2D != null) {
          movieShowinginCinema[0].voice_2D = movieShowinginCinema[0]
              .voice_2D!
              .where((element) => isValidShowtimes(
                    element.time,
                    DateTime(
                      int.parse(date.substring(6)),
                      int.parse(date.substring(3, 5)),
                      int.parse(
                        date.substring(0, 2),
                      ),
                    ),
                  ))
              .toList();
        }
        if (movieShowinginCinema[0].subtitle_3D != null) {
          movieShowinginCinema[0].subtitle_3D = movieShowinginCinema[0]
              .subtitle_3D!
              .where((element) => isValidShowtimes(
                    element.time,
                    DateTime(
                      int.parse(date.substring(6)),
                      int.parse(date.substring(3, 5)),
                      int.parse(
                        date.substring(0, 2),
                      ),
                    ),
                  ))
              .toList();
        }
        if (movieShowinginCinema[0].voice_3D != null) {
          movieShowinginCinema[0].voice_3D = movieShowinginCinema[0]
              .voice_3D!
              .where((element) => isValidShowtimes(
                    element.time,
                    DateTime(
                      int.parse(date.substring(6)),
                      int.parse(date.substring(3, 5)),
                      int.parse(
                        date.substring(0, 2),
                      ),
                    ),
                  ))
              .toList();
        }
      }
      return movieShowinginCinema;
    } catch (e) {
      rethrow;
    }
  }
}
