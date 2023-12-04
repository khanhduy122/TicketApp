
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/screen/auth_screen/blocs/auth_exception.dart';

class GetReviewMovieRepositories {

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Review>> getAllReview({required String id, required int currentIndex}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if(currentIndex == 0){
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").orderBy("timestamp", descending: true).limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      else{
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").orderBy("timestamp", descending: true).limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }
      
      return reviews;
    } catch (e) {
      rethrow;
    }
    
  }

  Future<List<Review>> getReviewWithPicture({required String id, required int currentIndex}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if(currentIndex == 0){
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").where("photoReview", isNull: false).orderBy("photoReview",).orderBy("timestamp", descending: true).limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      else{
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }
      
      return reviews;
    } catch (e) {
      rethrow;
    }
    
  }

  Future<List<Review>> getOneRating({required String id, required int currentIndex}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if(currentIndex == 0){
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").where('rating', isEqualTo: 1).orderBy("timestamp", descending: true).limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      else{
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").orderBy("timestamp", descending: true).limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }
      
      return reviews;
    } catch (e) {
      rethrow;
    }
    
  }

  Future<List<Review>> getTwoRating({required String id, required int currentIndex}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if(currentIndex == 0){
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").where('rating', isEqualTo: 2).orderBy("timestamp", descending: true).limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      else{
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }
      
      return reviews;
    } catch (e) {
      rethrow;
    }
    
  }

  Future<List<Review>> getThreeRating({required String id, required int currentIndex}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if(currentIndex == 0){
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").where('rating', isEqualTo: 3).orderBy("timestamp", descending: true).limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      else{
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }
      
      return reviews;
    } catch (e) {
      rethrow;
    }
    
  }

  Future<List<Review>> getFourRating({required String id, required int currentIndex}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if(currentIndex == 0){
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").where('rating', isEqualTo: 4).orderBy("timestamp", descending: true).limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      else{
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").orderBy("timestamp", descending: true).limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }
      
      return reviews;
    } catch (e) {
      rethrow;
    }
    
  }

  Future<List<Review>> getFiveRating({required String id, required int currentIndex}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if(currentIndex == 0){
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").where('rating', isEqualTo: 5).orderBy("timestamp", descending: true).limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      else{
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("reviews").orderBy("timestamp", descending: true).limit(10).get().timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeOutException();
          },
        );
      }
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }
      
      return reviews;
    } catch (e) {
      rethrow;
    }
    
  }

}