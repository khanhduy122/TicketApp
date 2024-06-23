import 'package:get/get.dart';
import 'package:ticket_app/screen/edit_profile_screen/edit_profile_controller.dart';

class EditProfileBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(EditProfileController());
  }
}
