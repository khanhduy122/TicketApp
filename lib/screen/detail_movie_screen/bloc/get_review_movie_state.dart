import 'package:ticket_app/models/review.dart';

class GetReviewMovieState {}

class GetInitReviewMovieState extends GetReviewMovieState {
  bool? isLoading;
  Object? error;
  List<Review>? reviews;

  GetInitReviewMovieState({this.error, this.isLoading, this.reviews});
}

class LoadMoreReviewMovieState extends GetReviewMovieState {
  bool? isLoading;
  Object? error;
  List<Review>? reviews;

  LoadMoreReviewMovieState({this.error, this.isLoading, this.reviews});
}
