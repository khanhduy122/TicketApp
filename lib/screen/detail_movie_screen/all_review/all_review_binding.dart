import 'package:get/get.dart';
import 'package:ticket_app/screen/detail_movie_screen/all_review/all_review_controllerr.dart';

class AllReviewBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AllReviewController());
  }
}
