// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
      id: json['_id'] as String,
      date: json['date'] as String?,
      name: json['name'] as String?,
      thumbnail: json['thumbnail'] as String?,
      banner: json['banner'] as String?,
      categories: (json['categories'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$CategoryEnumMap, e))
          .toList(),
      ban: $enumDecodeNullable(_$BanEnumMap, json['ban']),
      actors: (json['actor'] as List<dynamic>?)
          ?.map((e) => Actor.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalReview: (json['total_review'] as num?)?.toInt(),
      content: json['content'] as String?,
      director: json['director'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$LanguagesEnumMap, e))
          .toList(),
      nation: json['nation'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      reviews: (json['reviews'] as List<dynamic>?)
          ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: (json['status'] as num?)?.toInt(),
      trailer: json['trailer'] as String?,
    )
      ..totalOneRating = (json['total_one_rating'] as num?)?.toInt()
      ..totalTwoRating = (json['total_two_rating'] as num?)?.toInt()
      ..totalThreeRating = (json['total_three_rating'] as num?)?.toInt()
      ..totalFourRating = (json['total_four_rating'] as num?)?.toInt()
      ..totalFiveRating = (json['total_five_rating'] as num?)?.toInt()
      ..totalRatingWithPicture =
          (json['total_rating_picture'] as num?)?.toInt();

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'thumbnail': instance.thumbnail,
      'banner': instance.banner,
      'categories':
          instance.categories?.map((e) => _$CategoryEnumMap[e]!).toList(),
      'ban': _$BanEnumMap[instance.ban],
      'date': instance.date,
      'rating': instance.rating,
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
