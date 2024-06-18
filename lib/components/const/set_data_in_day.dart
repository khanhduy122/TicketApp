import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/room.dart';

class SetDataFirebaseInDay {
  static Future<void> initData(BuildContext context) async {
    List<Movie> listNowShowing =
        context.read<DataAppProvider>().homeData.nowShowing.sublist(0);
    for (var cityName in cities) {
      // if(cityName == cities[0]){
      //   continue;
      // }

      debugLog(cityName);

      CinemaCity cinemaCity = await getCinemaCity(cityName);

      for (var cinemaCGV in cinemaCity.cgv!) {
        setMovieForCinema(cinemaCGV, listNowShowing, cityName, "CGV");
      }

      for (var cinemaGalaxy in cinemaCity.galaxy!) {
        setMovieForCinema(cinemaGalaxy, listNowShowing, cityName, "Galaxy");
      }

      for (var cinemaLotte in cinemaCity.lotte!) {
        setMovieForCinema(cinemaLotte, listNowShowing, cityName, "Lotte");
      }
    }
  }

  static Future<void> setMovieForCinema(Cinema cinemas,
      List<Movie> listNowShowing, String cityName, String cinemaStyle) async {
    int day = DateTime.now().day;
    String dayString = day.toString().length == 1 ? "0$day" : day.toString();
    int month = DateTime.now().month;
    String monthString =
        month.toString().length == 1 ? "0$month" : month.toString();
    int year = DateTime.now().year;

    for (var movie in listNowShowing) {
      int roomRandom1 = randomIndexRoom(cinemas.rooms!);
      int roomRandom2 = randomIndexRoom(cinemas.rooms!);
      int roomRandom3 = randomIndexRoom(cinemas.rooms!);
      int roomRandom4 = randomIndexRoom(cinemas.rooms!);
      List<String> listCategories = [];
      for (var element in movie.categories!) {
        listCategories.add(element.name);
      }
      FirebaseFirestore.instance
          .collection("Cinemas")
          .doc(cityName)
          .collection(cinemaStyle)
          .doc(cinemas.id)
          .collection("$dayString-$monthString-$year")
          .doc(movie.id)
          .set({
        "movie": {
          "id": movie.id,
          "name": movie.name,
          "thumbnail": movie.thumbnail,
          "duration": movie.duration,
          "categories": listCategories,
        },
        "subtitle_2D": [
          {
            "time": addDurationToTime("10:00", movie.duration!),
            "roomID": cinemas.rooms![roomRandom1].id
          },
          {
            "time": addDurationToTime("14:00", movie.duration!),
            "roomID": cinemas.rooms![roomRandom2].id
          },
          {
            "time": addDurationToTime("16:00", movie.duration!),
            "roomID": cinemas.rooms![roomRandom3].id
          },
          {
            "time": addDurationToTime("18:00", movie.duration!),
            "roomID": cinemas.rooms![roomRandom4].id
          },
          {
            "time": addDurationToTime("23:00", movie.duration!),
            "roomID": cinemas.rooms![roomRandom4].id
          },
        ],
        // "voice_2D": [
        //   {"time": addDurationToTime("10:0$i", movie.duration!), "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": addDurationToTime("14:00", movie.duration!), "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": addDurationToTime("16:00", movie.duration!), "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": addDurationToTime("18:00", movie.duration!), "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        // ],
        // "subtitle_3D": [
        //   {"time": "10:0$i", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": "14:00", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": "16:00", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": "18:00", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": "20:00", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": "22:00", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        // ],
        // "voice_3D": [
        //   {"time": "10:0$i", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": "14:00", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": "16:00", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": "18:00", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": "20:00", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        //   {"time": "22:00", "roomID": cinemas.rooms!.elementAt(randomIndexRoom(cinemas.rooms!)).id},
        // ]
      });
      setInitSeats(
          colum: cinemas.rooms![roomRandom1].column!,
          row: cinemas.rooms![roomRandom1].row!,
          showtimes:
              "${addDurationToTime("10:00", movie.duration!)} - ${cinemas.rooms![roomRandom1].id}",
          cityNam: cityName,
          cinemaID: cinemas.id,
          date: "$dayString-$monthString-$year",
          movieID: movie.id!,
          cinemaType: cinemaStyle);

      setInitSeats(
          colum: cinemas.rooms![roomRandom2].column!,
          row: cinemas.rooms![roomRandom2].row!,
          showtimes:
              "${addDurationToTime("14:00", movie.duration!)} - ${cinemas.rooms![roomRandom2].id}",
          cityNam: cityName,
          cinemaID: cinemas.id,
          date: "$dayString-$monthString-$year",
          movieID: movie.id!,
          cinemaType: cinemaStyle);

      setInitSeats(
          colum: cinemas.rooms![roomRandom3].column!,
          row: cinemas.rooms![roomRandom3].row!,
          showtimes:
              "${addDurationToTime("16:00", movie.duration!)} - ${cinemas.rooms![roomRandom3].id}",
          cityNam: cityName,
          cinemaID: cinemas.id,
          date: "$dayString-$monthString-$year",
          movieID: movie.id!,
          cinemaType: cinemaStyle);

      setInitSeats(
          colum: cinemas.rooms![roomRandom4].column!,
          row: cinemas.rooms![roomRandom4].row!,
          showtimes:
              "${addDurationToTime("18:00", movie.duration!)} - ${cinemas.rooms![roomRandom4].id}",
          cityNam: cityName,
          cinemaID: cinemas.id,
          date: "$dayString-$monthString-$year",
          movieID: movie.id!,
          cinemaType: cinemaStyle);
      await setInitSeats(
          colum: cinemas.rooms![roomRandom4].column!,
          row: cinemas.rooms![roomRandom4].row!,
          showtimes:
              "${addDurationToTime("23:00", movie.duration!)} - ${cinemas.rooms![roomRandom4].id}",
          cityNam: cityName,
          cinemaID: cinemas.id,
          date: "$dayString-$monthString-$year",
          movieID: movie.id!,
          cinemaType: cinemaStyle);
    }
  }

