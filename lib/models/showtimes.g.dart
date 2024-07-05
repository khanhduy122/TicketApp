// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'showtimes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Showtimes _$ShowtimesFromJson(Map<String, dynamic> json) => Showtimes(
      times: (json['times'] as List<dynamic>)
          .map((e) => Time.fromJson(e as Map<String, dynamic>))
          .toList(),
      dateTime: DateTime.parse(json['dateTime'] as String),
      cinema: json['cinema'] == null
          ? null
          : Cinema.fromJson(json['cinema'] as Map<String, dynamic>),
      movie: json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ShowtimesToJson(Showtimes instance) => <String, dynamic>{
      'movie': instance.movie,
      'cinema': instance.cinema,
      'times': instance.times,
      'dateTime': instance.dateTime.toIso8601String(),
    };

Time _$TimeFromJson(Map<String, dynamic> json) => Time(
      id: json['_id'] as String,
      roomId: json['roomId'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$TimeToJson(Time instance) => <String, dynamic>{
      '_id': instance.id,
      'time': instance.time,
      'roomId': instance.roomId,
    };
