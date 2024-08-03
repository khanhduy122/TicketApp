import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/room.dart';
part 'cinema.g.dart';

@JsonSerializable()
class Cinema {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String? cityName;
  final CinemasType type;
  List<Room>? rooms;
  final double lat;
  final double long;
  double? distance;
  final String address;

  Cinema({
    required this.id,
    required this.address,
    required this.name,
    required this.cityName,
    required this.type,
    required this.lat,
    required this.long,
    this.rooms,
  });

  factory Cinema.fromJson(Map<String, dynamic> json) => _$CinemaFromJson(json);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'cityName': cityName,
        'type': type.name,
        'rooms': rooms!.map((e) => e.toJson()).toList(),
        'lat': lat,
        'long': long,
        'address': address,
      };

  Cinema clone() {
    return Cinema(
        id: id,
        address: address,
        name: name,
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

  String getImageCinem() {
    switch (type) {
      case CinemasType.CGV:
        return AppAssets.icCGV;
      case CinemasType.Lotte:
        return AppAssets.icLotte;
      case CinemasType.Galaxy:
        return AppAssets.icGalaxy;
    }
  }
}
