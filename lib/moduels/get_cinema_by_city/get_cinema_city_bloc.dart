

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/moduels/get_cinema_by_city/get_cinema_by_city_event.dart';
import 'package:ticket_app/moduels/get_cinema_by_city/get_cinema_city_repo.dart';

class GetCinemasState{
  bool? isLoading;
  CinemaCity? cinemaCity;
  Object? error;

  GetCinemasState({this.error, this.isLoading, this.cinemaCity});
}

class GetCinemasBloc extends Bloc<GetCinemaEvent, GetCinemasState>{

  final GetCinemasRepo _getCinemasRepo = GetCinemasRepo();

  GetCinemasBloc() : super(GetCinemasState()){
    on<GetCinemasByCityEvent>((event, emit) async {
      emit(GetCinemasState(isLoading: true));
      final res = await _getCinemasRepo.getCinemasByCity(event.cityName);
      emit(GetCinemasState(cinemaCity: res));
    });
  }
}