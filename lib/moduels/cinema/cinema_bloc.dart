import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/components/const/net_work_info.dart';
import 'package:ticket_app/moduels/cinema/cinema_event.dart';
import 'package:ticket_app/moduels/cinema/cinema_repo.dart';
import 'package:ticket_app/moduels/cinema/cinema_state.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';

class CinemaBloc extends Bloc<CinemaEvent, CinemaState> {
  final CinemaRepo _cinemasRepo = CinemaRepo();

  CinemaBloc() : super(CinemaState()) {
    on<GetCinemaCityEvent>((event, emit) => _getCinemaCity(event, emit));

    on<GetAllMovieReleasedCinemaEvent>(
        (event, emit) => _getAllMovieReleasedCinema(event, emit));

    on<GetCinemasShowingMovieEvent>(
        (event, emit) => _getCinemasShowingMovie(event, emit));
  }

  void _getCinemaCity(GetCinemaCityEvent event, Emitter emit) async {
    emit(GetCinemasCityState(isLoading: true));
    try {
      if (await NetWorkInfo.isConnectedToInternet() == false) {
        emit(GetCinemasCityState(error: NoInternetException()));
        return;
      }
      final response =
          await _cinemasRepo.getCinemasCity(event.cityName, event.context);
      emit(GetCinemasCityState(cinemaCity: response));
    } catch (e) {
      emit(GetCinemasCityState(error: e));
    }
  }

  void _getAllMovieReleasedCinema(
      GetAllMovieReleasedCinemaEvent event, Emitter emit) async {
    emit(GetAllMovieReleasedCinemaState(isLoading: true));
    try {
      if (await NetWorkInfo.isConnectedToInternet() == false) {
        emit(GetAllMovieReleasedCinemaState(error: NoInternetException()));
        return;
      }

      final response = await _cinemasRepo.getAllMovieReleasedCinema(
          cityName: event.cinema.cityName,
          date: event.date,
          cinema: event.cinema);
      event.cinema.movieShowinginCinema = [];
      event.cinema.movieShowinginCinema!.insertAll(0, response);
      emit(GetAllMovieReleasedCinemaState(cinema: event.cinema));
    } catch (e) {
      emit(GetAllMovieReleasedCinemaState(error: e));
    }
  }

  void _getCinemasShowingMovie(
      GetCinemasShowingMovieEvent event, Emitter emit) async {
    emit(GetCinemasShowingMovieState(isLoading: true));
    try {
      if (await NetWorkInfo.isConnectedToInternet() == false) {
        emit(GetCinemasShowingMovieState(error: NoInternetException()));
        return;
      }

      final response = await _cinemasRepo.getAllCinemasShowingMovie(
          city: event.cityName,
          movieID: event.movieID,
          date: event.date,
          context: event.context);
      emit(GetCinemasShowingMovieState(cinemaCity: response));
    } catch (e) {
      emit(GetCinemasShowingMovieState(error: e));
    }
  }
}
