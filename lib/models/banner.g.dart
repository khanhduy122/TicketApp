// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerHome _$BannerHomeFromJson(Map<String, dynamic> json) => BannerHome(
      thumbnail: json['thumbnail'] as String,
      type: json['type'] as int,
      movie: json['movie'] == null
          ? null
          : Movie.fromJson(json['movie'] as Map<String, dynamic>),
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
      'movie': instance.movie,
      'voucher': instance.voucher,
      'offers': instance.offers,
    };
