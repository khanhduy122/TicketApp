import 'package:get/get.dart';
import 'package:ticket_app/screen/main_screen/profile/profile_controller.dart';

class ProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ProfileController());
  }
}
