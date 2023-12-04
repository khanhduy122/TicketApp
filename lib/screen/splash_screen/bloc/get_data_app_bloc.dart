

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/home_data.dart';
import 'package:ticket_app/screen/splash_screen/bloc/get_data_app_repo.dart';

class GetDataAppBloc extends Bloc<GetDataAppEvent, GetDataAppState>{

  final GetDataAppRepo _getDataAppRepo = GetDataAppRepo();

  GetDataAppBloc() : super(GetDataAppState()){
    on<GetDataAppEvent>((event, emit) async {
      final movies = await _getDataAppRepo.getMovieApp();
      final cinemasRecommended = await _getDataAppRepo.getCinemasRecommended();
      emit(GetDataAppState(cinemasRecommended: cinemasRecommended, homeData: movies));
    });
  }
}

class GetDataAppEvent {}

class GetDataAppState {
  HomeData? homeData;
  CinemaCity? cinemasRecommended;

  GetDataAppState({this.cinemasRecommended, this.homeData});
}