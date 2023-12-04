
import 'package:ticket_app/models/cinema.dart';

class CinemaCity {

  List<Cinema>? all;

  List<Cinema>? cgv;

  List<Cinema>? lotte;

  List<Cinema>? galaxy;

  CinemaCity({required this.cgv, required this.galaxy, required this.lotte});

  CinemaCity.fromJson(Map<String, dynamic> json){
    cgv = (json['CGV'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
    galaxy = (json['Galaxy'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
    lotte =  (json['Lotte'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}