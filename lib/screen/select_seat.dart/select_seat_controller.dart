import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/dialogs/dialog_loading.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/core/utils/datetime_util.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/room.dart';
import 'package:ticket_app/models/seat.dart';
import 'package:ticket_app/models/showtimes.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/models/ticket_prices.dart';

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
  late final TicketPrices ticketPrices;

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
      switch (cinema.type) {
        case CinemasType.CGV:
          price += getPricesCGV(seat);
          break;
        case CinemasType.Lotte:
          price += getPricesLottie(seat);
          break;
        case CinemasType.Galaxy:
          price += getPricesGalaxy();
          break;
      }
    }

    return price;
  }

  int getPricesCGV(ItemSeat seat) {
    switch (seat.typeSeat) {
      case TypeSeat.normal:
        if (showtimes.type == MovieType.movie2D) {
          return ticketPrices.cgv.ticket2D.normal;
        } else {
          return ticketPrices.cgv.ticket3D.normal;
        }
      case TypeSeat.vip:
        if (showtimes.type == MovieType.movie2D) {
          return ticketPrices.cgv.ticket2D.vip;
        } else {
          return ticketPrices.cgv.ticket3D.vip;
        }
      case TypeSeat.sweetBox:
        if (showtimes.type == MovieType.movie2D) {
          return ticketPrices.cgv.ticket2D.sweetbox;
        } else {
          return ticketPrices.cgv.ticket3D.sweetbox;
        }
    }
  }

  int getPricesLottie(ItemSeat seat) {
    List<String> times = time.time.split(" - ");
    DateTime startTime = DateFormat("HH:mm").parse(times[0]);
    if (startTime.hour < 17) {
      switch (seat.typeSeat) {
        case TypeSeat.normal:
          if (showtimes.type == MovieType.movie2D) {
            return ticketPrices.lotte.ticket2D.before5pm.normal;
          } else {
            return ticketPrices.lotte.ticket3D.before5pm.normal;
          }
        case TypeSeat.vip:
          if (showtimes.type == MovieType.movie2D) {
            return ticketPrices.lotte.ticket2D.before5pm.vip;
          } else {
            return ticketPrices.lotte.ticket3D.before5pm.vip;
          }
        case TypeSeat.sweetBox:
          if (showtimes.type == MovieType.movie2D) {
            return ticketPrices.lotte.ticket2D.before5pm.sweetbox;
          } else {
            return ticketPrices.lotte.ticket3D.before5pm.sweetbox;
          }
      }
    } else {
      switch (seat.typeSeat) {
        case TypeSeat.normal:
          if (showtimes.type == MovieType.movie2D) {
            return ticketPrices.lotte.ticket2D.after5pm.normal;
          } else {
            return ticketPrices.lotte.ticket3D.after5pm.normal;
          }
        case TypeSeat.vip:
          if (showtimes.type == MovieType.movie2D) {
            return ticketPrices.lotte.ticket2D.after5pm.vip;
          } else {
            return ticketPrices.lotte.ticket3D.after5pm.vip;
          }
        case TypeSeat.sweetBox:
          if (showtimes.type == MovieType.movie2D) {
            return ticketPrices.lotte.ticket2D.after5pm.sweetbox;
          } else {
            return ticketPrices.lotte.ticket3D.after5pm.sweetbox;
          }
      }
    }
  }

  int getPricesGalaxy() {
    List<String> times = time.time.split(" - ");
    DateTime startTime = DateFormat("HH:mm").parse(times[0]);
    debugLog(startTime.hour.toString());
    if (startTime.hour < 17) {
      if (showtimes.type == MovieType.movie2D) {
        return ticketPrices.galaxy.ticket2D.before5pm;
      } else {
        return ticketPrices.galaxy.ticketIMAX.before5pm;
      }
    } else {
      if (showtimes.type == MovieType.movie2D) {
        return ticketPrices.galaxy.ticket2D.after5pm;
      } else {
        return ticketPrices.galaxy.ticketIMAX.after5pm;
      }
    }
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
      listSeat.assignAll(seat.seats.sublist(0));
      await getTicketPrices();
      isLoading.value = false;
    } else {
      isLoading.value = false;
      DialogError.show(
        context: Get.context!,
        message: response.error!.message,
      );
    }
  }

  Future<void> getTicketPrices() async {
    final response = await ApiCommon.get(
      url: ApiConst.getTicketPrices,
      queryParameters: {
        "date":
            "${showtimes.dateTime.day}/${showtimes.dateTime.month}/${showtimes.dateTime.year}",
      },
    );

    debugLog(response.data.toString());

    if (response.data != null) {
      ticketPrices = TicketPrices.fromJson(response.data);
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
      ticketId: DateTime.now().millisecondsSinceEpoch.toString(),
      cinema: cinema,
      date: showtimes.dateTime,
      movie: movie,
      quantity: seatsSelected.length,
      showtimes: time,
      seats: seatsSelected,
      price: getPriceListSeat(),
      uid: Get.context!.read<DataAppProvider>().userInfoModel!.uid,
    );

    await Get.toNamed(
      RouteName.selectFoodScreen,
      arguments: ticket,
    );

    seatsSelected.clear();
    seatsSelected.refresh();
  }

  Future<bool> keepSeat() async {
    DialogLoading.show(Get.context!);
    final data = {
      'listSeat': seatsSelected.map((element) => element.index).toList(),
      'showtimesId': time.id,
      'uid': FirebaseAuth.instance.currentUser!.uid,
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
