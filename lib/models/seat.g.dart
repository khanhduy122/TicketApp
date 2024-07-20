// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      seats: (json['seats'] as List<dynamic>)
          .map((e) => ItemSeat.fromJson(e as Map<String, dynamic>))
          .toList(),
      showtimesId: json['showtimesId'] as String,
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'showtimesId': instance.showtimesId,
      'seats': instance.seats,
    };

ItemSeat _$ItemSeatFromJson(Map<String, dynamic> json) => ItemSeat(
      name: json['name'] as String,
      status: (json['status'] as num).toInt(),
      typeSeat: $enumDecode(_$TypeSeatEnumMap, json['type']),
      booked: json['booked'] as String,
      index: (json['index'] as num).toInt(),
    );

Map<String, dynamic> _$ItemSeatToJson(ItemSeat instance) => <String, dynamic>{
      'name': instance.name,
      'status': instance.status,
      'index': instance.index,
      'type': _$TypeSeatEnumMap[instance.typeSeat]!,
      'booked': instance.booked,
    };

const _$TypeSeatEnumMap = {
  TypeSeat.normal: 'normal',
  TypeSeat.vip: 'vip',
  TypeSeat.sweetBox: 'sweetBox',
};
