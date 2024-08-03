import 'package:get/get.dart';
import 'package:ticket_app/screen/select_voucher/select_voucher_controller.dart';

class SelectVoucherBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SelectVoucherController());
  }
}
