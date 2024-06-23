import 'package:get/get.dart';
import 'package:ticket_app/screen/detail_movie_screen/detail_movie/detail_movie_controller.dart';

class DetailMovieBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(DetailMovieController());
  }
}