  static int randomIndexRoom(List<Room> rooms) {
    return Random().nextInt(rooms.length);
  }

  static String switchSeats(int index) {
    switch (index) {
      case 1:
        return "A";
      case 2:
        return "B";
      case 3:
        return "C";
      case 4:
        return "D";
      case 5:
        return "E";
      case 6:
        return "F";
      case 7:
        return "G";
      case 8:
        return "H";
      case 9:
        return "I";
      case 10:
        return "J";
      case 11:
        return "K";
      case 12:
        return "L";
      case 13:
        return "M";
      case 14:
        return "N";
      case 15:
        return "O";
      case 16:
        return "P";
    }
    return "";
  }

  static setInitSeats({
    required int colum,
    required int row,
    required String showtimes,
    required String cityNam,
    required String cinemaID,
    required String date,
    required String movieID,
    required String cinemaType,
  }) async {
    int index = 0;
    for (var j = 1; j <= colum; j++) {
      for (var k = 1; k <= row; k++) {
        FirebaseFirestore.instance
            .collection("Cinemas")
            .doc(cityNam)
            .collection(cinemaType)
            .doc(cinemaID)
            .collection(date)
            .doc(movieID)
            .collection(showtimes)
            .doc(switchSeats(j) + k.toString())
            .set({
          "index": index,
          "type": j <= 4 ? TypeSeat.normal.name : TypeSeat.vip.name,
          "price": j <= 4 ? 70000 : 90000,
          "status": 0,
          "name": switchSeats(j) + k.toString(),
          "booked": ""
        });
        index++;
      }
    }
  }

  static Future<CinemaCity> getCinemaCity(String cityName) async {
    final reponse = await FirebaseFirestore.instance
        .collection("Cinemas")
        .doc(cityName)
        .get();
    return CinemaCity.fromJson(reponse.data()!);
  }
}

String addDurationToTime(String startTime, int minutesToAdd) {
  DateTime startTimeDateTime = DateTime.parse("2023-01-01 $startTime:00");

  DateTime endTimeDateTime =
      startTimeDateTime.add(Duration(minutes: minutesToAdd));

  String endTime =
      "${endTimeDateTime.hour.toString().padLeft(2, '0')}:${endTimeDateTime.minute.toString().padLeft(2, '0')}";

  String result = "$startTime - $endTime";

  return result;
}
