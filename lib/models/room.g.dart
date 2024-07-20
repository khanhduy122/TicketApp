// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Room _$RoomFromJson(Map<String, dynamic> json) => Room(
      column: (json['column'] as num?)?.toInt(),
      id: json['id'] as String?,
      name: json['name'] as String?,
      row: (json['row'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RoomToJson(Room instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'column': instance.column,
      'row': instance.row,
    };
