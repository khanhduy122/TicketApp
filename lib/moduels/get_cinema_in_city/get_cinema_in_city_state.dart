
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/movie.dart';

class GetCinemasState{}

class GetCinemasCityState extends GetCinemasState{
  bool? isLoading;
  CinemaCity? cinemaCity;
  Object? error;

  GetCinemasCityState({this.error, this.isLoading, this.cinemaCity});
}

class GetAllMovieCinemaState extends GetCinemasState{
  bool? isLoading;
  Cinema? cinema;
  Object? error;

  GetAllMovieCinemaState({this.error, this.isLoading, this.cinema});
}

class GetCinemasForMovieState extends GetCinemasState{
  bool? isLoading;
  CinemaCity? cinemaCity;
  Object? error;

  GetCinemasForMovieState({this.error, this.isLoading, this.cinemaCity});
}

