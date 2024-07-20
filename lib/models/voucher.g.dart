// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      id: json['id'] as String,
      title: json['title'] as String,
      expiredTime: (json['expiredTime'] as num).toInt(),
      informations: json['informations'] as String,
      priceDiscount: (json['priceDiscount'] as num).toInt(),
      applyInvoices: (json['applyInvoices'] as num).toInt(),
      startTime: (json['startTime'] as num).toInt(),
      appliesToCinemas: (json['appliesToCinemas'] as num).toInt(),
    );

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'expiredTime': instance.expiredTime,
      'startTime': instance.startTime,
      'informations': instance.informations,
      'priceDiscount': instance.priceDiscount,
      'applyInvoices': instance.applyInvoices,
      'appliesToCinemas': instance.appliesToCinemas,
    };
