
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cinema_city.dart';

class CinemaState {}

class GetCinemasCityState extends CinemaState{
  bool? isLoading;
  CinemaCity? cinemaCity;
  Object? error;

  GetCinemasCityState({this.error, this.isLoading, this.cinemaCity});
}

class GetAllMovieReleasedCinemaState extends CinemaState{
  bool? isLoading;
  Cinema? cinema;
  Object? error;

  GetAllMovieReleasedCinemaState({this.error, this.isLoading, this.cinema});
}

class GetCinemasShowingMovieState extends CinemaState{
  bool? isLoading;
  CinemaCity? cinemaCity;
  Object? error;

  GetCinemasShowingMovieState({this.error, this.isLoading, this.cinemaCity});
}
