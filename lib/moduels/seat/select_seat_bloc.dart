

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/components/net_work_info.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/moduels/seat/select_seat_event.dart';
import 'package:ticket_app/moduels/seat/select_seat_repo.dart';
import 'package:ticket_app/moduels/seat/select_seat_state.dart';

class SelectSeatBloc extends Bloc<SeatEvent, SeatState>{

  final SelectSeatRepo _selectSeatRepo = SelectSeatRepo();

  SelectSeatBloc() : super(SeatState()){
    on<HoldSeatEvent>((event, emit) => _selectSeat(event, emit));

    on<DeleteSeatEvent>((event, emit) => _deleteSeat(event, emit));
  }

  void _selectSeat(HoldSeatEvent event, Emitter emit)async{
    emit(SeatState(isLoading: true));
    try {
      if(await NetWorkInfo.isConnectedToInternet() == false) {
        emit(SeatState(error: NoInternetException()));
        return;
      }

      await _selectSeatRepo.holdSeat(ticket: event.ticket);
      emit(SeatState(isSuccess: true));
    } catch (e) {
      emit(SeatState(error: e));
    }
    
  }

  void _deleteSeat(DeleteSeatEvent event, Emitter emit){
    try {
      _selectSeatRepo.deleteSelectSeat(ticket: event.ticket).catchError((e){
        add(DeleteSeatEvent(ticket: event.ticket));
      });
    } catch (e) {
      emit(SeatState(error: e));
    }
  }
}

