import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/core/api/api_common.dart';
import 'package:ticket_app/core/api/api_const.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/const/net_work_info.dart';
import 'package:ticket_app/core/dialogs/dialog_confirm.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/core/dialogs/dialog_loading.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/core/service/notification_service.dart';
import 'package:ticket_app/core/vn_pay/vnp_key.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/payment_card.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/models/user_info_model.dart';
import 'package:ticket_app/screen/main_screen/ticket/my_ticket_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SelectCardController extends GetxController {
  Ticket? ticket;
  Rx<int> currentIndex = 1000.obs;
  final WebViewController webViewController = WebViewController();
  UserInfoModel user = Get.context!.read<DataAppProvider>().userInfoModel!;
  final myTicketController = Get.find<MyTicketController>();
  RxList<PaymentCard> listCard = Get.context!
      .read<DataAppProvider>()
      .userInfoModel!
      .paymentCards
      .sublist(0)
      .obs;
  RxBool isShowWebview = false.obs;
  RxBool isLoadingWebView = false.obs;
  RxBool isLoadingListCard = false.obs;
  RxString titleWebView = "".obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      ticket = Get.arguments as Ticket;
    }
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {
            _onChangeUrl(change.url ?? "");
          },
          onPageFinished: (url) {
            debugLog("onPageFinished: $url");
            isLoadingWebView.value = false;
          },
          onWebResourceError: (error) {
            debugLog(error.errorCode.toString());
          },
        ),
      );
    super.onInit();
  }

  @override
  void onClose() {
    webViewController.clearCache();
    super.onClose();
  }

  void _handleErrorCreateToken(String errorCode) {
    switch (errorCode) {
      case "04":
        DialogError.show(
            context: Get.context!,
            message: "Hệ thống đang được bảo trì, vui lòng thử lại sao");
        break;
      case "08":
        DialogError.show(
            context: Get.context!,
            message:
                "Ngân hàng đang được bảo trì, vui lòng sử dụng thẻ ngân hàng khác");
        break;
      case "79":
        DialogError.show(
            context: Get.context!,
            message:
                "Quý khánh đã thực hiện vượt quá sô lần cho phép, vui lòng thử lại");
        break;
      case "24":
        isShowWebview.value = false;
        break;
    }
  }

  void _handlePaymentResult(String responseCode) {
    debugLog(responseCode);
    if (responseCode == "00") {
      bookSeat();

      final now = DateTime.now();
      List<String> times = ticket!.showtimes!.time.split(" - ");

      DateTime startTimeExpired = DateFormat("HH:mm").parse(times[0]);
      int day = ticket!.date!.day;
      int month = ticket!.date!.month;
      int year = ticket!.date!.year;

      final endDateTime = DateTime(
        year,
        month,
        day,
        startTimeExpired.hour - 1,
        startTimeExpired.minute,
      );

      final dateTimeSchedule = endDateTime.difference(now);

      if (dateTimeSchedule.inHours >= 1 && dateTimeSchedule.inMinutes > 0) {
        NotificationService.schedulingNotification(
          dateTimeSchedule,
          ticket!,
        );
      } else {
        NotificationService.schedulingNotification(
          const Duration(minutes: 30),
          ticket!,
        );
      }
    } else {
      _handleErrorPayment(responseCode);
    }
  }

  void _handleErrorPayment(String errorCode) {
    debugLog(errorCode);
    switch (errorCode) {
      case "02":
        DialogError.show(
          context: Get.context!,
          message: "Giao dịch lỗi, vui lòng thử lại",
        );
        break;
      case "04":
        DialogError.show(
          context: Get.context!,
          message:
              "Đã có lỗi xẩy ra, quý khánh vui lòng liên hệ với đội ngủ hổ trợ đẻ được hoàn tiền",
        );
        break;
      case "07":
        DialogError.show(
          context: Get.context!,
          message:
              "Có dấu hiệu gian lận, vui lòng liên hệ với ngân hàng để được hổ trợ",
        );
        break;
      case "24":
        ticket!.ticketId = DateTime.now().millisecondsSinceEpoch.toString();
        break;
    }
  }

  Future<void> onTapCreateMethodPaymemt() async {
    if (!await NetWorkInfo.isConnectedToInternet()) {
      DialogError.show(
        context: Get.context!,
        message: 'Không có kết nối Internet',
      );
      return;
    }

    try {
      isLoadingWebView.value = true;
      isShowWebview.value = true;
      Map<String, dynamic> params = {
        "vnp_app_user_id": FirebaseAuth.instance.currentUser!.uid,
        "vnp_cancel_url": VpnKey.domainCancel,
        "vnp_card_type": "01",
        "vnp_command": "token_create",
        "vnp_create_date":
            DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString(),
        "vnp_ip_addr": '123.123.123.123',
        "vnp_locale": "vn",
        "vnp_return_url": VpnKey.domainReturn,
        "vnp_tmn_code": VpnKey.tmnCode,
        "vnp_txn_desc": "Taomoitoken",
        "vnp_txn_ref": (Random().nextInt(99999999) + 100000000).toString() +
            DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString(),
        "vnp_version": VpnKey.version,
      };

      List<String> keys = params.keys.toList()..sort();
      Map<String, dynamic> sortParams = <String, dynamic>{};
      for (var key in keys) {
        sortParams[key] = params[key];
      }

      final hashDataBuffer = StringBuffer();
      sortParams.forEach((key, value) {
        hashDataBuffer.write(key);
        hashDataBuffer.write('=');
        hashDataBuffer.write(Uri.encodeComponent(value).toString());
        hashDataBuffer.write('&');
      });
      String hashData =
          hashDataBuffer.toString().substring(0, hashDataBuffer.length - 1);
      String query = Uri(queryParameters: sortParams).query;
      String vnpSecureHash = hmacSHA512(hashData);

      String createTokenUrl =
          "${VpnKey.domainCreateToken}?$query&vnp_secure_hash=$vnpSecureHash";
      titleWebView.value = "Thêm Phương Thức Thanh Toán";
      webViewController.loadRequest(Uri.parse(createTokenUrl));
      debugLog(createTokenUrl);
    } catch (e) {
      isShowWebview.value = false;
      DialogError.show(
        context: Get.context!,
        message: 'Đã có lỗi xảy ra, vui lòng thử lại',
      );
    }
  }

  Future<String> getIpAddress() async {
    try {
      List<NetworkInterface> interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var address in interface.addresses) {
          return address.address;
        }
      }
      return "";
    } catch (e) {
      return "";
    }
  }

  String hmacSHA512(String data) {
    try {
      List<int> hmacKeyBytes = utf8.encode(VpnKey.hashSecret);
      final Hmac hmacSha512 = Hmac(sha512, hmacKeyBytes);
      Uint8List dataBytes = Uint8List.fromList(utf8.encode(data));
      List<int> result = hmacSha512.convert(dataBytes).bytes;

      StringBuffer sb = StringBuffer();
      for (int byte in result) {
        sb.write(byte.toRadixString(16).padLeft(2, '0'));
      }

      return sb.toString();
    } catch (e) {
      return '';
    }
  }

  void _onChangeUrl(String url) {
    if (url.contains("vnp_response_code")) {
      final params = Uri.parse(url).queryParameters;

      if (params["vnp_command"] == "token_create") {
        if (params["vnp_response_code"] == '00') {
          PaymentCard card = PaymentCard.fromVnpParam(params);
          addPaymentCard(card);
        } else {
          _handleErrorCreateToken(params["vnp_response_code"]!);
        }
      } else {
        _handlePaymentResult(params["vnp_response_code"] as String);
      }
      isShowWebview.value = false;
    }
  }

  Future<bool> addPaymentCard(PaymentCard card) async {
    isLoadingListCard.value = true;
    final data = {
      "uid": Get.context!.read<DataAppProvider>().userInfoModel!.uid,
      "card": card.toJson()
    };
    final response = await ApiCommon.post(
      url: ApiConst.addPaymentCard,
      data: data,
    );
    isLoadingListCard.value = false;
    if (response.data != null) {
      List<PaymentCard> listCardResponse = [];
      for (var element in response.data) {
        listCardResponse.add(PaymentCard.fromJson(element));
      }
      Get.context!.read<DataAppProvider>().userInfoModel!.paymentCards =
          listCardResponse.sublist(0);
      listCard.value = listCardResponse.sublist(0);
      return true;
    } else {
      DialogError.show(
        context: Get.context!,
        message: response.error!.message,
      );
      return false;
    }
  }

  Future<void> onTapPayment() async {
    if (currentIndex.value == 1000) return;
    if (!await checkSeat()) return;
    if (!await NetWorkInfo.isConnectedToInternet()) {
      DialogError.show(
        context: Get.context!,
        message: 'Không có kết nối Internet',
      );
      return;
    }

    isLoadingWebView.value = true;
    isShowWebview.value = true;
    Map<String, dynamic> params = {
      "vnp_version": VpnKey.version,
      "vnp_command": "token_pay",
      "vnp_tmn_code": VpnKey.tmnCode,
      "vnp_txn_ref": ticket!.ticketId.toString(),
      "vnp_app_user_id": FirebaseAuth.instance.currentUser!.uid,
      "vnp_token": listCard[currentIndex.value].token,
      "vnp_amount": (ticket!.price! * 100).toString(),
      "vnp_curr_code": "VND",
      "vnp_txn_desc": "ThanhToan${ticket!.ticketId}",
      "vnp_create_date":
          DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString(),
      "vnp_ip_addr": '123.123.123.123',
      "vnp_locale": "vn",
      "vnp_return_url": VpnKey.paymentReturn,
      "vnp_cancel_url": VpnKey.domainCancel,
    };

    List<String> keys = params.keys.toList()..sort();
    Map<String, dynamic> sortParams = <String, dynamic>{};
    for (var key in keys) {
      sortParams[key] = params[key];
    }

    final hashDataBuffer = StringBuffer();
    sortParams.forEach((key, value) {
      hashDataBuffer.write(key);
      hashDataBuffer.write('=');
      hashDataBuffer.write(Uri.encodeComponent(value).toString());
      hashDataBuffer.write('&');
    });
    String hashData =
        hashDataBuffer.toString().substring(0, hashDataBuffer.length - 1);
    String query = Uri(queryParameters: sortParams).query;
    String vnpSecureHash = hmacSHA512(hashData);

    String paymentUrl =
        "${VpnKey.domainPayment}?$query&vnp_secure_hash=$vnpSecureHash";
    titleWebView.value = "Thanh Toán";
    webViewController.loadRequest(Uri.parse(paymentUrl));
  }

  Future<void> deleteCard(PaymentCard card) async {
    if (ticket != null) return;
    final result = await DialogConfirm.show(
      context: Get.context!,
      message: 'Bạn có chắc muốn xóa liên kết thẻ thanh toán ?',
    );

    if (!result) return;
    DialogLoading.show(Get.context!);
    final response = await ApiCommon.post(
      url: ApiConst.deleteCard,
      data: {
        "id": card.id,
        "uid": user.uid,
      },
    );

    if (response.data != null) {
      Get.back();
      listCard.remove(card);
      Get.context!
          .read<DataAppProvider>()
          .userInfoModel!
          .paymentCards
          .remove(card);
    } else {
      Get.back();
      DialogError.show(context: Get.context!, message: response.error!.message);
    }
  }

  Future<bool> bookSeat() async {
    DialogLoading.show(Get.context!);
    ticket!.timestamp = DateTime.now().millisecondsSinceEpoch;
    final response = await ApiCommon.post(
      url: ApiConst.bookSeat,
      data: ticket!.toJson(),
    );

    if (response.data != null) {
      myTicketController.getListTicket();
      Get.back();
      Get.toNamed(RouteName.paymentSuccessScreen);
      return true;
    } else {
      Get.back();
      DialogError.show(context: Get.context!, message: response.error!.message);
      return false;
    }
  }

  Future<bool> checkSeat() async {
    DialogLoading.show(Get.context!);
    final response = await ApiCommon.post(
      url: ApiConst.checkSeat,
      data: ticket!.toJson(),
    );

    if (response.data != null) {
      Get.back();
      if (!response.data) {
        DialogError.show(
          context: Get.context!,
          message: "Ghế đã được đặt, vui lòng chọn lại",
        );
      }
      return response.data;
    } else {
      Get.back();
      DialogError.show(context: Get.context!, message: response.error!.message);
      return false;
    }
  }
}
