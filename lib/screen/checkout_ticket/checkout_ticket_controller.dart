import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/models/voucher.dart';

import '../../models/ticket.dart';

class CheckoutTicketController extends GetxController {
  String id = "";
  RxInt currentSecond = 300.obs;
  Timer? timer;
  Rx<Voucher?> voucherSelected = (null).obs;
  final ticket = Get.arguments as Ticket;

  @override
  void onReady() {
    super.onReady();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentSecond.value == 0) {
        timer.cancel();
        return;
      }
      currentSecond--;
    });
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.onClose();
  }

  String formatDateTime(
      {required String showtimes, required DateTime dateTime}) {
    return "$showtimes, ${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  String formatListSeat() {
    String stringSeat = "";
    for (var element in ticket.seats!) {
      stringSeat += "${element.name}, ";
    }
    return stringSeat.substring(0, stringSeat.length - 2);
  }

  String formatPrice(int price) {
    String formattedNumber = NumberFormat.decimalPattern().format(price);
    return formattedNumber;
  }

  String formatTimeCountDown(int currentSecond) {
    int minute = currentSecond ~/ 60;
    int second = currentSecond % 60;
    if (second < 10) {
      return "$minute:0$second";
    }
    return "$minute:$second";
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  void onTapCheckout() {
    ticket.voucher = voucherSelected.value;
    Get.toNamed(RouteName.selectCardScreen, arguments: ticket);
  }

  Future<void> cancelSeat() async {
    final data = {
      'listSeat': ticket.seats!.map((element) => element.index).toList(),
      'showtimesId': ticket.showtimes,
      'uid': ticket.uid
    };

    ApiCommon.post(
      url: ApiConst.cancelSeat,
      data: data,
    );
  }
}
