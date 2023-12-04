
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/screen/detail_movie_screen/bloc/get_review_movie_event.dart';
import 'package:ticket_app/screen/detail_movie_screen/bloc/get_review_movie_repo.dart';
import 'package:ticket_app/screen/detail_movie_screen/bloc/get_review_movie_state.dart';

class GetReviewMovieBloc extends Bloc<GetReviewMovieEvent, GetReviewMovieState>{
  
  final GetReviewMovieRepositories _getReviewMovieRepositories = GetReviewMovieRepositories();

  GetReviewMovieBloc() : super(GetReviewMovieState()){
    on<GetReviewMovieEvent>((event, emit) => _getAllReviewMovieEvnet(event, emit));
  }

  void _getAllReviewMovieEvnet(GetReviewMovieEvent event, Emitter emit) async {
    try {
      List<Review> reviews = [];
      emit(GetReviewMovieState(isLoading: true));

      switch(event.rating){
        case 0: reviews = await _getReviewMovieRepositories.getAllReview(id: event.id, currentIndex: event.currentIndex);
          break;

        case 1: reviews = await _getReviewMovieRepositories.getOneRating(id: event.id, currentIndex: event.currentIndex);
          break;

        case 2: reviews = await _getReviewMovieRepositories.getTwoRating(id: event.id, currentIndex: event.currentIndex);
          break;

        case 3: reviews = await _getReviewMovieRepositories.getThreeRating(id: event.id, currentIndex: event.currentIndex);
          break;

        case 4: reviews = await _getReviewMovieRepositories.getFourRating(id: event.id, currentIndex: event.currentIndex);
          break;

        case 5: reviews = await _getReviewMovieRepositories.getFiveRating(id: event.id, currentIndex: event.currentIndex);
          break;

        default: reviews = await _getReviewMovieRepositories.getReviewWithPicture(id: event.id, currentIndex: event.currentIndex);
      }

      emit(GetReviewMovieState(reviews: reviews));
    } catch (e) {
      emit(GetReviewMovieState(error: e));
    }
  }
}