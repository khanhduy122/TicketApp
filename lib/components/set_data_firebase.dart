import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/movie.dart';

class SetDataFirebase{

  static List<CinemaInit> listCinemaCity = [
    CinemaInit(
      cinemaName: "An Giang",
      listCinemaCGV: [],
      listCinemaGalaxy: ["ChIJXzLHf9ZzCjERifaEdxV7owU"],
      listCinemaLotte: ["ChIJCRlzy-VyCjER1QIfd6qr2tQ"]
    ),
    CinemaInit(
      cinemaName: "Bà Rịa Vũng Tàu",
      listCinemaCGV: ["ChIJe6Ndo5NvdTER6MTQqHXHjjk", "ChIJR4m_SrpvdTEREH36Ld1hmB4"],
      listCinemaGalaxy: ["ChIJDcb7o9pzdTER2AvUxB05BeE"],
      listCinemaLotte: ["ChIJUcf4nuZvdTER3RgDMYW5GAw"]
    ),
    CinemaInit(
      cinemaName: "Bình Dương",
      listCinemaCGV: ["ChIJG7nWCSPRdDERoq_wdQAqkCg"],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJXf2i15HXdDERHcKR9Yy7U5g", "ChIJVfonnXPZdDERa8t1UCl4_UY"]
    ),
    CinemaInit(
      cinemaName: "Bình Thuận",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJV-I-NPGDdjERbmS3eoA8j_Q"]
    ),
    CinemaInit(
      cinemaName: "Bình Định",
      listCinemaCGV: ['ChIJH0DVFsNsbzERlCBWy1BY2U4'],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Bắc Giang",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJt-hkSpxtNTERMCIhq65dl0g"]
    ),
    CinemaInit(
      cinemaName: "Bắc Ninh",
      listCinemaCGV: [],
      listCinemaGalaxy: ["ChIJkV5fdTkPNTERDyxH9xjaybU"],
      listCinemaLotte: ["ChIJwSoui1MNNTER9MSXcXQbVN0"]
    ),
    CinemaInit(
      cinemaName: "Bến Tre",
      listCinemaCGV: [],
      listCinemaGalaxy: ["ChIJu86zHvaoCjERv6ouPjbKkzA"],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Cà Mau",
      listCinemaCGV: [],
      listCinemaGalaxy: ["ChIJuyv52qBJoTERaaf9IjZxbLo"],
      listCinemaLotte: ["ChIJFZDnc2JJoTERSJ3fxntbyvE"]
    ),
    CinemaInit(
      cinemaName: "Cần Thơ",
      listCinemaCGV: ["ChIJrSZjuaFioDERxBLF26KA0fs", "ChIJrY_ByiWIoDERmM_G3MbWafA"],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJtR3isBGIoDEREv2X2NOZLk4"]
    ),
    CinemaInit(
      cinemaName: "Hà Nam",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJ3Wq4gqrPNTERNKIjyZqHkx0"]
    ),
    CinemaInit(
      cinemaName: "Hà Nội",
      listCinemaCGV: [
        "ChIJlc9sY4yrNTERtDNg1D1GjO4",
        "ChIJ__-_qgWsNTERUKSUHKmsmVE",
        "ChIJifJiZ4GsNTERfqy0qVUHeUU",
        "ChIJ8c-7goesNTERh0TXuUE5-LE",
        "ChIJ9a0b5JqsNTERL6hqBcns0NI",
        "ChIJh2kSJGarNTERgYLFUf3bhtA",
        "ChIJibCrgOWrNTERBH3DbMyYJiw",
        "ChIJUf07puyrNTEROzbOzoJ9Tyw",
        "ChIJbfCnyb2rNTERVanX2sneYGc",
        "ChIJLc9zVaKsNTER0NvxYxjI8OE",
        "ChIJS8ZZsUqrNTER8VO-u_8-YQE",
        "ChIJwVlYzNyrNTERA4hKNpfXrc0",
        "ChIJGwwssE6rNTERG-6DUPXp8ro",
        "ChIJKeuHSuNVNDERIqx3sKwbitg",
        "ChIJJzoBBEKsNTERL4p7zxlg1j4",
        "ChIJex3iwNKsNTERsq4PIl8gwg4",
        "ChIJJw-KwlWrNTERqTA5v-rUQRw",
        "ChIJvQfkQ6xVNDER26uljcEvxMo",
        "ChIJMZ4fkmqpNTERXTGSoAfU98U",
      ],
      listCinemaGalaxy: ["ChIJVW7dj9GrNTERfnxk5lvzCB0",],
      listCinemaLotte: ["ChIJxSippaisNTERzm9Zmcl7l1U"]
    ),
    CinemaInit(
      cinemaName: "Hà Tĩnh",
      listCinemaCGV: ["ChIJgWZAORZOODER1yPPk2Ra0yU"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Hưng Yên",
      listCinemaCGV: ["ChIJ5Q0sLTqvNTERmcbEf_XsmDY"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Hải Dương",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJTW5XdhGbNTERNziRNoEfsYQ"]
    ),
    CinemaInit(
      cinemaName: "Hải Phòng",
      listCinemaCGV: [
        "ChIJs63IQvZ7SjERVtmpHpgvhQo", 
        "ChIJTXLYrCBxSjER3A2XVWl_eXE", 
        "ChIJOzt78dJ7SjERlY_pHOiM77k", 
        "ChIJkXRMn7t6SjER4K1ZNIaz1Yk"
      ],
      listCinemaGalaxy: ["ChIJ6_EjF0F7SjERysN0RAJecSg"],
      listCinemaLotte: ["ChIJb1fQEu96SjERrFaZmifwx2c"]
    ),
    CinemaInit(
      cinemaName: "Hậu Giang",
      listCinemaCGV: ["ChIJiaTRkhPpoDERLKZ1dQIw1GI"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Khánh Hòa",
      listCinemaCGV: ["ChIJDcdJPytdcDERTkqqcGvsULU"],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJ9z8YwH9dcDER0GCyIviAmlk"]
    ),
    CinemaInit(
      cinemaName: "Kiên Giang",
      listCinemaCGV: ["ChIJVXPsTICzoDERLk2lephdu-U"],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJ9z8YwH9dcDER0GCyIviAmlk"]
    ),
    CinemaInit(
      cinemaName: "Kon Tum",
      listCinemaCGV: ["ChIJ0aJgIvr_azERi5kCAWPJn_0-U"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Lâm Đồng",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJkS6rLlP2czERvMbrZ65bLLo"]
    ),
    CinemaInit(
      cinemaName: "Lạng Sơn",
      listCinemaCGV: ["ChIJnS5ouFlPtTYRqrjqW5PBcSQ"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Nam Định",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJuY128VbnNTERsLGHlrMyaG4"]
    ),
    CinemaInit(
      cinemaName: "Nghệ An",
      listCinemaCGV: ["ChIJuY0kVSXNOTER5lSReLiR14Y"],
      listCinemaGalaxy: ["ChIJS9CCJyDPOTERUQ5W2fBB87o"],
      listCinemaLotte: ["ChIJC4SYFRXOOTER0PVWjOkqzp0"]
    ),
    CinemaInit(
      cinemaName: "Ninh Bình",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJI2wtxM9wNjER88Gj-qS5-F8"]
    ),
    CinemaInit(
      cinemaName: "Ninh Thuận",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJc6IFSGTPcDER6ArfVwnCkdw"]
    ),
    CinemaInit(
      cinemaName: "Phú Yên",
      listCinemaCGV: ["ChIJC8GoRELsbzER3NwAmhyx-QM"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Quảng Bình",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJRxSnL1dXRzERIPt-WfSVnts"]
    ),
    CinemaInit(
      cinemaName: "Quảng Nam",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJqUc1QRwPQjERDIBm0hs64w4"]
    ),
    CinemaInit(
      cinemaName: "Quảng Ngãi",
      listCinemaCGV: ["ChIJATSMizdTaDER3Ey6_qFWWyI"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Quảng Ninh",
      listCinemaCGV: [
        "ChIJn8LIHjxYSjER6XWYfBTUQ78",
        "ChIJvUWmi1JVSzERkbgNrY8ldf8",
        "ChIJD2slqLEBSzERPdRjdF-BMdg"
      ],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJkRZVyY9XSjERwsYfV9rgsFE"]
    ),
    CinemaInit(
      cinemaName: "Sóc Trăng",
      listCinemaCGV: ["ChIJtRoEUkdNoDER-f7Rk8pbpd8"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Sơn La",
      listCinemaCGV: ["ChIJlWS1rH_1MjERP4OE3tNNh58"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Thanh Hóa",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJRd8NibP3NjER6hEWQJ_X-7g"]
    ),
    CinemaInit(
      cinemaName: "Thành phố Hồ Chí Minh",
      listCinemaCGV: [
        "ChIJM7Ep4N0udTERjvnMBhMO6Zc",
        "ChIJMUQ2SpEodTERpFencEspsqw",
        "ChIJWzn1LecvdTER8riFLBqJico",
        "ChIJPW8KYPkodTERBfzFGAnWdWs",
        "ChIJG2BSChgpdTERcDyES0THla8",
        "ChIJ5RpbThomdTERRWoTnCqRmvo",
        "ChIJJTeUeFkpdTERNWZbmsjAEkA",
        "ChIJBR4ZffordTERnrq-TwhxUMc",
        "ChIJpQeTd0gvdTERe-_j6WTtops",
        "ChIJb8fiFzEpdTERzMhh48trVQs",
        "ChIJc4NjcEcvdTER-ZWfDIfsmW8",
        "ChIJ6QXCTokvdTERW22iUDm4Wyo",
        "ChIJDatS46EndTERCsaZsETeASA",
        "ChIJb88yivAudTERWWtOy5eIbXk",
        "ChIJn5Uzw-8pdTERyxTk1eLXCjc",
        "ChIJIcu5wc4tdTERJxL9vPGDacc",
        "ChIJDxzmE6YodTERAKHFbDwik3Y",
        "ChIJY-_w1DApdTERW9vtnRjM__4",
        "ChIJEweSGnrTdDERHZ1qC43mILo",
        "ChIJOyGghZYvdTERpZDBC2qDM7A"
      ],
      listCinemaGalaxy: [
        "ChIJK_qJATwvdTERfaDb1DbcdW4",
        "ChIJt4DeYq0udTERVo7WtTaA3lw",
        "ChIJt8dvsCosdTERyt6i4PrupFA",
        "ChIJdYr7nzEqdTERqnBWBtqCOEo",
        "ChIJE7z_FEUldTER_7WFNX1q95Q",
        "ChIJub0wloApdTERQh4cytRlwSE",
        "ChIJ7RqN6vYpdTERLBNv2O_CiVY",
        "ChIJi9G-ZVgndTERNzScKj7oixI"
      ],
      listCinemaLotte: [
        "ChIJF53oP-wudTER821Myi8FERI",
        "ChIJbfwEOZ8vdTEROqFAdKve7vg",
        "ChIJjWiKNRkvdTER2-LVWfsADpU",
        "ChIJb9uaSRMmdTERmwntyjF1On0",
        "ChIJPXskFYAndTERdInrrekM0GM",
        "ChIJUc5w3aspdTERDQmpYKs_3_0",
        "ChIJH4fgbhopdTERD23X_gjlU1Q",
        "ChIJjVuPcMwpdTERnrCE6kUoT8g",
        "ChIJvwIcfsAndTERWkoNLFY7bgM",
        "ChIJEYn-nUkvdTERfeemiKqR6xc"
      ]
    ),
    CinemaInit(
      cinemaName: "Thái Bình",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJ-bpa3dDkNTERtFwhmHz7foE"]
    ),
    CinemaInit(
      cinemaName: "Thái Nguyên",
      listCinemaCGV: ["ChIJeZ4JLd4nNTERN8Pu9HTMsHE"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Thừa Thiên Huế",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJccfaFBWhQTERggUxRIqi0eg"]
    ),
    CinemaInit(
      cinemaName: "Tiền Giang",
      listCinemaCGV: [
        "ChIJq3PL8W2lCjERzFS30M5sryY",
        "ChIJs1X8y2avCjERcH2Pg87XPCg"
      ],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Trà Vinh",
      listCinemaCGV: ["ChIJ2f__L1IXoDERRwpEGniS35g"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Tuyên Quang",
      listCinemaCGV: [],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJ_W_a8OStNDERFvCzDdKD68E"]
    ),
    CinemaInit(
      cinemaName: "Tây Ninh",
      listCinemaCGV: ["ChIJnRn_bd1rCzERc-3_jm87BBY"],
      listCinemaGalaxy: [],
      listCinemaLotte: ["ChIJHzCm5KRrCzERu6wfaQqzzMI"]
    ),
    CinemaInit(
      cinemaName: "Vĩnh Long",
      listCinemaCGV: ["ChIJI5_NSTGdCjERLl1px4ghgyk"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Yên Bái",
      listCinemaCGV: ["ChIJH_tFQftaMzERsuBWx5cDNZ4"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Đà Nẵng",
      listCinemaCGV: [
        "ChIJiyXbki4YQjER_MF37pT5BxI",
        "ChIJkyrqkEoYQjERoz9z-u9sGyo"
      ],
      listCinemaGalaxy: ["ChIJv80K2gEZQjERjazRpIuJ6m8"],
      listCinemaLotte: ['ChIJl_FHBwEZQjERfL393Bgu2LY']
    ),
    CinemaInit(
      cinemaName: "Đắk Lắk",
      listCinemaCGV: ["ChIJJ2jaFMT3cTER5Zl60AVc2vY"],
      listCinemaGalaxy: ["ChIJx1OlddL3cTER3ITOg08aSWg"],
      listCinemaLotte: []
    ),
    CinemaInit(
      cinemaName: "Đồng Nai",
      listCinemaCGV: ["ChIJfUB1hRzfdDERfG1wG1PUCaY"],
      listCinemaGalaxy: [],
      listCinemaLotte: [
        "ChIJI_UEWWvedDER72cUYbb1pvo",
        "ChIJd1X2RiDcdDERFFLJRlARwD8"
      ]
    ),
    CinemaInit(
      cinemaName: "Đồng Tháp",
      listCinemaCGV: ["ChIJ-xEuELZlCjERJscupoIWc4U"],
      listCinemaGalaxy: [],
      listCinemaLotte: []
    ),
  ];

  static Future<void> initData(BuildContext context) async {

    List<Movie> listNowShowing = context.read<DataAppProvider>().homeData.nowShowing.sublist(0);
    debugLog("listMovieSetData: ${listNowShowing.length}" );

    for (var cinemaCity in listCinemaCity) {

      debugLog(cinemaCity.cinemaName);
      debugLog(cinemaCity.listCinemaCGV.length.toString());
      // cgv
      for (var cinema in cinemaCity.listCinemaCGV) {
        int i = 0;
        int day = DateTime.now().day;
        int mon = DateTime.now().month;
        int year = DateTime.now().year;
        debugLog(cinema);
        while(i < 14){
          for (var movie in listNowShowing) {
            debugLog(movie.name!);
            await FirebaseFirestore.instance.collection("Cinemas").doc(cinemaCity.cinemaName).collection("CGV").doc(cinema).collection("$day-$mon-$year").doc(movie.id).set(
              {
                'id': movie.id,
                "name": movie.name,
                "duration": movie.duration,
                "thumbnail": movie.thumbnail,
                "2D_subtitle": [
                  "00:0$day",
                  "03:00",
                  "06:00",
                  "09:00",
                ],
                "2D_voice": [
                  "10:00",
                  "15:50",
                  "19:32"
                ]
              }
            );
            setInitSeats(crossAxisCount: 9, showtimes: "00:0$day", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "CGV");
            setInitSeats(crossAxisCount: 10, showtimes: "03:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "CGV");
            setInitSeats(crossAxisCount: 8, showtimes: "06:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "CGV");
            setInitSeats(crossAxisCount: 11, showtimes: "09:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "CGV");
            setInitSeats(crossAxisCount: 12, showtimes: "10:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "CGV");
            setInitSeats(crossAxisCount: 13, showtimes: "15:50", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "CGV");
            setInitSeats(crossAxisCount: 8, showtimes: "19:32", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "CGV");
          }
          day++;
          i++;
          if(mon == 4 || mon == 6 || mon == 9 || mon == 11){
            if(day > 30){
              day = 1;
              mon++;
            }
          }
          if(mon == 1 || mon == 3 || mon == 5 || mon == 7 || mon == 8 || mon == 10 || mon == 12){
            if(day > 31){
              day = 1;
              mon++;
              if(mon > 12){
                mon = 1;
                year++;
              }
            }
          }
        }
      }

      // galaxy
      for (var cinema in cinemaCity.listCinemaGalaxy) {
        int i = 0;
        int day = DateTime.now().day;
        int mon = DateTime.now().month;
        int year = DateTime.now().year;

        while(i < 14){
          debugLog("$day-$mon-$year");
          for (var movie in listNowShowing) {
            await FirebaseFirestore.instance.collection("Cinemas").doc(cinemaCity.cinemaName).collection("Galaxy").doc(cinema).collection("$day-$mon-$year").doc(movie.id).set(
              {
                'id': movie.id,
                "name": movie.name,
                "duration": movie.duration,
                "thumbnail": movie.thumbnail,
                "2D_subtitle": [
                  "00:0$day",
                  "03:00",
                  "06:00",
                  "09:00",
                ],
                "2D_voice": [
                  "10:00",
                  "15:50",
                  "19:32"
                ]
              }
            );
            setInitSeats(crossAxisCount: 9, showtimes: "00:0$day", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Galaxy");
            setInitSeats(crossAxisCount: 10, showtimes: "03:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Galaxy");
            setInitSeats(crossAxisCount: 8, showtimes: "06:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Galaxy");
            setInitSeats(crossAxisCount: 11, showtimes: "09:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Galaxy");
            setInitSeats(crossAxisCount: 12, showtimes: "10:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Galaxy");
            setInitSeats(crossAxisCount: 13, showtimes: "15:50", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Galaxy");
            setInitSeats(crossAxisCount: 8, showtimes: "19:32", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Galaxy");
          }
          day++;
          i++;
          if(mon == 4 || mon == 6 || mon == 9 || mon == 11){
            if(day > 30){
              day = 1;
              mon++;
            }
          }
          if(mon == 1 || mon == 3 || mon == 5 || mon == 7 || mon == 8 || mon == 10 || mon == 12){
            if(day > 31){
              day = 1;
              mon++;
              if(mon > 12){
                mon = 1;
                year++;
              }
            }
          }
        }
      }

      // Lotte
      for (var cinema in cinemaCity.listCinemaLotte) {
        int i = 0;
        int day = DateTime.now().day;
        int mon = DateTime.now().month;
        int year = DateTime.now().year;

        while(i < 14){
          for (var movie in listNowShowing) {
            await FirebaseFirestore.instance.collection("Cinemas").doc(cinemaCity.cinemaName).collection("Lotte").doc(cinema).collection("$day-$mon-$year").doc(movie.id).set(
              {
                'id': movie.id,
                "name": movie.name,
                "duration": movie.duration,
                "thumbnail": movie.thumbnail,
                "2D_subtitle": [
                  "00:0$day",
                  "03:00",
                  "06:00",
                  "09:00",
                ],
                "2D_voice": [
                  "10:00",
                  "15:50",
                  "19:32"
                ]
              }
            );
            setInitSeats(crossAxisCount: 9, showtimes: "00:0$day", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Lotte");
            setInitSeats(crossAxisCount: 10, showtimes: "03:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Lotte");
            setInitSeats(crossAxisCount: 8, showtimes: "06:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Lotte");
            setInitSeats(crossAxisCount: 11, showtimes: "09:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Lotte");
            setInitSeats(crossAxisCount: 12, showtimes: "10:00", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Lotte");
            setInitSeats(crossAxisCount: 13, showtimes: "15:50", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Lotte");
            setInitSeats(crossAxisCount: 8, showtimes: "19:32", cityNam: cinemaCity.cinemaName, cinemaID: cinema, date: "$day-$mon-$year", movieID: movie.id!, cinemaType: "Lotte");
          }
          day++;
          i++;
          if(mon == 4 || mon == 6 || mon == 9 || mon == 11){
            if(day > 30){
              day = 1;
              mon++;
            }
          }
          if(mon == 1 || mon == 3 || mon == 5 || mon == 7 || mon == 8 || mon == 10 || mon == 12){
            if(day > 31){
              day = 1;
              mon++;
              if(mon > 12){
                mon = 1;
                year++;
              }
            }
          }
        }
      }
    }
  }

   static String switchSeats(int index){
    switch(index){
      case 1: return "A";
      case 2: return "B";
      case 3: return "C";
      case 4: return "D";
      case 5: return "E";
      case 6: return "F";
      case 7: return "G";
      case 8: return "H";
      case 9: return "I";
      case 10: return "J";
    }
    return "";
  }

  static setInitSeats({required int crossAxisCount, required String showtimes, required String cityNam, required String cinemaID, required String date, required String movieID, required String cinemaType}) async{
    int index = 0;
      for (var j = 1; j <= 10; j++) {
        for (var k = 1; k <= crossAxisCount; k++) {
          await FirebaseFirestore.instance.collection("Cinemas").doc(cityNam).collection(cinemaType).doc(cinemaID).collection(date).doc(movieID).collection(showtimes).doc(switchSeats(j) + k.toString()).set(
            {
              "index": index,
              "type": j <= 4 ? TypeSeat.normal.name : TypeSeat.vip.name,
              "status": 0,
              "name": switchSeats(j) + k.toString()
            }
          );
          index++;
        }
      }
  }

}

class CinemaInit{
  final String cinemaName;
  final List<String> listCinemaCGV;
  final List<String> listCinemaGalaxy;
  final List<String> listCinemaLotte;

  CinemaInit({required this.cinemaName, required this.listCinemaCGV, required this.listCinemaGalaxy, required this.listCinemaLotte});
}

