import 'package:json_annotation/json_annotation.dart';

part 'voucher.g.dart';

@JsonSerializable()
class Voucher {
  final String id;
  final String title;
  final int expiredTime;
  final int startTime;
  final String description;
  final int priceDiscount;
  final int applyInvoices;

  Voucher(this.id,
      {required this.title,
      required this.expiredTime,
      required this.description,
      required this.priceDiscount,
      required this.applyInvoices,
      required this.startTime});

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);
}
