import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/home_data.dart';
import 'package:ticket_app/models/voucher.dart';

class DataAppProvider extends ChangeNotifier {
  HomeData? homeData;
  String? cityNameCurrent;
  CinemaCity? reconmmedCinemas;
  List<CinemaCity>? allCinemaCity;
  List<Voucher> vouchers = [];
  bool serviceEnable = false;
  PermissionStatus locationPermisstion = PermissionStatus.denied;

  DataAppProvider();
}
