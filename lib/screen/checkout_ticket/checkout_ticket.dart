import 'dart:async';
import 'dart:isolate';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/moduels/payment/payment_bloc.dart';
import 'package:ticket_app/moduels/payment/payment_event.dart';
import 'package:ticket_app/moduels/payment/payment_state.dart';
import 'package:ticket_app/moduels/seat/select_seat_bloc.dart';
import 'package:ticket_app/moduels/seat/select_seat_event.dart';
import 'package:ticket_app/moduels/seat/select_seat_repo.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:workmanager/workmanager.dart';

class CheckoutTicketScreen extends StatefulWidget {
  CheckoutTicketScreen({super.key, required this.ticket});

  Ticket ticket;

  @override
  State<CheckoutTicketScreen> createState() => _CheckoutTicketScreenState();
}

class _CheckoutTicketScreenState extends State<CheckoutTicketScreen>
    with WidgetsBindingObserver {
  final PaymentBloc paymentBloc = PaymentBloc();
  String id = (Random().nextInt(99999999) + 100000000).toString() +
      DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString();
  Timer? timmer;
  final StreamController countDownController = StreamController();
  final SelectSeatBloc selectSeatBloc = SelectSeatBloc();
  int currentSecond = 600;
  bool isInited = false;
  final SelectSeatRepo selectSeatRepo = SelectSeatRepo();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    timmer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentSecond--;
      if (currentSecond == 0) {
        timmer!.cancel();
        timmer = null;
        selectSeatBloc.add(DeleteSeatEvent(ticket: widget.ticket));
      }
      countDownController.sink.add(currentSecond);
    });
    // final service = FlutterBackgroundService();
    //   service.invoke("ticket", {"ticket": widget.ticket});
    //   service.startService();
    Workmanager().registerPeriodicTask("task-identifier", "simpleTask",
        frequency: Duration(minutes: 1));
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timmer!.cancel();
    timmer = null;
    countDownController.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      print("destroy");
    }
  }

  @override
  Widget build(BuildContext context) {
    isInited = true;
    return WillPopScope(
      onWillPop: () {
        selectSeatBloc.add(DeleteSeatEvent(ticket: widget.ticket));
        return Future.value(true);
      },
      child: BlocListener(
        bloc: paymentBloc,
        listenWhen: (previous, current) {
          return current is GetMethodPaymentUserState;
        },
        listener: (context, state) {
          _onListener(state);
        },
        child: Scaffold(
          appBar: appBarWidget(
            title: "Thanh Toán",
            onTap: () {
              selectSeatBloc.add(DeleteSeatEvent(ticket: widget.ticket));
              Navigator.pop(context);
            },
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                _buidHeader(),
                Divider(
                  height: 2.h,
                  color: AppColors.white,
                ),
                SizedBox(
                  height: 20.h,
                ),
                _buildInformationTicket(),
                SizedBox(
                  height: 20.h,
                ),
                Divider(
                  height: 2.h,
                  color: AppColors.white,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 9,
                  alignment: Alignment.bottomCenter,
                  child: ButtonWidget(
                    title: "Thanh Toán",
                    height: 50.h,
                    width: 150.w,
                    onPressed: () {
                      paymentBloc.add(GetMethodPaymentUserEvent());
                    },
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _buidHeader() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 3.5,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Thời gian giữ ghế",
                style: AppStyle.defaultStyle,
              ),
              SizedBox(
                width: 10.w,
              ),
              StreamBuilder(
                  stream: countDownController.stream,
                  builder: (context, snapshot) {
                    return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(5.h)),
                        child: Text(
                          formatTimeCountDown(currentSecond),
                          style: AppStyle.defaultStyle
                              .copyWith(color: AppColors.white),
                        ));
                  }),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageNetworkWidget(
                url: widget.ticket.movie!.thumbnail!,
                height: 150.h,
                width: 100.w,
                boxFit: BoxFit.fill,
                borderRadius: 10.h,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.ticket.movie!.name!,
                      maxLines: 3,
                      style: AppStyle.subTitleStyle,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      widget.ticket.movie!.getCaterogies(),
                      style: AppStyle.defaultStyle,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${widget.ticket.movie!.duration} phút",
                      style: AppStyle.defaultStyle,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInformationTicket() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildItemInformation(title: "ID: ", value: id),
          _buildItemInformation(
              title: "Rạp: ", value: widget.ticket.cinema!.name),
          _buildItemInformation(
              title: "Ngày giờ: ",
              value: formatDateTime(
                  showtimes: widget.ticket.showtimes!,
                  dateTime: widget.ticket.date!)),
          _buildItemInformation(title: "Ghế: ", value: formatListSeat()),
          _buildItemInformation(
              title: "Tổng tiền: ",
              value: "${formatPrice(widget.ticket.price!)} VND"),
        ],
      ),
    );
  }

  Widget _buildItemInformation({required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppStyle.defaultStyle,
        ),
        Expanded(
            child: Text(
          value,
          style: AppStyle.defaultStyle.copyWith(color: AppColors.white),
          maxLines: 19,
          softWrap: true,
          textAlign: TextAlign.end,
        )),
      ],
    );
  }

  String formatDateTime(
      {required String showtimes, required DateTime dateTime}) {
    return "$showtimes, ${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  String formatListSeat() {
    String stringSeat = "";
    for (var element in widget.ticket.seats!) {
      stringSeat += "${element.name}, ";
    }
    return stringSeat.substring(0, stringSeat.length - 2);
  }

  String formatPrice(int price) {
    String formattedNumber = NumberFormat.decimalPattern().format(price);
    return formattedNumber;
  }

  String formatTimeCountDown(int currentSecond) {
    int minute = currentSecond ~/ 60;
    int second = currentSecond % 60;
    if (second < 10) {
      return "$minute:0$second";
    }
    return "$minute:$second";
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.day}-${dateTime.month}-${dateTime.year}";
  }

  void _onListener(Object? state) {
    if (state is GetMethodPaymentUserState) {
      if (state.isLoading == true) {
        DialogLoading.show(context);
      }

      if (state.listCard != null) {
        widget.ticket.id = id;
        Navigator.pop(context);
        Navigator.pushNamed(context, RouteName.selectCardScreen,
            arguments: {"listCard": state.listCard, "ticket": widget.ticket});
      }

      if (state.error != null) {
        if (state.error is NoInternetException) {
          DialogError.show(
              context: context,
              message: "Không có kết nối internet, vui lòng kiểm tra lại!");
          return;
        }
        DialogError.show(
            context: context, message: "Đã có lỗi xảy ra, vui lòng thử lại");
      }
    }
  }
}
