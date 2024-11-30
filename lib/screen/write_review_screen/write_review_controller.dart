import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/const/net_work_info.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/dialogs/dialog_loading.dart';
import 'package:ticket_app/core/utils/upload_file_utils.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/screen/main_screen/ticket/my_ticket_controller.dart';

class WriteReviewController extends GetxController {
  RxInt rating = 0.obs;
  String contentReview = "";
  RxList<File> imagesSelected = <File>[].obs;
  final ticket = Get.arguments as Ticket;

  Future<void> addReview() async {
    if (!await NetWorkInfo.isConnectedToInternet()) {
      DialogError.show(
        context: Get.context!,
        message: "Không có kết nối Internrt",
      );
      return;
    }
    DialogLoading.show(Get.context!);

    final data = <String, dynamic>{
      "ticketId": ticket.ticketId,
      "movieId": ticket.movie!.id,
      "content": contentReview,
      "rating": rating.value,
      "userName":
          Get.context!.read<DataAppProvider>().userInfoModel!.displayName,
      "userPhoto": Get.context!.read<DataAppProvider>().userInfoModel!.photoUrl,
      "images": await UploadFileUtils.uploadImageReview(
        files: imagesSelected,
        movieId: ticket.movie!.id,
        fileName: DateTime.now().microsecondsSinceEpoch.toString(),
      ),
      "timestamp": DateTime.now().microsecondsSinceEpoch
    };

    final response = await ApiCommon.post(
      url: ApiConst.addReview,
      data: data,
    );
    Get.back();
    if (response.data != null) {
      Get.find<MyTicketController>().ticketsExpired.removeWhere(
            (element) => element.ticketId == ticket.ticketId,
          );
      Get.until((route) => route.isFirst);
    } else {
      DialogError.show(
        context: Get.context!,
        message: response.error!.message,
      );
    }
  }

  void onTapSelectPhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> image = await picker.pickMultiImage();
      if (image.isNotEmpty) {
        imagesSelected.addAll(image.map((e) => File(e.path)).toList());
      }
    } catch (e) {
      debugLog(e.toString());
    }
  }
}
