import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/models/enum_model.dart';

part 'voucher.g.dart';

@JsonSerializable()
class Voucher {
  @JsonKey(name: '_id')
  final String id;
  final String title;
  final int expiredTime;
  final int discountAmount;
  final CinemasType? cinemaType;
  final int applicableForBill;
  final String description;

  Voucher({
    required this.id,
    required this.title,
    required this.expiredTime,
    required this.applicableForBill,
    required this.description,
    required this.discountAmount,
    required this.cinemaType,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);

  Map<String, dynamic> toJson() => _$VoucherToJson(this);

  String getStringAppliesToCinemas() {
    if (cinemaType == null) return "Áp dụng cho tất cả các rạp phim";
    switch (cinemaType!) {
      case CinemasType.CGV:
        return "Chỉ áp dụng cho vé tại rạp CGV";
      case CinemasType.Galaxy:
        return "Chỉ áp dụng cho vé tại rạp Galaxy";
      case CinemasType.Lotte:
        return "Chỉ áp dụng cho vé tại rạp Lotte";
    }
  }

  String getImageVoucher() {
    if (cinemaType == null) return AppAssets.imgLogoVoucher;
    switch (cinemaType!) {
      case CinemasType.CGV:
        return AppAssets.icCGV;
      case CinemasType.Galaxy:
        return AppAssets.icGalaxy;
      case CinemasType.Lotte:
        return AppAssets.icLotte;
    }
  }
}
