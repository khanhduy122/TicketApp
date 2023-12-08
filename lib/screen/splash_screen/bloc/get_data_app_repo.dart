import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ticket_app/models/banner.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/home_data.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/moduels/get_cinema_by_city/get_cinema_by_city_exception.dart';

class GetDataAppRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<HomeData> getMovieApp() async {
    List<Banner> homeBanner = [];
    List<Movie> homeNowShowing = [];
    List<Movie> homeComingSoon = [];

    final banner = await _firestore.collection("Banner").get();
    for (var element in banner.docs) {
      homeBanner.add(Banner.fromJson(element.data()));
    }

    final nowShowing = await _firestore.collection("Now Showing").get();
    for (var element in nowShowing.docs) {
      Movie movie = Movie.fromJson(element.data());
      movie.reviews = await getReviewMovie(movieID: movie.id);
      homeNowShowing.add(movie);
    }

    final comingSoon = await _firestore.collection("Coming Soon").get();
    for (var element in comingSoon.docs) {
      homeComingSoon.add(Movie.fromJson(element.data()));
    }

    return HomeData(
        banners: homeBanner,
        nowShowing: homeNowShowing,
        comingSoon: homeComingSoon);
  }

  Future<List<Review>> getReviewMovie({required String movieID}) async {
    List<Review> reviews = [];
    final res = await _firestore
        .collection("Now Showing")
        .doc(movieID)
        .collection("reviews")
        .orderBy("timestamp", descending: true)
        .limit(10)
        .get();
    for (var element in res.docs) {
      reviews.add(Review.fromJson(element.data()));
    }
    return reviews;
  }

  Future<CinemaCity> getCinemasRecommended() async {
    Position position = await _determinePosition();
    String cityName =
        await getCurrentCity(position.latitude, position.longitude);
    final res = await _firestore.collection("data_app").doc(cityName).get();
    CinemaCity cinemaCity = CinemaCity.fromJson(res.data()!);

    for (var element in cinemaCity.cgv!) {
      element.distance = Geolocator.distanceBetween(
          position.latitude, position.longitude, element.lat!, element.long!);
    }
    cinemaCity.cgv!.sort(
      (a, b) => a.distance!.compareTo(b.distance!),
    );

    for (var element in cinemaCity.galaxy!) {
      element.distance = Geolocator.distanceBetween(
          position.latitude, position.longitude, element.lat!, element.long!);
    }
    cinemaCity.galaxy!.sort(
      (a, b) => a.distance!.compareTo(b.distance!),
    );

    for (var element in cinemaCity.lotte!) {
      element.distance = Geolocator.distanceBetween(
          position.latitude, position.longitude, element.lat!, element.long!);
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
  }

  Future<String> getCurrentCity(double lat, double long) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

      if (placemarks.isNotEmpty) {
        Placemark firstPlacemark = placemarks.first;
        String city = firstPlacemark.administrativeArea ?? "";
        return city;
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception();
    }
  }

  Future<Position> _determinePosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openAppSettings().then((isServiceEnabled) {
          if (!isServiceEnabled) {
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
