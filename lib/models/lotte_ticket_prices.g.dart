// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lotte_ticket_prices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LotteTicketPrices _$LotteTicketPricesFromJson(Map<String, dynamic> json) =>
    LotteTicketPrices(
      category: json['category'] as String,
      ticket2D: TimeSlotLottie.fromJson(json['2D'] as Map<String, dynamic>),
      ticket3D: TimeSlotLottie.fromJson(json['3D'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LotteTicketPricesToJson(LotteTicketPrices instance) =>
    <String, dynamic>{
      'category': instance.category,
      '2D': instance.ticket2D,
      '3D': instance.ticket3D,
    };

TimeSlotLottie _$TimeSlotLottieFromJson(Map<String, dynamic> json) =>
    TimeSlotLottie(
      after5pm: LotteTicketPricesSeat.fromJson(
          json['after_5_pm'] as Map<String, dynamic>),
      before5pm: LotteTicketPricesSeat.fromJson(
          json['before_5_pm'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TimeSlotLottieToJson(TimeSlotLottie instance) =>
    <String, dynamic>{
      'before_5_pm': instance.before5pm,
      'after_5_pm': instance.after5pm,
    };

LotteTicketPricesSeat _$LotteTicketPricesSeatFromJson(
        Map<String, dynamic> json) =>
    LotteTicketPricesSeat(
      normal: (json['normal_seat'] as num).toInt(),
      sweetbox: (json['sweetbox_seat'] as num).toInt(),
      vip: (json['vip_seat'] as num).toInt(),
    );

Map<String, dynamic> _$LotteTicketPricesSeatToJson(
        LotteTicketPricesSeat instance) =>
    <String, dynamic>{
      'normal_seat': instance.normal,
      'vip_seat': instance.vip,
      'sweetbox_seat': instance.sweetbox,
    };
