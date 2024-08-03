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
  Voucher? voucherSelected;
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

  int getPriceFood() {
    if (ticket.foods == null || ticket.foods!.isEmpty) return 0;

    int totalPrice = 0;
    for (var element in ticket.foods!) {
      totalPrice += element.price * (element.quantity ?? 0);
    }
    return totalPrice;
  }

  String formatPrice(int price) {
    String formattedNumber = NumberFormat.decimalPattern().format(price);
    return '$formattedNumber VND';
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
    ticket.voucher = voucherSelected;
    ticket.price = ticket.price! - (voucherSelected?.discountAmount ?? 0);
    Get.toNamed(RouteName.selectCardScreen, arguments: ticket);
  }

  void onTapSelectVoucher() async {
    final result = await Get.toNamed(
      RouteName.selectVoucherScreen,
      arguments: ticket,
    );
    if (result != null) {
      voucherSelected = result as Voucher;
      update();
    }
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
