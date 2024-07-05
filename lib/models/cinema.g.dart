// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cinema _$CinemaFromJson(Map<String, dynamic> json) => Cinema(
      id: json['_id'] as String,
      address: json['address'] as String,
      name: json['name'] as String,
      cityName: json['cityName'] as String?,
      thumbnail: json['thumbnail'] as String,
      type: $enumDecode(_$CinemasTypeEnumMap, json['type']),
      lat: (json['lat'] as num).toDouble(),
      long: (json['long'] as num).toDouble(),
      rooms: (json['rooms'] as List<dynamic>?)
          ?.map((e) => Room.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..distance = (json['distance'] as num?)?.toDouble();

Map<String, dynamic> _$CinemaToJson(Cinema instance) => <String, dynamic>{
      '_id': instance.id,
      'thumbnail': instance.thumbnail,
      'name': instance.name,
      'cityName': instance.cityName,
      'type': _$CinemasTypeEnumMap[instance.type]!,
      'rooms': instance.rooms,
      'lat': instance.lat,
      'long': instance.long,
      'distance': instance.distance,
      'address': instance.address,
    };

const _$CinemasTypeEnumMap = {
  CinemasType.CGV: 'CGV',
  CinemasType.Lotte: 'Lotte',
  CinemasType.Galaxy: 'Galaxy',
};
