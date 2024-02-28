import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/payment_card.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/moduels/payment/payment_bloc.dart';
import 'package:ticket_app/moduels/payment/payment_event.dart';
import 'package:ticket_app/moduels/payment/payment_repo.dart';
import 'package:ticket_app/moduels/payment/payment_state.dart';
import 'package:ticket_app/moduels/seat/select_seat_bloc.dart';
import 'package:ticket_app/moduels/seat/select_seat_event.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SelectCardScreen extends StatefulWidget {
  SelectCardScreen({super.key, required this.listCard, required this.ticket});

  final List<PaymentCard> listCard;
  Ticket ticket;

  @override
  State<SelectCardScreen> createState() => _SelectCardScreenState();
}

class _SelectCardScreenState extends State<SelectCardScreen> {

  int? currentIndex;
  final PaymentBloc paymentBloc = PaymentBloc();
  final WebViewController webViewController = WebViewController();
  final StreamController controllerDisplayWebview = StreamController.broadcast();
  final PaymentRepo paymentRepo = PaymentRepo();
  final SelectSeatBloc selectSeatBloc = SelectSeatBloc();
  List<PaymentCard> listCardUser = [];

  @override
  void initState() {
    super.initState();
    listCardUser = widget.listCard.sublist(0);
    webViewController
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(AppColors.background)
    ..setNavigationDelegate(
      NavigationDelegate(
        onUrlChange: (change) {
          _onChangeUrl(change.url ?? "");
        },
        onPageFinished: (url) {
          controllerDisplayWebview.sink.add("done");
        },
      ),
    );
  }

