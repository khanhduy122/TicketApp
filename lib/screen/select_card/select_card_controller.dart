import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/components/api/api_common.dart';
import 'package:ticket_app/components/api/api_const.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/const/net_work_info.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/vn_pay/vnp_key.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/payment_card.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/models/user_info_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SelectCardController extends GetxController {
  final ticket = Get.arguments as Ticket;
  Rx<int> currentIndex = 1000.obs;
  final WebViewController webViewController = WebViewController();
  UserInfoModel user = Get.context!.read<DataAppProvider>().userInfoModel!;
  RxList<PaymentCard> listCard = Get.context!
      .read<DataAppProvider>()
      .userInfoModel!
      .paymentCards
      .sublist(0)
      .obs;
  RxBool isShowWebview = false.obs;
  RxBool isLoadingWebView = false.obs;
  RxBool isLoadingListCard = false.obs;

  @override
  void onInit() {
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.background)
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {
            _onChangeUrl(change.url ?? "");
          },
          onPageFinished: (url) {
            isLoadingWebView.value = false;
            debugLog('onPageFinished');
          },
        ),
      );
    super.onInit();
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
        // paymentBloc.add(GetMethodPaymentUserEvent());
        break;
    }
  }

  void _handlePaymentResult(String responseCode) {
    if (responseCode == "00") {
      // paymentBloc
      //     .add(AddTicketEvent(ticket: widget.ticket!, voucher: widget.voucher));
      debugLog("add ticket");
    } else {
      _handleErrorPayment(responseCode);
    }
  }

  void _handleErrorPayment(String errorCode) {
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
        // widget.ticket!.id =
        //     (Random().nextInt(99999999) + 100000000).toString() +
        //         DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString();
        // paymentBloc.add(PaymentCancleEvent(ticket: widget.ticket!));
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
        debugLog(value.toString());
        hashDataBuffer.write('&');
      });
      String hashData =
          hashDataBuffer.toString().substring(0, hashDataBuffer.length - 1);
      String query = Uri(queryParameters: sortParams).query;
      String vnpSecureHash = hmacSHA512(hashData);

      String createTokenUrl =
          "${VpnKey.domainCreateToken}?$query&vnp_secure_hash=$vnpSecureHash";
      debugLog(createTokenUrl);
      webViewController.loadRequest(Uri.parse(createTokenUrl));
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
      if (params["vnp_response_code"] == '00') {
        PaymentCard card = PaymentCard.fromVnpParam(params);
        addPaymentCard(card);
      } else {
        _handleErrorCreateToken(params["vnp_response_code"]!);
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
      user = UserInfoModel.fromJson(response.data);
      Get.context!.read<DataAppProvider>().userInfoModel = user;
      listCard.value = user.paymentCards.sublist(0);
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
    if (currentIndex.value == null) return;
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
      "vnp_txn_ref": ticket.id,
      "vnp_app_user_id": FirebaseAuth.instance.currentUser!.uid,
      "vnp_token": listCard[currentIndex.value!].token,
      "vnp_amount": (ticket.price! * 100).toString(),
      "vnp_curr_code": "VND",
      "vnp_txn_desc": "ThanhToan${ticket.id}",
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
    webViewController.loadRequest(Uri.parse(paymentUrl));
    debugLog(paymentUrl);
  }
}
