// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'actor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Actor _$ActorFromJson(Map<String, dynamic> json) => Actor(
      name: json['name'] as String,
      thumbnail: json['thumbnail'] as String,
    );

Map<String, dynamic> _$ActorToJson(Actor instance) => <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'name': instance.name,
    };
