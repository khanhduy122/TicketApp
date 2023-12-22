import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/moduels/get_cinema_in_city/get_cinema_in_city_bloc.dart';
import 'package:ticket_app/moduels/get_cinema_in_city/get_cinema_in_city_event.dart';
import 'package:ticket_app/moduels/get_cinema_in_city/get_cinema_in_city_state.dart';
import 'package:ticket_app/screen/auth_screen/blocs/auth_exception.dart';
import 'package:ticket_app/screen/select_filter_movie/widget/item_day_widget.dart';
import 'package:ticket_app/screen/select_filter_movie/widget/item_time_widget.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class SelectMovieScreen extends StatefulWidget {
  const SelectMovieScreen({super.key, required this.cinema, required this.cityName,});

  final Cinema cinema;
  final String cityName;

  @override
  State<SelectMovieScreen> createState() => _SelectMovieScreenState();
}

class _SelectMovieScreenState extends State<SelectMovieScreen> {

  int currentSelectedDayIndex = 0;
  final List<DateTime> listDateTime = [];
  final TextEditingController _searchCityTextController = TextEditingController();
  final GetCinemasBloc getCinemasBloc = GetCinemasBloc();

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
      bloc: getCinemasBloc,
      listener: (context, state) {
        if(state is GetAllMovieCinemaState){
          if (state.isLoading == true) {
            DialogLoading.show(context);
          }
      
          if (state.cinema != null) {
            Navigator.pop(context);
            setState(() {
              widget.cinema.movies = state.cinema!.movies!.sublist(0);
            });
          }
      
          if(state.error != null){
            if(state.error is TimeOutException){
              DialogError.show(context, "Đã có lỗi xẩy ra, vui lòng kiểm tra lại đường truyền");
            }else{
              DialogError.show(context, "Đã có lỗi xảy ra vui lòng thử lại sao");
            }
          }
        }
      },
      child: Scaffold(
        appBar: appBarWidget(title: widget.cinema.name),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(height: 20.h,),
                _buildSelectDay(),
                SizedBox(height: 20.h,),
                _buildSlectMovie()
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget _buildSelectDay(){
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
              String dateSelected = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
              getCinemasBloc.add(GetAllMovieCinemaEvent(cinema: widget.cinema, cityName: widget.cityName, date: dateSelected));
            },
          );
        },
      ),
    );
  }

  Widget _buildSlectMovie() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
            "Phim Đang Chiếu",
            style: AppStyle.titleStyle,
          ),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.cinema.movies!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _buildItemShowTimesMovie(movie: widget.cinema.movies![index]),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                );
              },
            )
          )
        ],
      ),
    );
  }

  Widget _buildItemShowTimesMovie({required Movie movie}){
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageNetworkWidget(
              url: movie.thumbnail!,
              height: 150.h,
              width: 100.w,
              borderRadius: 10.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.name!,
                    maxLines: 3,
                    style: AppStyle.subTitleStyle,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                      children: [
                        (movie.subtitle == null || movie.subtitle!.isEmpty) ? Container()
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("2D Phụ Đề", style: AppStyle.defaultStyle,) ,
                            SizedBox(height: 10.h,),
                            SizedBox(
                              height: movie.subtitle!.length % 2 == 0 ?  movie.subtitle!.length / 2 * 50.h : (movie.subtitle!.length / 2 + 1) * 50.h,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(  
                                    crossAxisCount: 2, 
                                    mainAxisSpacing: 10.h,
                                    mainAxisExtent: 40.h 
                                ), 
                                itemCount: movie.subtitle!.length,
                                itemBuilder: (context, index) {
                                  return ItemTimeWidget(
                                    time: movie.subtitle![index], 
                                    isActive: false, 
                                    onTap: () {
                                      
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h,),

                        (movie.voice == null || movie.voice!.isEmpty) ? 
                        Container() :
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("2D Lòng Tiếng", style: AppStyle.defaultStyle,),
                            SizedBox(height: 10.h,),
                            SizedBox(
                              height: movie.voice!.length % 2 == 0 ?  movie.voice!.length / 2 * 50.h : (movie.voice!.length / 2 + 1) * 50.h,
                              child: GridView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(  
                                    crossAxisCount: 2,  
                                    mainAxisSpacing: 10.h,
                                    mainAxisExtent: 40.h
                                ), 
                                itemCount: movie.voice!.length,
                                itemBuilder: (context, index) {
                                  return ItemTimeWidget(
                                    time: movie.voice![index], 
                                    isActive: false, 
                                    onTap: () {
                                      
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
        SizedBox(height: 10.h,),
        
      ],
    );
  }

  void _initDays(){
    DateTime now = DateTime.now();
    int currentDay = now.day;
    int currentMonth = now.month;
    int currentYear = now.year;
    listDateTime.add(DateTime(currentYear, currentMonth, currentDay));
    for(int i = 0; i < 14; i++){
      currentDay++;
      if(currentMonth == 4 || currentMonth == 6 || currentMonth == 9 || currentMonth == 11){
        if(currentDay > 30){
          currentDay = 1;
          currentMonth++;
        }
      }
      if(currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12){
        if(currentDay > 31){
          currentDay = 1;
          currentMonth++;
          if(currentDay > 12){
            currentMonth = 1;
            currentYear++;
          }
        }
      }
      listDateTime.add(DateTime(currentYear, currentMonth, currentDay));
    }
    
  }
  
}