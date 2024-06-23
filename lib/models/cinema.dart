import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/movie_showing_in_cinema.dart';
import 'package:ticket_app/models/room.dart';
part 'cinema.g.dart';

@JsonSerializable()
class Cinema {
  @JsonKey(name: '_id')
  final String id;
  final String thumbnail;
  final String name;
  final String? cityName;
  final CinemasType type;
  List<MovieShowinginCinema>? movieShowinginCinema;
  List<Room>? rooms;
  final double lat;
  final double long;
  double? distance;
  final String address;

  Cinema(
      {required this.id,
      required this.address,
      required this.name,
      required this.cityName,
      required this.thumbnail,
      required this.type,
      required this.lat,
      required this.long,
      this.rooms,
      this.movieShowinginCinema});

  factory Cinema.fromJson(Map<String, dynamic> json) => _$CinemaFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'thumbnail': thumbnail,
      'name': name,
      'type': type.name.toString(),
      'cityName': cityName,
      'movieShowinginCinema':
          movieShowinginCinema?.map((movie) => movie.toJson()).toList(),
      'rooms': rooms?.map((room) => room.toJson()).toList(),
      'lat': lat,
      'long': long,
      'distance': distance,
      'address': address,
    };
  }

  Cinema clone() {
    return Cinema(
        id: id,
        address: address,
        name: name,
        thumbnail: thumbnail,
        type: type,
        lat: lat,
        long: long,
        rooms: rooms!.sublist(0),
        cityName: cityName);
  }

  String getDistanceFormat() {
    if (distance == null) return "";
    if (distance! >= 1000) {
      return "${distance! ~/ 1000},${(distance! % 1000) ~/ 100.toInt()} km";
    } else {
      return "${distance!.toInt()} m";
    }
  }
}
