// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cgv_ticket_prices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CGVTicketPrices _$CGVTicketPricesFromJson(Map<String, dynamic> json) =>
    CGVTicketPrices(
      category: json['category'] as String,
      ticket2D: CGVCategory.fromJson(json['2D'] as Map<String, dynamic>),
      ticket3D: CGVCategory.fromJson(json['3D'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CGVTicketPricesToJson(CGVTicketPrices instance) =>
    <String, dynamic>{
      'category': instance.category,
      '2D': instance.ticket2D,
      '3D': instance.ticket3D,
    };

CGVCategory _$CGVCategoryFromJson(Map<String, dynamic> json) => CGVCategory(
      normal: (json['normal_seat'] as num).toInt(),
      sweetbox: (json['sweetbox_seat'] as num).toInt(),
      vip: (json['vip_seat'] as num).toInt(),
    );

Map<String, dynamic> _$CGVCategoryToJson(CGVCategory instance) =>
    <String, dynamic>{
      'normal_seat': instance.normal,
      'vip_seat': instance.vip,
      'sweetbox_seat': instance.sweetbox,
    };
