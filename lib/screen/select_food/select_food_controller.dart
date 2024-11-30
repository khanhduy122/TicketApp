import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/food.dart';
import 'package:ticket_app/models/ticket.dart';

class SelectFoodController extends GetxController {
  final ticket = Get.arguments as Ticket;
  RxBool isLoading = false.obs;
  RxBool isLoadFaild = false.obs;
  late final FoodDetail foodDetail;
  RxList<int> listQuantity = <int>[].obs;

  @override
  void onInit() {
    getFood();
    super.onInit();
  }

  Future<void> getFood() async {
    isLoadFaild.value = false;
    isLoading.value = true;
    final response = await ApiCommon.get(url: ApiConst.getFood);

    debugLog(response.data.toString());

    if (response.data != null) {
      final food = Food.fromJson(response.data);
      switch (ticket.cinema!.type) {
        case CinemasType.CGV:
          foodDetail = food.cgv;
        case CinemasType.Lotte:
          foodDetail = food.lotte;
        case CinemasType.Galaxy:
          foodDetail = food.galaxy;
      }
      for (var element in foodDetail.data) {
        listQuantity.add(0);
      }
    } else {
      isLoadFaild.value = true;
    }
    isLoading.value = false;
  }

  String formatPrice(int price) {
    String formattedNumber = NumberFormat.decimalPattern().format(price);
    return '$formattedNumber VND';
  }

  void onTapIncrease(int index) {
    listQuantity[index] += 1;
    listQuantity.refresh();
  }

  void onTapDecrease(int index) {
    if (listQuantity[index] == 0) return;
    listQuantity[index] -= 1;
    listQuantity.refresh();
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

  String getPriceFood() {
    int totalPrice = 0;
    for (var element in foodDetail.data) {
      totalPrice +=
          element.price * listQuantity[foodDetail.data.indexOf(element)];
    }
    return formatPrice(totalPrice);
  }

  Future<void> onTapContinue() async {
    ticket.foods = [];
    int priceFood = 0;

    for (var element in foodDetail.data) {
      if (listQuantity[foodDetail.data.indexOf(element)] > 0) {
        final foodItem = FoodItem(
          description: element.description,
          name: element.name,
          price: element.price,
          thumbnail: element.thumbnail,
          quantity: listQuantity[foodDetail.data.indexOf(element)],
        );

        ticket.foods!.add(foodItem);
      }
    }

    if (ticket.foods != null && ticket.foods!.isNotEmpty) {
      for (var element in ticket.foods!) {
        priceFood += (element.price) * (element.quantity ?? 0);
      }
      ticket.price = ticket.price! + priceFood;
    }

    await Get.toNamed(RouteName.checkoutTicketScreen, arguments: ticket);

    ticket.price = ticket.price! - priceFood;
  }
}
