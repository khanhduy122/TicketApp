// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_showing_in_cinema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieShowinginCinema _$MovieShowinginCinemaFromJson(
        Map<String, dynamic> json) =>
    MovieShowinginCinema(
      movie: Movie.fromJson(json['movie'] as Map<String, dynamic>),
      subtitle_2D: (json['subtitle_2D'] as List<dynamic>?)
          ?.map((e) => MovieTimes.fromJson(e as Map<String, dynamic>))
          .toList(),
      voice_2D: (json['voice_2D'] as List<dynamic>?)
          ?.map((e) => MovieTimes.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtitle_3D: (json['subtitle_3D'] as List<dynamic>?)
          ?.map((e) => MovieTimes.fromJson(e as Map<String, dynamic>))
          .toList(),
      voice_3D: (json['voice_3D'] as List<dynamic>?)
          ?.map((e) => MovieTimes.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MovieShowinginCinemaToJson(
        MovieShowinginCinema instance) =>
    <String, dynamic>{
      'movie': instance.movie,
      'subtitle_2D': instance.subtitle_2D,
      'voice_2D': instance.voice_2D,
      'subtitle_3D': instance.subtitle_3D,
      'voice_3D': instance.voice_3D,
    };
