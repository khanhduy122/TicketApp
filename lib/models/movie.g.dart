// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      id: json['id'] as String?,
      date: json['date'] as String?,
      name: json['name'] as String?,
      thumbnail: json['thumbnail'] as String?,
      banner: json['banner'] as String?,
      subtitle: (json['2D_subtitle'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      voice: (json['2D_voice'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$CategoryEnumMap, e))
          .toList(),
      ban: $enumDecodeNullable(_$BanEnumMap, json['ban']),
      actors: (json['actor'] as List<dynamic>?)
          ?.map((e) => Actor.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalReview: json['total_review'] as int?,
      content: json['content'] as String?,
      director: json['director'] as String?,
      duration: json['duration'] as int?,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$LanguagesEnumMap, e))
          .toList(),
      nation: json['nation'] as String?,
      premiere: json['premiere'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as int?,
      trailer: json['trailer'] as String?,
    )
      ..totalOneRating = json['total_one_rating'] as int?
      ..totalTwoRating = json['total_two_rating'] as int?
      ..totalThreeRating = json['total_three_rating'] as int?
      ..totalFourRating = json['total_four_rating'] as int?
      ..totalFiveRating = json['total_five_rating'] as int?
      ..totalRatingWithPicture = json['total_rating_picture'] as int?;

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbnail': instance.thumbnail,
      'banner': instance.banner,
      'categories':
          instance.categories?.map((e) => _$CategoryEnumMap[e]!).toList(),
      '2D_subtitle': instance.subtitle,
      '2D_voice': instance.voice,
      'ban': _$BanEnumMap[instance.ban],
      'date': instance.date,
      'rating': instance.rating,
      'premiere': instance.premiere,
      'duration': instance.duration,
      'languages':
          instance.languages?.map((e) => _$LanguagesEnumMap[e]!).toList(),
      'content': instance.content,
      'total_review': instance.totalReview,
      'total_one_rating': instance.totalOneRating,
      'total_two_rating': instance.totalTwoRating,
      'total_three_rating': instance.totalThreeRating,
      'total_four_rating': instance.totalFourRating,
      'total_five_rating': instance.totalFiveRating,
      'total_rating_picture': instance.totalRatingWithPicture,
      'actor': instance.actors,
      'director': instance.director,
      'trailer': instance.trailer,
      'reviews': instance.reviews,
      'status': instance.status,
      'nation': instance.nation,
    };

const _$CategoryEnumMap = {
  Category.drama: 'drama',
  Category.romance: 'romance',
  Category.intense: 'intense',
  Category.comedy: 'comedy',
  Category.science_fiction: 'science_fiction',
  Category.adventure: 'adventure',
  Category.act: 'act',
  Category.fantasy: 'fantasy',
  Category.mentality: 'mentality',
  Category.horrified: 'horrified',
  Category.criminal: 'criminal',
};

const _$BanEnumMap = {
  Ban.c13: 'c13',
  Ban.c16: 'c16',
  Ban.c18: 'c18',
  Ban.p: 'p',
};

const _$LanguagesEnumMap = {
  Languages.voice: 'voice',
  Languages.subtitle: 'subtitle',
};
