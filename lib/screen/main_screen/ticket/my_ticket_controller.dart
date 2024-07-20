import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/utils/datetime_util.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/ticket.dart';

class MyTicketController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final TabController tabController;
  RxList<Ticket> ticketsNew = <Ticket>[].obs;
  RxList<Ticket> ticketsExpired = <Ticket>[].obs;
  RxBool isLoading = true.obs;
  RxBool isLoadFaild = false.obs;

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    getListTicket();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> getListTicket() async {
    isLoading.value = true;
    final response = await ApiCommon.get(
      url: ApiConst.getListTicket,
      queryParameters: {
        "uid": Get.context!.read<DataAppProvider>().userInfoModel!.uid,
      },
    );

    if (response.data != null) {
      ticketsNew.clear();
      ticketsExpired.clear();
      for (var element in response.data) {
        final ticket = Ticket.fromJson(element);
        if (checkTicketExpired(ticket)) {
          ticketsExpired.add(ticket);
        } else {
          ticketsNew.add(ticket);
        }
      }
    } else {
      isLoadFaild.value = true;
    }
    isLoading.value = false;
  }

  bool checkTicketExpired(Ticket ticket) {
    final now = DateTime.now();
    List<String> times = ticket.showtimes!.time.split(" - ");

    DateTime endTimeExpired = DateFormat("HH:mm").parse(times[1]);

    DateTime endDateTime = DateTime(
      ticket.date!.year,
      ticket.date!.month,
      ticket.date!.day,
      endTimeExpired.hour,
      endTimeExpired.minute,
    );

    debugLog(endDateTime.toString());

    return endDateTime.isBefore(now);
  }
}
