import 'package:json_annotation/json_annotation.dart';
part 'cgv_ticket_prices.g.dart';

@JsonSerializable()
class CGVTicketPrices {
  final String category;

  @JsonKey(name: "2D")
  final CGVCategory ticket2D;

  @JsonKey(name: "3D")
  final CGVCategory ticket3D;

  CGVTicketPrices({
    required this.category,
    required this.ticket2D,
    required this.ticket3D,
  });

  factory CGVTicketPrices.fromJson(Map<String, dynamic> json) =>
      _$CGVTicketPricesFromJson(json);

  Map<String, dynamic> toJson() => _$CGVTicketPricesToJson(this);
}

@JsonSerializable()
class CGVCategory {
  @JsonKey(name: "normal_seat")
  final int normal;

  @JsonKey(name: "vip_seat")
  final int vip;

  @JsonKey(name: "sweetbox_seat")
  final int sweetbox;

  CGVCategory({
    required this.normal,
    required this.sweetbox,
    required this.vip,
  });

  factory CGVCategory.fromJson(Map<String, dynamic> json) =>
      _$CGVCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CGVCategoryToJson(this);
}
