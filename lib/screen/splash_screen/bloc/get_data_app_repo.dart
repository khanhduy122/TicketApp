import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/models/banner.dart';
import 'package:ticket_app/models/home_data.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/review.dart';

class GetDataAppRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<HomeData> getMovieApp() async {
    List<BannerHome> homeBanner = [];
    List<Movie> homeNowShowing = [];
    List<Movie> homeComingSoon = [];
    try {
      final banner = await _firestore.collection("Banner").get();
      for (var element in banner.docs) {
        homeBanner.add(BannerHome.fromJson(element.data()));
      }

      final nowShowing = await _firestore.collection("Now Showing").get();
      for (var element in nowShowing.docs) {
        Movie movie = Movie.fromJson(element.data());
        movie.reviews = await getReviewMovie(movieID: movie.id!);
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
    } catch (e) {
      debugLog("get Movie App: ${e.toString()}");
      return Future.error(e);
    }
  }

  Future<List<Review>> getReviewMovie({required String movieID}) async {
    List<Review> reviews = [];
    final res = await _firestore
        .collection("Now Showing")
        .doc(movieID)
        .collection("Reviews")
        .orderBy("timestamp", descending: true)
        .limit(10)
        .get();
    for (var element in res.docs) {
      reviews.add(Review.fromJson(element.data()));
    }
    return reviews;
  }
}
