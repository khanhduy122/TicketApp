// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_times.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieTimes _$MovieTimesFromJson(Map<String, dynamic> json) => MovieTimes(
      roomID: json['roomID'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$MovieTimesToJson(MovieTimes instance) =>
    <String, dynamic>{
      'time': instance.time,
      'roomID': instance.roomID,
    };
