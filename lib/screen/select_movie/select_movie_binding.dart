import 'package:get/get.dart';
import 'package:ticket_app/screen/select_movie/select_movie_controller.dart';

class SelectMovieBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SelectMovieController());
  }
}
