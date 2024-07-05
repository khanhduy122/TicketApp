import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/payment_card.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/moduels/payment/payment_bloc.dart';
import 'package:ticket_app/moduels/payment/payment_event.dart';
import 'package:ticket_app/moduels/payment/payment_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen(
      {super.key, required this.paymentCard, required this.ticket});

  final PaymentCard paymentCard;
  final Ticket ticket;

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final WebViewController webViewController = WebViewController();
  final PaymentBloc paymentBloc = PaymentBloc();
  final StreamController controllerDisplayWebview = StreamController();

  @override
  void initState() {
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.background)
      ..setNavigationDelegate(NavigationDelegate(
        onUrlChange: (change) {
          _onChangeUrl(change.url ?? "");
        },
        onPageFinished: (url) {
          controllerDisplayWebview.sink.add("done");
        },
      ));
    controllerDisplayWebview.sink.add(null);
    paymentBloc.add(CreatePaymentUrlEvent(
        paymentCard: widget.paymentCard, ticket: widget.ticket));
    super.initState();
  }

  @override
  void dispose() {
    controllerDisplayWebview.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder(
              stream: controllerDisplayWebview.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return loadigWidget();
                }
                return WebViewWidget(controller: webViewController);
              })),
    );
  }

  Widget loadigWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void _onChangeUrl(String url) {
    debugLog(url);
    if (url.contains("vnp_response_code")) {
      final params = Uri.parse(url).queryParameters;
      Navigator.of(context).pop(params["vnp_response_code"]!);
    }
  }
}
