
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cinema_city.dart';

abstract class GetCinemaEvent{}

class GetCinemasInCityEvent extends GetCinemaEvent{
  String cityName;

  GetCinemasInCityEvent({required this.cityName});
}

class GetAllMovieCinemaEvent extends GetCinemaEvent{
  String cityName;
  Cinema cinema;
  String date;

  GetAllMovieCinemaEvent({required this.cinema, required this.cityName, required this.date});
}

class GetCinemasForMovieEvent extends GetCinemaEvent{
  String cityName;
  String movieID;
  String date;

  GetCinemasForMovieEvent({required this.cityName, required this.movieID, required this.date});
}