  @override
  void dispose() {
    controllerDisplayWebview.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: paymentBloc,
      listener: (context, state) async {
        _listener(state);
      },
      child: BlocBuilder(
        bloc: paymentBloc,
        builder: (context, state) {
          if(state is CreateURLState){
            if(state.createTokenUrl != null){
              return _buildWebView();
            }
          }
          return _buildMethodPayment(context);
        },
      ),
    );
  }

  Widget _buildMethodPayment(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: "Tài khoản ngân hàng"),
      body: SafeArea(
        child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h,),
          BlocBuilder(
            bloc: paymentBloc,
            builder: (context, state) {
              if(state is GetMethodPaymentUserState){
                if(state.isLoading == true){
                  return const Center(child: CircularProgressIndicator(),);
                }
                if(state.listCard != null){
                  return _buildListCard(state.listCard!);
                }
              }
              return _buildListCard(listCardUser);
            }
          ),
          SizedBox(height: 50.h,),
          _buildButtonAddCard(
            onTap: _onTapCreateMethodPaymemt
          ),
          SizedBox(height: 20.h,),
          ButtonWidget(
            title: "Thanh Toán", 
            height: 50.h, 
            color: currentIndex == null ? AppColors.darkBackground : AppColors.buttonColor,
            width: MediaQuery.of(context).size.width, 
            onPressed: () {
              if(currentIndex != null) {
                _onTapPayment();
              }
            },
          ),
        ],
      
      ),
    ),));
  }

  Widget _buildListCard(List<PaymentCard> listCard) {
    return listCard.isEmpty ? 
    Center(
      child: Text("Chưa có liên kết tài khoản ngân hàng", style: AppStyle.defaultStyle,),
    )
    : SizedBox(
      height: listCard.length * 65.h,
      child: ListView.builder(
        itemCount: listCard.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildItemCard(
                logo: listCard[index].getLogoCard(), 
                cardNumber: listCard[index].cardNumber!, 
                isSelected: currentIndex == index, 
                onTap: () {
                  setState(() {
                    if(currentIndex == index){
                      currentIndex = null;
                    }else{
                      currentIndex = index;
                    }
                  });
                },
              ),
              SizedBox(height: 10.h,)
            ],
          );
        },
      ),
    );
  }

  Widget _buildWebView() {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: controllerDisplayWebview.stream,
          builder: (context, snapshot) {
            if(snapshot.data == null){
              return const Center(child: CircularProgressIndicator(),);
            }else{
              return WebViewWidget(controller: webViewController);
            }
          }
        )
      ),
    );
  }

  Widget _buildItemCard({required String logo, required String cardNumber, required bool isSelected, required Function() onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(
            color: isSelected ? AppColors.buttonColor : AppColors.darkBackground
          )
        ),
        child: Row(
          children: [
            SizedBox(
              height: 50.h,
              width: 50.h,
              child: Image.asset(logo)
            ),
            SizedBox(width: 5.w,),
            Expanded(
              child: Text(
                cardNumber,
                style: AppStyle.defaultStyle,
              )
            ),
            Radio(
              fillColor: MaterialStateProperty.all<Color>(AppColors.buttonColor),
              activeColor: AppColors.buttonColor,
              value: isSelected, 
              groupValue: true, 
              onChanged: (value) {
                
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButtonAddCard({required Function() onTap}){
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(Size(MediaQuery.of(context).size.width, 50.h)),
        backgroundColor:
            MaterialStateProperty.all<Color>(AppColors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        foregroundColor:
            MaterialStateProperty.all<Color>(AppColors.buttonPressColor),
      ),
      onPressed: _onTapCreateMethodPaymemt,
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Thêm phương thức thanh toán",
              style: AppStyle.subTitleStyle.copyWith(color: AppColors.buttonColor),
            )
          ),
          const Icon(Icons.add, color: AppColors.buttonColor,)
        ],
      )
    );
  }

  void _onTapCreateMethodPaymemt() async {
    paymentBloc.add(CreateURLEvent());
    controllerDisplayWebview.sink.add(null);
  }

  void _onChangeUrl(String url){
    if(url.contains("vnp_response_code")){
      final params = Uri.parse(url).queryParameters;
      if(params["vnp_response_code"] == '00'){
        paymentBloc.add(AddMethodPayment(card: params));
      }else{
        _handleErrorCreateToken(params["vnp_response_code"]!);
      }
    }
  }

  void _handleErrorCreateToken(String errorCode){
    switch(errorCode){
      case "04" : DialogError.show(context: context, message: "Hệ thống đang được bảo trì, vui lòng thử lại sao");
        break;
      case "08" : DialogError.show(context: context, message: "Ngân hàng đang được bảo trì, vui lòng sử dụng thẻ ngân hàng khác");
        break;
      case "79" : DialogError.show(context: context, message: "Quý khánh đã thực hiện vượt quá sô lần cho phép, vui lòng thử lại");
        break;
      case "24" : paymentBloc.add(GetMethodPaymentUserEvent());
        break;
    }
  }

  void _handleErrorPayment(String errorCode){
    switch(errorCode){
      case "02" : DialogError.show(context: context, message: "Giao dịch lỗi, vui lòng thử lại");
        break;
      case "04" : DialogError.show(context: context, message: "Đã có lỗi xẩy ra, quý khánh vui lòng liên hệ với đội ngủ hổ trợ đẻ được hoàn tiền");
        break;
      case "07" : DialogError.show(context: context, message: "Có dấu hiệu gian lận, vui lòng liên hệ với ngân hàng để được hổ trợ");
        break;
      case "24" : 
        widget.ticket.id = (Random().nextInt(99999999) + 100000000).toString() + DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString();
        paymentBloc.add(PaymentCancleEvent(ticket: widget.ticket));
        break;
    }
  }

  void _handlePaymentResult(String responseCode){
    if(responseCode == "00"){
      paymentBloc.add(AddTicketEvent(ticket: widget.ticket));
      debugLog("add ticket");
    }else{
      _handleErrorPayment(responseCode);
    }
  }

  Future<void> _listener(Object? state) async {
    if(state is CreateURLState){
      if(state.createTokenUrl != null){
        webViewController.loadRequest(Uri.parse(state.createTokenUrl!));
      }

      if(state.error != null){
        if(state.error is NoInternetException){
          DialogError.show(
            context: context, 
            message: "Không có kết nối internet, vui lòng kiểm tra lại", 
          );
          return;
        }
        DialogError.show(
          context: context, 
          message: "Đã có lỗi xảy ra, vui lòng thử lại sao", 
        );
      }
    }

    if(state is AddMethodPaymentState){
      if(state.isLoading == true){
        DialogLoading.show(context);
      }

      if(state.isSuccess == true){
        paymentBloc.add(GetMethodPaymentUserEvent());
      }

      if(state.error != null){
        if(state.error is NoInternetException){
          DialogError.show(
            context: context, 
            message: "Không có kết nối internet, vui lòng kiểm tra lại", 
          );
          return;
        }
        DialogError.show(
          context: context, 
          message: "Đã có lỗi xẩy ra, vui lòng thử lại",
        );
      }
    }

    if(state is AddTicketState){
      if(state.isLoading == true){
        DialogLoading.show(context);
      }

      if(state.isSuccess == true){
        debugLog("add ticket success");
        Navigator.pushNamed(context, RouteName.paymentSuccessScreen, arguments: widget.ticket);
      }

      if(state.error != null){
        debugLog(state.error.toString());
      }

    }

  }

  void _onTapPayment()async {
    await Navigator.pushNamed(context, RouteName.paymentScreen, arguments: {"ticket": widget.ticket, "paymentCard": listCardUser[currentIndex!]}).then((response) {
      _handlePaymentResult(response.toString());
      debugLog(response.toString());
    });
  }
}