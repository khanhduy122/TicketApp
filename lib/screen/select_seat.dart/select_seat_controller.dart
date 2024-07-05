import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/components/api/api_common.dart';
import 'package:ticket_app/components/api/api_const.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/room.dart';
import 'package:ticket_app/models/seat.dart';
import 'package:ticket_app/models/showtimes.dart';
import 'package:ticket_app/models/ticket.dart';

class SelectSeatController extends GetxController {
  RxList<ItemSeat> listSeat = <ItemSeat>[].obs;
  RxList<ItemSeat> seatsSelected = <ItemSeat>[].obs;
  TransformationController viewTransformationController =
      TransformationController();
  bool isAwaitPayment = false;
  final movie = Get.arguments['movie'] as Movie;
  final cinema = Get.arguments['cinema'] as Cinema;
  final showtimes = Get.arguments['showtimes'] as Showtimes;
  final time = Get.arguments['time'] as Time;
  late final Room room;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getRoom();
    getListSeat();
    viewTransformationController.value = Matrix4.identity()..scale(0.5);
    super.onInit();
  }

  @override
  void onClose() {
    viewTransformationController.dispose();
    super.onClose();
  }

  void getRoom() {
    for (var element in cinema.rooms!) {
      if (element.id == time.roomId) {
        room = element;
        break;
      }
    }
  }

  Color getColorSeat(ItemSeat seat) {
    if (seat.status == 1) {
      return AppColors.darkBackground;
    }
    switch (seat.typeSeat) {
      case TypeSeat.normal:
        return AppColors.grey;
      case TypeSeat.vip:
        return AppColors.purple;
      case TypeSeat.sweetBox:
        return AppColors.purple;
    }
  }

  String formatPrice(int price) {
    String formattedNumber = NumberFormat.decimalPattern().format(price);
    return formattedNumber;
  }

  int getPriceListSeat() {
    int price = 0;
    for (var seat in seatsSelected) {
      price += seat.price;
    }
    return price;
  }

  Future<void> getListSeat() async {
    isLoading.value = true;
    final response = await ApiCommon.get(
      url: ApiConst.getListSeat,
      queryParameters: {
        "showtimesId": time.id,
      },
    );

    if (response.data != null) {
      final seat = Seat.fromJson(response.data);
      listSeat.assignAll(seat.seats);
      isLoading.value = false;
    } else {
      isLoading.value = false;
      DialogError.show(
        context: Get.context!,
        message: response.error!.message,
      );
    }
  }

  void onSelectSeat(ItemSeat seat) {
    if (seat.status == 1) return;
    if (seatsSelected.contains(seat)) {
      seatsSelected.remove(seat);
    } else {
      seatsSelected.add(seat);
    }
  }

  Future<void> onTapBookTicket() async {
    final result = await keepSeat();
    if (!result) return;
    final ticket = Ticket(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      cinema: cinema,
      date: showtimes.dateTime,
      movie: movie,
      isExpired: 0,
      quantity: seatsSelected.length,
      showtimes: time,
      seats: seatsSelected,
      price: getPriceListSeat(),
    );

    var response = await Get.toNamed(
      RouteName.checkoutTicketScreen,
      arguments: ticket,
    );
    seatsSelected.clear();
    getListSeat();
  }

  Future<bool> keepSeat() async {
    DialogLoading.show(Get.context!);
    final data = {
      'listSeat': seatsSelected.map((element) => element.index).toList(),
      'id': time.id,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    };

    debugLog(data.toString());

    final response = await ApiCommon.post(
      url: ApiConst.keepSeat,
      data: data,
    );

    if (response.data != null) {
      Get.back();
      return true;
    } else {
      Get.back();
      DialogError.show(
        context: Get.context!,
        message: response.error!.message,
      );
      return false;
    }
  }
}
