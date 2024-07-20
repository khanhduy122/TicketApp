import 'package:json_annotation/json_annotation.dart';
part 'lotte_ticket_prices.g.dart';

@JsonSerializable()
class LotteTicketPrices {
  final String category;
  @JsonKey(name: "2D")
  final TimeSlotLottie ticket2D;
  @JsonKey(name: "3D")
  final TimeSlotLottie ticket3D;

  LotteTicketPrices({
    required this.category,
    required this.ticket2D,
    required this.ticket3D,
  });

  factory LotteTicketPrices.fromJson(Map<String, dynamic> json) =>
      _$LotteTicketPricesFromJson(json);

  Map<String, dynamic> toJson() => _$LotteTicketPricesToJson(this);
}

@JsonSerializable()
class TimeSlotLottie {
  @JsonKey(name: "before_5_pm")
  final LotteTicketPricesSeat before5pm;
  @JsonKey(name: "after_5_pm")
  final LotteTicketPricesSeat after5pm;

  TimeSlotLottie({
    required this.after5pm,
    required this.before5pm,
  });

  factory TimeSlotLottie.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotLottieFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotLottieToJson(this);
}

@JsonSerializable()
class LotteTicketPricesSeat {
  @JsonKey(name: "normal_seat")
  final int normal;

  @JsonKey(name: "vip_seat")
  final int vip;

  @JsonKey(name: "sweetbox_seat")
  final int sweetbox;

  LotteTicketPricesSeat({
    required this.normal,
    required this.sweetbox,
    required this.vip,
  });

  factory LotteTicketPricesSeat.fromJson(Map<String, dynamic> json) =>
      _$LotteTicketPricesSeatFromJson(json);

  Map<String, dynamic> toJson() => _$LotteTicketPricesSeatToJson(this);
}
