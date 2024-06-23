import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/movie_showing_in_cinema.dart';
import 'package:ticket_app/models/room.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/moduels/cinema/cinema_bloc.dart';
import 'package:ticket_app/moduels/cinema/cinema_event.dart';
import 'package:ticket_app/moduels/cinema/cinema_state.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/screen/select_showtimes_movie/widget/item_day_widget.dart';
import 'package:ticket_app/screen/select_showtimes_movie/widget/item_list_showtimes.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class SelectMovieScreen extends StatefulWidget {
  const SelectMovieScreen({
    super.key,
    required this.cinema,
  });

  final Cinema cinema;

  @override
  State<SelectMovieScreen> createState() => _SelectMovieScreenState();
}

class _SelectMovieScreenState extends State<SelectMovieScreen> {
  int currentSelectedDayIndex = 0;
  final List<DateTime> listDateTime = [];
  final TextEditingController _searchCityTextController =
      TextEditingController();
  final CinemaBloc cinemaBloc = CinemaBloc();

  @override
  void initState() {
    super.initState();
    _initDays();
  }

  @override
  void dispose() {
    super.dispose();
    _searchCityTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: cinemaBloc,
      listener: (context, state) {
        _onListener(state);
      },
      child: Scaffold(
        appBar: appBarWidget(title: widget.cinema.name),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              _buildSelectDay(),
              SizedBox(
                height: 20.h,
              ),
              Expanded(child: _buildSlectMovie())
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildSelectDay() {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: listDateTime.length,
        itemBuilder: (context, index) {
          return ItemDayWidget(
            day: listDateTime[index].day,
            isActive: index == currentSelectedDayIndex,
            onTap: () {
              currentSelectedDayIndex = index;
              DateTime dateTime = listDateTime[index];
              String day = dateTime.day.toString().length == 1
                  ? "0${dateTime.day}"
                  : dateTime.day.toString();
              String month = dateTime.month.toString().length == 1
                  ? "0${dateTime.month}"
                  : dateTime.month.toString();
              String dateSelected = "$day-$month-${dateTime.year}";
              cinemaBloc.add(GetAllMovieReleasedCinemaEvent(
                  cinema: widget.cinema, date: dateSelected, context: context));
            },
          );
        },
      ),
    );
  }

  Widget _buildSlectMovie() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: ListView.builder(
          itemCount: widget.cinema.movieShowinginCinema!.length,
          itemBuilder: (context, index) {
            return _buildListTypeTiket(
                movieShowinginCinema:
                    widget.cinema.movieShowinginCinema![index]);
          },
        ))
      ],
    );
  }

  Widget _buildListTypeTiket(
      {required MovieShowinginCinema movieShowinginCinema}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movieShowinginCinema.movie.name!,
          style: AppStyle.titleStyle,
        ),
        SizedBox(
          height: 20.h,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageNetworkWidget(
              url: movieShowinginCinema.movie.thumbnail!,
              width: 100.w,
              height: 150.h,
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Column(
                children: [
                  movieShowinginCinema.subtitle_2D != null
                      ? BuildListShowtimnes(
                          movieTimes: movieShowinginCinema.subtitle_2D!,
                          title: "Phim 2D Phụ Đề",
                          onTap: (time, roomID) {
                            _onTapItemShowTimes(
                                time: time,
                                roomID: roomID,
                                movie: movieShowinginCinema.movie);
                          },
                        )
                      : const SizedBox(),
                  movieShowinginCinema.voice_2D != null
                      ? BuildListShowtimnes(
                          movieTimes: movieShowinginCinema.voice_2D!,
                          title: "Phim 2D Lồng Tiếng",
                          onTap: (time, roomID) {
                            _onTapItemShowTimes(
                                time: time,
                                roomID: roomID,
                                movie: movieShowinginCinema.movie);
                          },
                        )
                      : const SizedBox(),
                  movieShowinginCinema.subtitle_3D != null
                      ? BuildListShowtimnes(
                          movieTimes: movieShowinginCinema.subtitle_3D!,
                          title: "Phim 3D Phụ Đề",
                          onTap: (time, roomID) {
                            _onTapItemShowTimes(
                                time: time,
                                roomID: roomID,
                                movie: movieShowinginCinema.movie);
                          },
                        )
                      : const SizedBox(),
                  movieShowinginCinema.voice_3D != null
                      ? BuildListShowtimnes(
                          movieTimes: movieShowinginCinema.voice_3D!,
                          title: "Phim 3D Lòng Tiếng",
                          onTap: (time, roomID) {
                            _onTapItemShowTimes(
                                time: time,
                                roomID: roomID,
                                movie: movieShowinginCinema.movie);
                          },
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }

  void _initDays() {
    DateTime now = DateTime.now();
    int currentDay = now.day;
    int currentMonth = now.month;
    int currentYear = now.year;
    listDateTime.add(DateTime(currentYear, currentMonth, currentDay));
    for (int i = 0; i < 14; i++) {
      currentDay++;
      if (currentMonth == 4 ||
          currentMonth == 6 ||
          currentMonth == 9 ||
          currentMonth == 11) {
        if (currentDay > 30) {
          currentDay = 1;
          currentMonth++;
        }
      }
      if (currentMonth == 1 ||
          currentMonth == 3 ||
          currentMonth == 5 ||
          currentMonth == 7 ||
          currentMonth == 8 ||
          currentMonth == 10 ||
          currentMonth == 12) {
        if (currentDay > 31) {
          currentDay = 1;
          currentMonth++;
          if (currentDay > 12) {
            currentMonth = 1;
            currentYear++;
          }
        }
      }
      listDateTime.add(DateTime(currentYear, currentMonth, currentDay));
    }
  }

  void _onTapItemShowTimes(
      {required String time,
      required String roomID,
      required Movie movie}) async {
    Cinema cinemaTicket = widget.cinema.clone();
    debugLog(widget.cinema.rooms!.length.toString());
    Room? room;
    for (var roomTicket in cinemaTicket.rooms!) {
      if (roomTicket.id == roomID) {
        room = roomTicket;
        break;
      }
    }
    cinemaTicket.rooms!.clear();
    cinemaTicket.rooms!.add(room!);
    Ticket ticket = Ticket(
      movie: movie,
      isExpired: 0,
      cinema: cinemaTicket,
      date: listDateTime[currentSelectedDayIndex],
      showtimes: time,
    );
    Navigator.pushNamed(context, RouteName.selectSeatScreen, arguments: ticket);
  }

  void _onListener(Object? state) {
    if (state is GetAllMovieReleasedCinemaState) {
      if (state.isLoading == true) {
        DialogLoading.show(context);
      }

      if (state.cinema != null) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          // widget.cinema.movies = state.cinema!.movies!.sublist(0);
        });
      }

      if (state.error != null) {
        if (state.error is NoInternetException) {
          DialogError.show(
              context: context,
              message: "Không có kết nối internet, vui lòng kiểm tra lại");
        } else {
          DialogError.show(
              context: context,
              message: "Đã có lỗi xảy ra vui lòng thử lại sao");
        }
      }
    }
  }
}
