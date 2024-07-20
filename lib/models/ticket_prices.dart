import 'package:json_annotation/json_annotation.dart';
import 'package:ticket_app/models/cgv_ticket_prices.dart';
import 'package:ticket_app/models/galaxy_ticket_prices.dart';
import 'package:ticket_app/models/lotte_ticket_prices.dart';
part 'ticket_prices.g.dart';

@JsonSerializable()
class TicketPrices {
  final CGVTicketPrices cgv;
  final GalaxyTicketPrices galaxy;
  final LotteTicketPrices lotte;

  TicketPrices({
    required this.cgv,
    required this.galaxy,
    required this.lotte,
  });

  factory TicketPrices.fromJson(Map<String, dynamic> json) =>
      _$TicketPricesFromJson(json);

  Map<String, dynamic> toJson() => _$TicketPricesToJson(this);
}
