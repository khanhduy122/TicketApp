abstract class GetReviewMovieEvent {}

class GetInitReviewMovieEvent extends GetReviewMovieEvent {
  String id;
  int rating;

  GetInitReviewMovieEvent({required this.id, required this.rating});
}

class LoadMoreReviewMovieEvent extends GetReviewMovieEvent {
  String id;
  int rating;

  LoadMoreReviewMovieEvent({required this.id, required this.rating});
}
