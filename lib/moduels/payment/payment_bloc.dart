
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/components/net_work_info.dart';
import 'package:ticket_app/models/payment_card.dart';
import 'package:ticket_app/moduels/auth/auth_exception.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/moduels/payment/payment_event.dart';
import 'package:ticket_app/moduels/payment/payment_repo.dart';
import 'package:ticket_app/moduels/payment/payment_state.dart';
import 'package:ticket_app/moduels/seat/seat_exception.dart';
import 'package:ticket_app/moduels/seat/select_seat_repo.dart';
import 'package:ticket_app/moduels/ticket/ticket_repo.dart';
import 'package:ticket_app/components/vn_pay/api_key.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState>{

  final PaymentRepo _paymentRepo = PaymentRepo();
  final TicketRepo _ticketRepo = TicketRepo();
  final SelectSeatRepo _selectSeatRepo = SelectSeatRepo();

  PaymentBloc() : super(PaymentState()){
    on<GetMethodPaymentUserEvent>((event, emit) => _getMethodPayment(event, emit));

    on<CreateURLEvent>((event, emit) => _createURLCreateToken(event, emit));

    on<AddMethodPayment>((event, emit) => _addMethodPayment(event, emit));

    on<CreatePaymentUrlEvent>((event, emit) => _createPaymentUrl(event, emit));

    on<AddTicketEvent>((event, emit) => _addTicketEvent(event, emit));

    on<PaymentCancleEvent>((event, emit) => _paymentCancle(event, emit));

  }

  void _getMethodPayment(GetMethodPaymentUserEvent event, Emitter emit) async {
    emit(GetMethodPaymentUserState(isLoading: true));
    try {
      if(await NetWorkInfo.isConnectedToInternet() == false) {
        emit(GetMethodPaymentUserState(error: NoInternetException()));
        return;
      }
      final response = await _paymentRepo.getMethodPaymentUser();
      emit(GetMethodPaymentUserState(listCard: response));
    } catch (e) {
      emit(GetMethodPaymentUserState(error: e));
    }
  }

  void _createURLCreateToken(CreateURLEvent event, Emitter emit) async {
    emit(CreateURLState(isLoading: true));

    if(await NetWorkInfo.isConnectedToInternet() == false) {
      emit(CreateURLState(error: NoInternetException()));
      return;
    }
    
    try {
      Map<String, dynamic> params = {
        "vnp_app_user_id": FirebaseAuth.instance.currentUser!.uid,
        "vnp_cancel_url": ApiKey.domainCancel,
        "vnp_card_type": "01",
        "vnp_command": "token_create",
        "vnp_create_date": DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString(),
        "vnp_ip_addr": await _paymentRepo.getIpAddress(),
        "vnp_locale": "vn",
        "vnp_return_url": ApiKey.domainReturn,
        "vnp_tmn_code": ApiKey.tmnCode,
        "vnp_txn_desc": "Taomoitoken",
        "vnp_txn_ref": (Random().nextInt(99999999) + 100000000).toString() + DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString(),
        "vnp_version": ApiKey.version,
      };
      
      List<String> keys = params.keys.toList()..sort();
      Map<String, dynamic> sortParams = <String, dynamic>{};
      for (var key in keys) {
        sortParams[key] = params[key];
      }

      final hashDataBuffer = StringBuffer();
      sortParams.forEach((key, value) { 
        hashDataBuffer.write(key);
        hashDataBuffer.write('=');
        hashDataBuffer.write(Uri.encodeComponent(value).toString());
        debugLog(Uri.encodeComponent(value).toString());
        hashDataBuffer.write('&');
      });
      String hashData = hashDataBuffer.toString().substring(0, hashDataBuffer.length-1);
      String query = Uri(queryParameters: sortParams).query;
      String vnpSecureHash = _paymentRepo.hmacSHA512(hashData);

      String createTokenUrl = "${ApiKey.domainTest}?$query&vnp_secure_hash=$vnpSecureHash";

      emit(CreateURLState(createTokenUrl: createTokenUrl));

    } catch (e) {
      emit(CreateURLState(error: e));
    }
  }

  void _addMethodPayment(AddMethodPayment event, Emitter emit) async {
    final PaymentCard card = PaymentCard.fromJson(event.card);
    emit(AddMethodPaymentState(isLoading: true));

    if(await NetWorkInfo.isConnectedToInternet() == false) {
      emit(AddMethodPaymentState(error: NoInternetException()));
      return;
    }

    await _paymentRepo.addMethodPayment(card);
    emit(AddMethodPaymentState(isSuccess: true));
  }

  void _createPaymentUrl(CreatePaymentUrlEvent event, Emitter emit)async{
    if(await NetWorkInfo.isConnectedToInternet() == false) {
      emit(CreatePaymentUrlState(error: NoInternetException()));
      return;
    }

    final result = await _selectSeatRepo.checkSeatBooked(ticket: event.ticket);
    if(result == false){
      emit(CreatePaymentUrlState(error: SeatReservedException()));
      return;
    }else{
      emit(CreatePaymentUrlState(isLoading: true));
      Map<String, dynamic> params = {
        "vnp_version": ApiKey.version,
        "vnp_command": "token_pay",
        "vnp_tmn_code": ApiKey.tmnCode,
        "vnp_txn_ref": event.ticket.id,
        "vnp_app_user_id": FirebaseAuth.instance.currentUser!.uid,
        "vnp_token": event.paymentCard.token,
        "vnp_amount": (event.ticket.price! * 100).toString(),
        "vnp_curr_code": "VND",
        "vnp_txn_desc": "ThanhToan${event.ticket.id}",
        "vnp_create_date": DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString(),
        "vnp_ip_addr": await _paymentRepo.getIpAddress(),
        "vnp_locale": "vn",
        "vnp_return_url": ApiKey.paymentReturn,
        "vnp_cancel_url": ApiKey.domainCancel,
      };
        
      List<String> keys = params.keys.toList()..sort();
      Map<String, dynamic> sortParams = <String, dynamic>{};
      for (var key in keys) {
        sortParams[key] = params[key];
      }

      final hashDataBuffer = StringBuffer();
      sortParams.forEach((key, value) { 
        hashDataBuffer.write(key);
        hashDataBuffer.write('=');
        hashDataBuffer.write(Uri.encodeComponent(value).toString());
        hashDataBuffer.write('&');
      });
      String hashData = hashDataBuffer.toString().substring(0, hashDataBuffer.length-1);
      String query = Uri(queryParameters: sortParams).query;
      String vnpSecureHash = _paymentRepo.hmacSHA512(hashData);

      String paymentUrl = "${ApiKey.domainPayment}?$query&vnp_secure_hash=$vnpSecureHash";
      debugLog(paymentUrl);
      emit(CreatePaymentUrlState(paymentUrl: paymentUrl));
    }
    
  }

  void _addTicketEvent(AddTicketEvent event, Emitter emit) async{
    emit(AddTicketState(isLoading: true));
    try {
      if(await NetWorkInfo.isConnectedToInternet() == false) {
        emit(AddTicketState(error: NoInternetException()));
        return;
      }

      await _ticketRepo.addTicket(event.ticket);
      emit(AddTicketState(isSuccess: true));
    } catch (e) {
      emit(AddTicketState(error: e));
    }
  }

  void _paymentCancle(PaymentCancleEvent event, Emitter emit) async{
    try {
      _selectSeatRepo.cancelBookSeat(ticket: event.ticket);
    } catch (e) {
      
    }
  }
}