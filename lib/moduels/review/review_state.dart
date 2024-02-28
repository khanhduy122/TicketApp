import 'package:ticket_app/models/review.dart';

class ReviewState {}

class GetInitReviewMovieState extends ReviewState {
  bool? isLoading;
  Object? error;
  List<Review>? reviews;

  GetInitReviewMovieState({this.error, this.isLoading, this.reviews});
}

class LoadMoreReviewMovieState extends ReviewState {
  bool? isLoading;
  Object? error;
  List<Review>? reviews;

  LoadMoreReviewMovieState({this.error, this.isLoading, this.reviews});
}

class AddReviewState extends ReviewState {
  bool? isLoading;
  Object? error;
  bool? isSuccess;

  AddReviewState({this.isLoading, this.error, this.isSuccess});
}
