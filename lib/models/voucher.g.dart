// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      json['id'] as String,
      thumbnail: json['thumbnail'] as String,
      title: json['title'] as String,
      expiredTime: DateTime.parse(json['expiredTime'] as String),
      description: json['description'] as String,
      condition: json['condition'] as String,
      discount: (json['discount'] as num?)?.toDouble(),
      priceDiscount: json['priceDiscount'] as int?,
      applyInvoices: json['applyInvoices'] as int,
    );

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'id': instance.id,
      'thumbnail': instance.thumbnail,
      'title': instance.title,
      'expiredTime': instance.expiredTime.toIso8601String(),
      'description': instance.description,
      'condition': instance.condition,
      'discount': instance.discount,
      'priceDiscount': instance.priceDiscount,
      'applyInvoices': instance.applyInvoices,
    };
