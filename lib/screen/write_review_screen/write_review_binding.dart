import 'package:get/get.dart';
import 'package:ticket_app/screen/write_review_screen/write_review_controller.dart';

class WriteReviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(WriteReviewController());
  }
}
