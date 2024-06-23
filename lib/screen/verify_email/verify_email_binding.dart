import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:ticket_app/screen/verify_email/verify_email_controller.dart';

class VerifyEmailBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(VerifyEmailController());
  }
}
