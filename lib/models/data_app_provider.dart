import 'package:flutter/material.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/home_data.dart';

class DataAppProvider extends ChangeNotifier {
  late final HomeData homeData;
  String cityNameCurrent = "";
  late final CinemaCity reconmmedCinemas;

  DataAppProvider();

  void setHomeData({required HomeData homeData}) {
    this.homeData = homeData;
  }

  void setRecommendedCinema({required CinemaCity cinemas}) {
    reconmmedCinemas = cinemas;
  }

  void setCityNameCurrent({required String name}) {
    cityNameCurrent = name;
  }
}
