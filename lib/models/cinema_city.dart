import 'package:ticket_app/models/cinema.dart';

class CinemaCity {
  List<Cinema> all;

  List<Cinema> cgv;

  List<Cinema> lotte;

  List<Cinema> galaxy;

  CinemaCity({
    required this.cgv,
    required this.galaxy,
    required this.lotte,
    required this.all,
  });

  factory CinemaCity.fromJson(Map<String, dynamic> json) {
    final listCGV = (json['cgv'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
    final listGalaxy = (json['galaxy'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
    final listLotte = (json['lotte'] as List<dynamic>)
        .map((e) => Cinema.fromJson(e as Map<String, dynamic>))
        .toList();
    return CinemaCity(
      cgv: listCGV,
      galaxy: listGalaxy,
      lotte: listLotte,
      all: listCGV.sublist(0) + listGalaxy.sublist(0) + listLotte.sublist(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "CGV": cgv.map((cinema) => cinema.toJson()).toList(),
      "Lotte": lotte.map((cinema) => cinema.toJson()).toList(),
      "Galaxy": galaxy.map((cinema) => cinema.toJson()).toList(),
    };
  }
}
