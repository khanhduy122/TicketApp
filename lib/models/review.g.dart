// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Review _$ReviewFromJson(Map<String, dynamic> json) => Review(
      id: json['id'] as String,
      content: json['content'] as String,
      userName: json['userName'] as String,
      userPhoto: json['userPhoto'] as String?,
      photoReview: json['photoReview'] as String?,
      rating: (json['rating'] as num).toDouble(),
      timestamp: json['timestamp'] as int,
    );

Map<String, dynamic> _$ReviewToJson(Review instance) => <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'rating': instance.rating,
      'photoReview': instance.photoReview,
      'userName': instance.userName,
      'userPhoto': instance.userPhoto,
      'timestamp': instance.timestamp,
    };
