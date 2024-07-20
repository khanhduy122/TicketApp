// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_prices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketPrices _$TicketPricesFromJson(Map<String, dynamic> json) => TicketPrices(
      cgv: CGVTicketPrices.fromJson(json['cgv'] as Map<String, dynamic>),
      galaxy:
          GalaxyTicketPrices.fromJson(json['galaxy'] as Map<String, dynamic>),
      lotte: LotteTicketPrices.fromJson(json['lotte'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TicketPricesToJson(TicketPrices instance) =>
    <String, dynamic>{
      'cgv': instance.cgv,
      'galaxy': instance.galaxy,
      'lotte': instance.lotte,
    };
