// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      json['id'] as String,
      title: json['title'] as String,
      expiredTime: json['expiredTime'] as int,
      description: json['description'] as String,
      priceDiscount: json['priceDiscount'] as int,
      applyInvoices: json['applyInvoices'] as int,
      startTime: json['startTime'] as int,
    );

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'expiredTime': instance.expiredTime,
      'startTime': instance.startTime,
      'description': instance.description,
      'priceDiscount': instance.priceDiscount,
      'applyInvoices': instance.applyInvoices,
    };
