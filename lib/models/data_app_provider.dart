import 'package:flutter/material.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/home_data.dart';
import 'package:ticket_app/models/ticket_prices.dart';
import 'package:ticket_app/models/user_info_model.dart';

class DataAppProvider extends ChangeNotifier {
  HomeData? homeData;
  String? cityNameCurrent;
  CinemaCity? reconmmedCinemaCity;
  List<CinemaCity>? allCinemaCity;
  UserInfoModel? userInfoModel;
  TicketPrices? ticketPrices;
  DataAppProvider();
}
