// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Food _$FoodFromJson(Map<String, dynamic> json) => Food(
      cgv: FoodDetail.fromJson(json['cgv'] as Map<String, dynamic>),
      galaxy: FoodDetail.fromJson(json['galaxy'] as Map<String, dynamic>),
      lotte: FoodDetail.fromJson(json['lotte'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FoodToJson(Food instance) => <String, dynamic>{
      'cgv': instance.cgv,
      'lotte': instance.lotte,
      'galaxy': instance.galaxy,
    };

FoodDetail _$FoodDetailFromJson(Map<String, dynamic> json) => FoodDetail(
      data: (json['data'] as List<dynamic>)
          .map((e) => FoodItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: $enumDecode(_$CinemasTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$FoodDetailToJson(FoodDetail instance) =>
    <String, dynamic>{
      'type': _$CinemasTypeEnumMap[instance.type]!,
      'data': instance.data,
    };

const _$CinemasTypeEnumMap = {
  CinemasType.CGV: 'CGV',
  CinemasType.Lotte: 'Lotte',
  CinemasType.Galaxy: 'Galaxy',
};

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) => FoodItem(
      description: json['description'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      thumbnail: json['thumbnail'] as String,
      quantity: (json['quantity'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FoodItemToJson(FoodItem instance) => <String, dynamic>{
      'thumbnail': instance.thumbnail,
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'quantity': instance.quantity,
    };
