import 'package:json_annotation/json_annotation.dart';
part 'galaxy_ticket_prices.g.dart';

@JsonSerializable()
class GalaxyTicketPrices {
  final String category;
  @JsonKey(name: "2D")
  final GalaxyCategory ticket2D;
  @JsonKey(name: "IMAX")
  final GalaxyCategory ticketIMAX;

  GalaxyTicketPrices({
    required this.category,
    required this.ticket2D,
    required this.ticketIMAX,
  });

  factory GalaxyTicketPrices.fromJson(Map<String, dynamic> json) =>
      _$GalaxyTicketPricesFromJson(json);

  Map<String, dynamic> toJson() => _$GalaxyTicketPricesToJson(this);
}

@JsonSerializable()
class GalaxyCategory {
  @JsonKey(name: "before_5_pm")
  final int before5pm;

  @JsonKey(name: "after_5_pm")
  final int after5pm;

  GalaxyCategory({
    required this.after5pm,
    required this.before5pm,
  });

  factory GalaxyCategory.fromJson(Map<String, dynamic> json) =>
      _$GalaxyCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$GalaxyCategoryToJson(this);
}
