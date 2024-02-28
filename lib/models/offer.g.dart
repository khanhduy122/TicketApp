// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer(
      thumbnail: json['thumbnail'] as String,
      title: json['title'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      expiredTime: DateTime.parse(json['expiredTime'] as String),
      content: json['content'] as String,
      offerApply: json['offerApply'] as String,
      guide: json['guide'] as String,
    );

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'title': instance.title,
      'startTime': instance.startTime.toIso8601String(),
      'expiredTime': instance.expiredTime.toIso8601String(),
      'content': instance.content,
      'offerApply': instance.offerApply,
      'guide': instance.guide,
    };
