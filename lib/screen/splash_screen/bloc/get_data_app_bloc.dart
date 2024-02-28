

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/home_data.dart';
import 'package:ticket_app/moduels/cinema/cinema_repo.dart';
import 'package:ticket_app/moduels/ticket/ticket_repo.dart';
import 'package:ticket_app/screen/splash_screen/bloc/get_data_app_repo.dart';

class GetDataAppBloc extends Bloc<GetDataAppEvent, GetDataAppState>{

  final CinemaRepo _cinemaRepo = CinemaRepo();
  final TicketRepo _ticketRepo = TicketRepo();
  final GetDataAppRepo _getDataAppRepo = GetDataAppRepo();

  GetDataAppBloc() : super(GetDataAppState()){
    on<GetDataAppEvent>((event, emit) async {
      try {
        final movies = await _getDataAppRepo.getMovieApp();
        final cinemasRecommended = await _cinemaRepo.getCinemasRecommended(event.context);
        if(FirebaseAuth.instance.currentUser != null){
          await _ticketRepo.convertTicketToExpired();
        }
        emit(GetDataAppState(cinemasRecommended: cinemasRecommended, homeData: movies));
      } catch (e) {
        emit(GetDataAppState(error: e));
      }
    });
  }
}

class GetDataAppEvent {
  BuildContext context;

  GetDataAppEvent({required this.context});
}

class GetDataAppState {
  HomeData? homeData;
  CinemaCity? cinemasRecommended;
  Object? error;

  GetDataAppState({this.cinemasRecommended, this.homeData, this.error});
}