import 'package:flutter/material.dart';
import 'package:ticket_app/models/cinema.dart';

abstract class CinemaEvent {}

class GetCinemaCityEvent extends CinemaEvent {
  String? cityName;
  BuildContext context;

  GetCinemaCityEvent({required this.cityName, required this.context});
}

class GetAllMovieReleasedCinemaEvent extends CinemaEvent {
  Cinema cinema;
  String date;
  BuildContext context;

  GetAllMovieReleasedCinemaEvent(
      {required this.cinema, required this.date, required this.context});
}

class GetCinemasShowingMovieEvent extends CinemaEvent {
  String cityName;
  String movieID;
  String date;
  BuildContext context;

  GetCinemasShowingMovieEvent(
      {required this.cityName,
      required this.movieID,
      required this.date,
      required this.context});
}
