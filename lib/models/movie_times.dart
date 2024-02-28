

import 'package:json_annotation/json_annotation.dart';
part 'movie_times.g.dart';

@JsonSerializable()
class MovieTimes{
  final String time;
  final String roomID;

  MovieTimes({required this.roomID, required this.time});

  factory MovieTimes.fromJson(Map<String, dynamic> json) => _$MovieTimesFromJson(json);

  Map<String, dynamic> toJson() => _$MovieTimesToJson(this);
}