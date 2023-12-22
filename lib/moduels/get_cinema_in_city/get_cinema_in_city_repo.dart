

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/moduels/get_cinema_in_city/get_cinema_in_city_exception.dart';
import 'package:ticket_app/screen/auth_screen/blocs/auth_exception.dart';

class GetCinemasRepo {

  final FirebaseFirestore _firestore =FirebaseFirestore.instance;

  Future<CinemaCity> getCinemasByCity(String city)async{
    try {
      Position position = await _determinePosition();
      final res = await _firestore.collection("Cinemas").doc(city).get().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeOutException();
        },
      );
      CinemaCity cinemaCity = CinemaCity.fromJson(res.data()!);

      for (var element in cinemaCity.cgv!) {
        element.distance = Geolocator.distanceBetween(position.latitude, position.longitude, element.lat!, element.long!);
      }

      for (var element in cinemaCity.galaxy!) {
        element.distance = Geolocator.distanceBetween(position.latitude, position.longitude, element.lat!, element.long!);
      }

      for (var element in cinemaCity.lotte!) {
        element.distance = Geolocator.distanceBetween(position.latitude, position.longitude, element.lat!, element.long!);
      }
      
      cinemaCity.cgv!.sort((a, b) => a.distance!.compareTo(b.distance!),);
      cinemaCity.galaxy!.sort((a, b) => a.distance!.compareTo(b.distance!),);
      cinemaCity.lotte!.sort((a, b) => a.distance!.compareTo(b.distance!),);

      cinemaCity.all = cinemaCity.cgv!.sublist(0) + cinemaCity.galaxy!.sublist(0) + cinemaCity.lotte!.sublist(0);
      cinemaCity.all!.sort((a, b) => a.distance!.compareTo(b.distance!),);

      return cinemaCity;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Movie>> getAllMovieCinema({required Cinema cinema, required String cityName, required String date}) async {
    List<Movie> movies = [];
    try {
      final res = await _firestore.collection("Cinemas").doc(cityName).collection(cinema.cinemasType!.name).doc(cinema.id).collection(date).get();
      for (var element in res.docs) {
        movies.add(Movie.fromJson(element.data()));
      }
    } catch (e) {
      rethrow;
    }
    return movies;
  }

  Future<CinemaCity> getCinemasForMovie({required String city, required String movieID, required String date})async{
    try {
      Position position = await _determinePosition();
      final res = await _firestore.collection("Cinemas").doc(city).get().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeOutException();
        },
      );
      CinemaCity cinemaCity = CinemaCity.fromJson(res.data()!);

      for (var element in cinemaCity.cgv!) {
        element.movies = await getCinemaNowShowingMovie(cinema: element, cityName: city, date: date, movieID: movieID);
        element.distance = Geolocator.distanceBetween(position.latitude, position.longitude, element.lat!, element.long!);
      }

      for (var element in cinemaCity.galaxy!) {
        element.movies = await getCinemaNowShowingMovie(cinema: element, cityName: city, date: date, movieID: movieID);
        element.distance = Geolocator.distanceBetween(position.latitude, position.longitude, element.lat!, element.long!);
      }

      for (var element in cinemaCity.lotte!) {
        element.movies = await getCinemaNowShowingMovie(cinema: element, cityName: city, date: date, movieID: movieID);
        element.distance = Geolocator.distanceBetween(position.latitude, position.longitude, element.lat!, element.long!);
      }
      
      cinemaCity.cgv = cinemaCity.cgv!.where((element) => element.movies!.isNotEmpty).toList();
      cinemaCity.lotte = cinemaCity.lotte!.where((element) => element.movies!.isNotEmpty).toList();
      cinemaCity.galaxy = cinemaCity.galaxy!.where((element) => element.movies!.isNotEmpty).toList();

      cinemaCity.cgv!.sort((a, b) => a.distance!.compareTo(b.distance!),);
      cinemaCity.galaxy!.sort((a, b) => a.distance!.compareTo(b.distance!),);
      cinemaCity.lotte!.sort((a, b) => a.distance!.compareTo(b.distance!),);

      cinemaCity.all = cinemaCity.cgv!.sublist(0) + cinemaCity.galaxy!.sublist(0) + cinemaCity.lotte!.sublist(0);
      cinemaCity.all!.sort((a, b) => a.distance!.compareTo(b.distance!),);

      return cinemaCity;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Movie>> getCinemaNowShowingMovie({required Cinema cinema, required String cityName, required String date, required String movieID}) async{
    List<Movie> movies = [];
    try {
      final res = await _firestore.collection("Cinemas").doc(cityName).collection(cinema.cinemasType!.name).doc(cinema.id!).collection(date).doc(movieID).get().timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeOutException();
        }
      );
      if(res.exists){
        movies.add(Movie.fromJson(res.data()!));
      }
      return movies;
    } catch (e) {
      rethrow;
    }
  }


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
      print("_determinePosition:$e");
      rethrow;
    }
  }


}