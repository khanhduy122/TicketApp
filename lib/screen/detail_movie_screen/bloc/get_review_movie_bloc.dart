import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/screen/detail_movie_screen/bloc/get_review_movie_event.dart';
import 'package:ticket_app/screen/detail_movie_screen/bloc/get_review_movie_repo.dart';
import 'package:ticket_app/screen/detail_movie_screen/bloc/get_review_movie_state.dart';

class GetReviewMovieBloc
    extends Bloc<GetReviewMovieEvent, GetReviewMovieState> {
  final GetReviewMovieRepositories _getReviewMovieRepositories =
      GetReviewMovieRepositories();

  GetReviewMovieBloc() : super(GetReviewMovieState()) {
    on<GetInitReviewMovieEvent>(
        (event, emit) => _getAllReviewMovieEvnet(event, emit));

    on<LoadMoreReviewMovieEvent>(
        (event, emit) => _loadMoreReviewMovieEvent(event, emit));
  }

  void _getAllReviewMovieEvnet(
      GetInitReviewMovieEvent event, Emitter emit) async {
    try {
      List<Review> reviews = [];
      emit(GetInitReviewMovieState(isLoading: true));

      switch (event.rating) {
        case 0:
          reviews = await _getReviewMovieRepositories.getAllReview(
              id: event.id, isLoadMore: false);
          break;

        case 1:
          reviews = await _getReviewMovieRepositories.getReviewWithPicture(
              id: event.id, isLoadMore: false);
          break;

        case 2:
          reviews = await _getReviewMovieRepositories.getFiveRating(
              id: event.id, isLoadMore: false);
          break;

        case 3:
          reviews = await _getReviewMovieRepositories.getFourRating(
              id: event.id, isLoadMore: false);
          break;

        case 4:
          reviews = await _getReviewMovieRepositories.getThreeRating(
              id: event.id, isLoadMore: false);
          break;

        case 5:
          reviews = await _getReviewMovieRepositories.getTwoRating(
              id: event.id, isLoadMore: false);
          break;

        case 6:
          reviews = await _getReviewMovieRepositories.getOneRating(
              id: event.id, isLoadMore: false);
      }

      emit(GetInitReviewMovieState(reviews: reviews));
    } catch (e) {
      emit(GetInitReviewMovieState(error: e));
    }
  }

  void _loadMoreReviewMovieEvent(
      LoadMoreReviewMovieEvent event, Emitter emit) async {
    try {
      List<Review> reviews = [];
      emit(LoadMoreReviewMovieState(isLoading: true));

      switch (event.rating) {
        case 0:
          reviews = await _getReviewMovieRepositories.getAllReview(
              id: event.id, isLoadMore: true);
          break;

        case 1:
          reviews = await _getReviewMovieRepositories.getReviewWithPicture(
              id: event.id, isLoadMore: true);
          break;

        case 2:
          reviews = await _getReviewMovieRepositories.getFiveRating(
              id: event.id, isLoadMore: true);
          break;

        case 3:
          reviews = await _getReviewMovieRepositories.getFourRating(
              id: event.id, isLoadMore: true);
          break;

        case 4:
          reviews = await _getReviewMovieRepositories.getThreeRating(
              id: event.id, isLoadMore: true);
          break;

        case 5:
          reviews = await _getReviewMovieRepositories.getTwoRating(
              id: event.id, isLoadMore: true);
          break;

        case 6:
          reviews = await _getReviewMovieRepositories.getOneRating(
              id: event.id, isLoadMore: true);
      }

      emit(LoadMoreReviewMovieState(reviews: reviews));
    } catch (e) {
      emit(LoadMoreReviewMovieState(error: e));
    }
  }
}
