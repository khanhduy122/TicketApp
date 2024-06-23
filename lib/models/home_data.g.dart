// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
      banners: (json['banners'] as List<dynamic>)
          .map((e) => BannerHome.fromJson(e as Map<String, dynamic>))
          .toList(),
      comingSoons: (json['comingSoons'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
      nowShowings: (json['nowShowings'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeDataToJson(HomeData instance) => <String, dynamic>{
      'banners': instance.banners,
      'nowShowings': instance.nowShowings,
      'comingSoons': instance.comingSoons,
    };
