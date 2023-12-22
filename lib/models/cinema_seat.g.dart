// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cinema_seat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CinemaSeat _$CinemaSeatFromJson(Map<String, dynamic> json) => CinemaSeat(
      name: json['name'] as String,
      status: json['status'] as int,
      typeSeat: $enumDecode(_$TypeSeatEnumMap, json['typeSeat']),
    );

Map<String, dynamic> _$CinemaSeatToJson(CinemaSeat instance) =>
    <String, dynamic>{
      'name': instance.name,
      'status': instance.status,
      'typeSeat': _$TypeSeatEnumMap[instance.typeSeat]!,
    };

const _$TypeSeatEnumMap = {
  TypeSeat.normal: 'normal',
  TypeSeat.vip: 'vip',
  TypeSeat.sweetBox: 'sweetBox',
};
