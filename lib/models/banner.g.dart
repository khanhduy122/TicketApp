// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerHome _$BannerHomeFromJson(Map<String, dynamic> json) => BannerHome(
      thumbnail: json['thumbnail'] as String,
      type: json['type'] as int,
      movieId: json['movieId'] as String?,
      offers: json['offers'] == null
          ? null
          : Offer.fromJson(json['offers'] as Map<String, dynamic>),
      voucher: json['voucher'] == null
          ? null
          : Voucher.fromJson(json['voucher'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BannerHomeToJson(BannerHome instance) =>
    <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'type': instance.type,
      'movieId': instance.movieId,
      'voucher': instance.voucher,
      'offers': instance.offers,
    };
