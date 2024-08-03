import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/models/voucher.dart';

class SelectVoucherController extends GetxController {
  RxList<Voucher> vouchers = <Voucher>[].obs;
  final ticket = Get.arguments as Ticket;
  RxBool isLoading = false.obs;
  RxBool isLoadFaild = false.obs;

  @override
  void onInit() {
    getVoucher();
    super.onInit();
  }

  Future<void> getVoucher() async {
    isLoadFaild.value = false;
    isLoading.value = true;

    final response = await ApiCommon.get(
      url: ApiConst.getVoucher,
      queryParameters: {'uid': FirebaseAuth.instance.currentUser!.uid},
    );

    if (response.data != null) {
      final listVoucher = <Voucher>[];
      for (var element in response.data) {
        final voucher = Voucher.fromJson(element as Map<String, dynamic>);
        if (voucher.cinemaType == null ||
            ticket.cinema!.type == voucher.cinemaType) {
          listVoucher.add(voucher);
        }
      }
      vouchers.assignAll(listVoucher);
    } else {
      isLoadFaild.value = true;
    }

    isLoading.value = false;
  }
}
