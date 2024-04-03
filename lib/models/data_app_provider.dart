import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/home_data.dart';
import 'package:ticket_app/models/voucher.dart';

class DataAppProvider extends ChangeNotifier {
  late final HomeData homeData;
  String? cityNameCurrent;
  CinemaCity? reconmmedCinemas;
  List<Voucher> vouchers = [];
  bool serviceEnable = false;
  PermissionStatus locationPermisstion = PermissionStatus.denied;

  DataAppProvider();

  void setHomeData({required HomeData homeData}) {
    this.homeData = homeData;
  }

  void setRecommendedCinema({required CinemaCity? cinemas}) {
    reconmmedCinemas = cinemas;
  }

  void setCityNameCurrent({required String? name}) {
    cityNameCurrent = name;
  }

  void setListVoucher({required List<Voucher> vouchers}) {
    this.vouchers = vouchers.sublist(0);
  }
}
