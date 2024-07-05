import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/components/utils/datetime_util.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/movie.dart';
part 'showtimes.g.dart';

@JsonSerializable()
class Showtimes {
  Movie? movie;
  Cinema? cinema;
  List<Time> times;
  DateTime dateTime;

  Showtimes({
    required this.times,
    required this.dateTime,
    this.cinema,
    this.movie,
  });

  static Showtimes fromJson(Map<String, dynamic> json) => Showtimes(
        times: (json['times'] as List<dynamic>)
            .map((e) => Time.fromJson(e as Map<String, dynamic>))
            .toList(),
        cinema: json['cinema'] == null
            ? null
            : Cinema.fromJson(json['cinema'] as Map<String, dynamic>),
        movie: json['movie'] == null
            ? null
            : Movie.fromJson(json['movie'] as Map<String, dynamic>),
        dateTime: DateTimeUtil.stringToDateTime(
          json['date'],
        ),
      );

  Map<String, dynamic> toJson() => _$ShowtimesToJson(this);
}

@JsonSerializable()
class Time {
  @JsonKey(name: "_id")
  String id;
  String time;
  String roomId;

  Time({
    required this.id,
    required this.roomId,
    required this.time,
  });

  factory Time.fromJson(Map<String, dynamic> json) => _$TimeFromJson(json);

  Map<String, dynamic> toJson() => _$TimeToJson(this);
}
