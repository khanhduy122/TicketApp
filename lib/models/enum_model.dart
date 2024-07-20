import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Languages { voice, subtitle }

@JsonEnum()
// ignore: constant_identifier_names
enum Category {
  drama,
  romance,
  intense,
  comedy,
  science_fiction,
  adventure,
  act,
  fantasy,
  mentality,
  horrified,
  criminal
}

@JsonEnum()
enum TicketType { d2, d3 }

@JsonEnum()
enum Ban { c13, c16, c18, p }

@JsonEnum()
// ignore: constant_identifier_names
enum CinemasType { CGV, Lotte, Galaxy }

@JsonEnum()
enum TypeSeat { normal, vip, sweetBox }

@JsonEnum()
enum MovieType { movie2D, movie3D, movieIMAX }

MovieType stringToMovieType(String type) {
  switch (type) {
    case '2D':
      return MovieType.movie2D;
    case '3D':
      return MovieType.movie3D;
    case 'IMAX':
      return MovieType.movieIMAX;
  }
  return MovieType.movie2D;
}
