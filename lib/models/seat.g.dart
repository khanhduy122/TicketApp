// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      name: json['name'] as String,
      status: json['status'] as int,
      typeSeat: $enumDecode(_$TypeSeatEnumMap, json['type']),
      price: json['price'] as int,
      booked: json['booked'] as String,
      index: json['index'] as int,
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'name': instance.name,
      'status': instance.status,
      'price': instance.price,
      'index': instance.index,
      'type': _$TypeSeatEnumMap[instance.typeSeat]!,
      'booked': instance.booked,
    };

const _$TypeSeatEnumMap = {
  TypeSeat.normal: 'normal',
  TypeSeat.vip: 'vip',
  TypeSeat.sweetBox: 'sweetBox',
};
