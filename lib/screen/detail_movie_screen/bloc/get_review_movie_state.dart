
import 'package:ticket_app/models/review.dart';

class GetReviewMovieState {
  bool? isLoading;
  Object? error;
  List<Review>? reviews;

  GetReviewMovieState({this.error, this.isLoading , this.reviews});
}