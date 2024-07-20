// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'galaxy_ticket_prices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GalaxyTicketPrices _$GalaxyTicketPricesFromJson(Map<String, dynamic> json) =>
    GalaxyTicketPrices(
      category: json['category'] as String,
      ticket2D: GalaxyCategory.fromJson(json['2D'] as Map<String, dynamic>),
      ticketIMAX: GalaxyCategory.fromJson(json['IMAX'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GalaxyTicketPricesToJson(GalaxyTicketPrices instance) =>
    <String, dynamic>{
      'category': instance.category,
      '2D': instance.ticket2D,
      'IMAX': instance.ticketIMAX,
    };

GalaxyCategory _$GalaxyCategoryFromJson(Map<String, dynamic> json) =>
    GalaxyCategory(
      after5pm: (json['after_5_pm'] as num).toInt(),
      before5pm: (json['before_5_pm'] as num).toInt(),
    );

Map<String, dynamic> _$GalaxyCategoryToJson(GalaxyCategory instance) =>
    <String, dynamic>{
      'before_5_pm': instance.before5pm,
      'after_5_pm': instance.after5pm,
    };
