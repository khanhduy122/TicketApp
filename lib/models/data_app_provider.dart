
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/home_data.dart';


class DataAppProvider extends ChangeNotifier{

  late final HomeData homeData;
  User? user = FirebaseAuth.instance.currentUser;
  late final CinemaCity reconmmedCinemas;

  DataAppProvider();

  void setData({HomeData? homeData, CinemaCity? reconmmedCinemas, User? user}){
    if(homeData != null){
      this.homeData = homeData;
    }
    if(reconmmedCinemas != null){
      this.reconmmedCinemas = reconmmedCinemas;
    }
    if(user != null){
      this.user = user;
    }
  }
}