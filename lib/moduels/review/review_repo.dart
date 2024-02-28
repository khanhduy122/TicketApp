import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/models/ticket.dart';

class ReviewRepo {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  DocumentSnapshot? _docLast;

  Future<List<Review>> getAllReview(
      {required String id, required bool isLoadMore}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if (isLoadMore == false) {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").orderBy("timestamp", descending: true).limit(10).get();
      } else {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").orderBy("timestamp", descending: true).startAfterDocument(_docLast!).limit(10).get();
      }

      if(res.docs.isEmpty) return reviews;

      _docLast = res.docs[res.size - 1];
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }

      return reviews;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Review>> getReviewWithPicture(
      {required String id, required bool isLoadMore}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if (isLoadMore == false) {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where("images", isNull: false).orderBy("images").orderBy("timestamp", descending: true).limit(10).get();
      } else {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where("images", isNull: false).orderBy("images").orderBy("timestamp", descending: true).startAfterDocument(_docLast!).limit(10).get();
      }

      if(res.docs.isEmpty) return reviews;

      _docLast = res.docs[res.size - 1];
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }

      return reviews;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Review>> getOneRating(
      {required String id, required bool isLoadMore}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if (isLoadMore == false) {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where('rating', isEqualTo: 1).orderBy("timestamp", descending: true).limit(10).get();
      } else {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where('rating', isEqualTo: 1).orderBy("timestamp", descending: true).startAfterDocument(_docLast!).limit(10).get();
      }
      if(res.docs.isEmpty) return reviews;

      _docLast = res.docs[res.size - 1];
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }

      return reviews;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Review>> getTwoRating(
      {required String id, required bool isLoadMore}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if (isLoadMore == false) {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where('rating', isEqualTo: 2).orderBy("timestamp", descending: true).limit(10).get();
      } else {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where('rating', isEqualTo: 2).orderBy("timestamp", descending: true).startAfterDocument(_docLast!).limit(10).get();
      }
      if(res.docs.isEmpty) return reviews;

      _docLast = res.docs[res.size - 1];
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }

      return reviews;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Review>> getThreeRating(
      {required String id, required bool isLoadMore}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if (isLoadMore == false) {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where('rating', isEqualTo: 3).orderBy("timestamp", descending: true).limit(10).get();
      } else {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where('rating', isEqualTo: 3).orderBy("timestamp", descending: true).startAfterDocument(_docLast!).limit(10).get();
      }
      if(res.docs.isEmpty) return reviews;

      _docLast = res.docs[res.size - 1];
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }

      return reviews;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Review>> getFourRating(
      {required String id, required bool isLoadMore}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if (isLoadMore == false) {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where('rating', isEqualTo: 4).orderBy("timestamp", descending: true).limit(10).get();
      } else {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where('rating', isEqualTo: 4).orderBy("timestamp", descending: true).startAfterDocument(_docLast!).limit(10).get();
      }

      if(res.docs.isEmpty) return reviews;
      
      _docLast = res.docs[res.size - 1];
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }

      return reviews;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Review>> getFiveRating(
      {required String id, required bool isLoadMore}) async {
    try {
      List<Review> reviews = [];
      final QuerySnapshot<Map<String, dynamic>>? res;

      if (isLoadMore == false) {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where('rating', isEqualTo: 5).orderBy("timestamp", descending: true).limit(10).get();
      } else {
        res = await _firebaseFirestore.collection("Now Showing").doc(id).collection("Reviews").where('rating', isEqualTo: 5).orderBy("timestamp", descending: true).startAfterDocument(_docLast!).limit(10).get();
      }

      if(res.docs.isEmpty) return reviews;

      _docLast = res.docs[res.size - 1];
      for (var element in res.docs) {
        reviews.add(Review.fromJson(element.data()));
      }

      return reviews;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addReview({required Ticket ticket, String? contentReview, required int rating, List<File>? images}) async {

    List<String> imagesUrl = await uploadImageReview(ticket, images!);

    try {
      await _firebaseFirestore.collection("Now Showing").doc(ticket.movie!.id).collection("Reviews").doc(ticket.id).set(
        {
          'id': ticket.id,
          "userName": FirebaseAuth.instance.currentUser!.displayName,
          "content": contentReview,
          "rating": rating,
          "images": imagesUrl.isEmpty ? null : imagesUrl,
          "userPhoto": FirebaseAuth.instance.currentUser!.photoURL ?? "",
          "timestamp": DateTime.now().millisecondsSinceEpoch
        }
      );
      final response = await _firebaseFirestore.collection("Now Showing").doc(ticket.movie!.id).get();
      Movie movie = Movie.fromJson(response.data()!);
      movie.totalReview = movie.totalReview! + 1;
      movie.totalOneRating = rating == 1 ? movie.totalOneRating! + 1 : movie.totalOneRating;
      movie.totalTwoRating = rating == 2 ? movie.totalTwoRating! + 1 : movie.totalTwoRating;
      movie.totalThreeRating = rating == 3 ? movie.totalThreeRating! + 1 : movie.totalThreeRating;
      movie.totalFourRating = rating == 4 ? movie.totalFourRating! + 1 : movie.totalFourRating;
      movie.totalFiveRating = rating == 5 ? movie.totalFiveRating! + 1 : movie.totalFiveRating;
      movie.totalRatingWithPicture = imagesUrl.isNotEmpty ? movie.totalRatingWithPicture! + 1 : movie.totalRatingWithPicture;
      movie.rating = (movie.totalOneRating! + movie.totalTwoRating! * 2 + movie.totalThreeRating! * 3 + movie.totalFourRating! * 4 + movie.totalFiveRating! * 5) / movie.totalReview!;

      await _firebaseFirestore.collection("Now Showing").doc(ticket.movie!.id).update(
        {
          "total_review": movie.totalReview!,
          "total_one_rating": movie.totalOneRating,
          "total_two_rating": movie.totalTwoRating,
          "total_three_rating": movie.totalThreeRating,
          "total_four_rating": movie.totalFourRating,
          "total_five_rating": movie.totalFiveRating,
          "total_rating_picture": movie.totalRatingWithPicture,
          "rating": movie.rating,
        }
      );

      await _firebaseFirestore.collection("User").doc(FirebaseAuth.instance.currentUser!.uid).collection("ExpiredTickets").doc(ticket.id).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> uploadImageReview(Ticket ticket ,List<File> imagesFile) async {
    List<String> downloadUrl = [];
    int index = 0;
    try {
      for (var image in imagesFile) {
        String fileName = "${++index}";
        Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('Now Showing/${ticket.movie!.id}/Reviews/${ticket.id}/$fileName');
        UploadTask uploadTask = firebaseStorageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();
        downloadUrl.add(url);
      }
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

}
