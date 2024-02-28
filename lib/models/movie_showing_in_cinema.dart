
import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/movie_times.dart';
part 'movie_showing_in_cinema.g.dart';


@JsonSerializable()
class MovieShowinginCinema{
  final Movie movie;
  List<MovieTimes>? subtitle_2D;
  List<MovieTimes>? voice_2D;
  List<MovieTimes>? subtitle_3D;
  List<MovieTimes>? voice_3D;

  MovieShowinginCinema({required this.movie, required this.subtitle_2D, required this.voice_2D, required this.subtitle_3D, required this.voice_3D});

  factory MovieShowinginCinema.fromJson(Map<String, dynamic> json) => _$MovieShowinginCinemaFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'movie': movie.toJson(),
      'subtitle_2D': subtitle_2D?.map((time) => time.toJson()).toList(),
      'voice_2D': voice_2D?.map((time) => time.toJson()).toList(),
      'subtitle_3D': subtitle_3D?.map((time) => time.toJson()).toList(),
      'voice_3D': voice_3D?.map((time) => time.toJson()).toList(),
    };
  }

}