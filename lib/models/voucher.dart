import 'package:json_annotation/json_annotation.dart';

part 'voucher.g.dart';

@JsonSerializable()
class Voucher {
  final String id;
  final String thumbnail;
  final String title;
  final DateTime expiredTime;
  final String description;
  final String condition;
  final double? discount;
  final int? priceDiscount;
  final int applyInvoices;

  Voucher(this.id, {required this.thumbnail, required this.title, required this.expiredTime, required this.description, required this.condition, this.discount, this.priceDiscount, required this.applyInvoices});

  factory Voucher.fromJson(Map<String, dynamic> json) => _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);
}