
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/moduels/get_cinema_in_city/get_cinema_in_city_event.dart';
import 'package:ticket_app/moduels/get_cinema_in_city/get_cinema_in_city_repo.dart';
import 'package:ticket_app/moduels/get_cinema_in_city/get_cinema_in_city_state.dart';

class GetCinemasBloc extends Bloc<GetCinemaEvent, GetCinemasState>{

  final GetCinemasRepo _getCinemasRepo = GetCinemasRepo();

  GetCinemasBloc() : super(GetCinemasState()){
    on<GetCinemasInCityEvent>((event, emit) async {
      try {
        emit(GetCinemasCityState(isLoading: true));
        final res = await _getCinemasRepo.getCinemasByCity(event.cityName);
        emit(GetCinemasCityState(cinemaCity: res));
      } catch (e) {
        emit(GetCinemasCityState(error: e));
      }
    });

    on<GetCinemasForMovieEvent>((event, emit) async {
      try {
        emit(GetCinemasForMovieState(isLoading: true));
        final res = await _getCinemasRepo.getCinemasForMovie(city: event.cityName, movieID: event.movieID, date: event.date);
        emit(GetCinemasForMovieState(cinemaCity: res));
      } catch (e) {
        emit(GetCinemasForMovieState(error: e));
      }
    });

    on<GetAllMovieCinemaEvent>((event, emit) async {
      try {
        emit(GetAllMovieCinemaState(isLoading: true));
        final response = await _getCinemasRepo.getAllMovieCinema(cinema: event.cinema, cityName: event.cityName, date: event.date,);
        event.cinema.movies = response.sublist(0);
        emit(GetAllMovieCinemaState(cinema: event.cinema));
      } catch (e) {
        emit(GetAllMovieCinemaState(error: e));
      }
    });
  }
}