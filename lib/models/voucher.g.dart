// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      id: json['_id'] as String,
      title: json['title'] as String,
      expiredTime: (json['expiredTime'] as num).toInt(),
      applicableForBill: (json['applicableForBill'] as num).toInt(),
      description: json['description'] as String,
      discountAmount: (json['discountAmount'] as num).toInt(),
      cinemaType: $enumDecodeNullable(_$CinemasTypeEnumMap, json['cinemaType']),
    );

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      '_id': instance.id,
      'title': instance.title,
      'expiredTime': instance.expiredTime,
      'discountAmount': instance.discountAmount,
      'cinemaType': _$CinemasTypeEnumMap[instance.cinemaType],
      'applicableForBill': instance.applicableForBill,
      'description': instance.description,
    };

const _$CinemasTypeEnumMap = {
  CinemasType.CGV: 'CGV',
  CinemasType.Lotte: 'Lotte',
  CinemasType.Galaxy: 'Galaxy',
};
