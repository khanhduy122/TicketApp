import 'package:json_annotation/json_annotation.dart';

part 'voucher.g.dart';

@JsonSerializable()
class Voucher {
  final String id;
  final String title;
  final int expiredTime;
  final int startTime;
  final String informations;
  final int priceDiscount;
  final int applyInvoices;
  final int appliesToCinemas;

  Voucher(
      {required this.id,
      required this.title,
      required this.expiredTime,
      required this.informations,
      required this.priceDiscount,
      required this.applyInvoices,
      required this.startTime,
      required this.appliesToCinemas});

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);

  String getStringAppliesToCinemas() {
    switch (appliesToCinemas) {
      case 0:
        return "Áp dụng cho tất cả các rạp phim";
      case 1:
        return "Chỉ áp dụng cho vé tại rạp CGV";
      case 2:
        return "Chỉ áp dụng cho vé tại rạp Galaxy";
      case 3:
        return "Chỉ áp dụng cho vé tại rạp Lotte";
    }
    return "Áp dụng cho tất cả các rạp phim";
  }
}
