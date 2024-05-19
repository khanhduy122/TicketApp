import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/components/const/net_work_info.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/moduels/review/review_event.dart';
import 'package:ticket_app/moduels/review/review_repo.dart';
import 'package:ticket_app/moduels/review/review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepo _reviewRepo = ReviewRepo();

  ReviewBloc() : super(ReviewState()) {
    on<GetInitReviewMovieEvent>(
        (event, emit) => _getAllReviewMovieEvnet(event, emit));

    on<LoadMoreReviewMovieEvent>(
        (event, emit) => _loadMoreReviewMovieEvent(event, emit));

    on<AddReviewEvent>((event, emit) => _addReviewEvent(event, emit));
  }

  void _getAllReviewMovieEvnet(
      GetInitReviewMovieEvent event, Emitter emit) async {
    try {
      List<Review> reviews = [];
      emit(GetInitReviewMovieState(isLoading: true));

      if (await NetWorkInfo.isConnectedToInternet() == false) {
        emit(GetInitReviewMovieState(error: NoInternetException()));
        return;
      }

      switch (event.rating) {
        case 0:
          reviews = await _reviewRepo
              .getAllReview(id: event.id, isLoadMore: false)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 1:
          reviews = await _reviewRepo
              .getReviewWithPicture(id: event.id, isLoadMore: false)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 2:
          reviews = await _reviewRepo
              .getFiveRating(id: event.id, isLoadMore: false)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 3:
          reviews = await _reviewRepo
              .getFourRating(id: event.id, isLoadMore: false)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 4:
          reviews = await _reviewRepo
              .getThreeRating(id: event.id, isLoadMore: false)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 5:
          reviews = await _reviewRepo
              .getTwoRating(id: event.id, isLoadMore: false)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 6:
          reviews = await _reviewRepo
              .getOneRating(id: event.id, isLoadMore: false)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;
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

      if (await NetWorkInfo.isConnectedToInternet() == false) {
        emit(LoadMoreReviewMovieState(error: NoInternetException()));
        return;
      }

      switch (event.rating) {
        case 0:
          reviews = await _reviewRepo
              .getAllReview(id: event.id, isLoadMore: true)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 1:
          reviews = await _reviewRepo
              .getReviewWithPicture(id: event.id, isLoadMore: true)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 2:
          reviews = await _reviewRepo
              .getFiveRating(id: event.id, isLoadMore: true)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 3:
          reviews = await _reviewRepo
              .getFourRating(id: event.id, isLoadMore: true)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 4:
          reviews = await _reviewRepo
              .getThreeRating(id: event.id, isLoadMore: true)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 5:
          reviews = await _reviewRepo
              .getTwoRating(id: event.id, isLoadMore: true)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
          break;

        case 6:
          reviews = await _reviewRepo
              .getOneRating(id: event.id, isLoadMore: true)
              .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Timeout');
            },
          );
      }

      emit(LoadMoreReviewMovieState(reviews: reviews));
    } catch (e) {
      emit(LoadMoreReviewMovieState(error: e));
    }
  }

  void _addReviewEvent(AddReviewEvent event, Emitter emit) async {
    emit(AddReviewState(isLoading: true));
    try {
      if (await NetWorkInfo.isConnectedToInternet() == false) {
        emit(AddReviewState(error: NoInternetException()));
        return;
      }

      await _reviewRepo
          .addReview(
              ticket: event.ticket,
              rating: event.rating,
              contentReview: event.contentReview,
              images: event.images)
          .timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Timeout');
        },
      );
      emit(AddReviewState(isSuccess: true));
    } catch (e) {
      emit(AddReviewState(error: e));
    }
  }
}
