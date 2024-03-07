import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/models/voucher.dart';
import 'package:ticket_app/moduels/seat/select_seat_bloc.dart';
import 'package:ticket_app/moduels/seat/select_seat_event.dart';
import 'package:ticket_app/moduels/seat/select_seat_repo.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class CheckoutTicketScreen extends StatefulWidget {
  CheckoutTicketScreen({super.key, required this.ticket});

  Ticket ticket;

  @override
  State<CheckoutTicketScreen> createState() => _CheckoutTicketScreenState();
}

class _CheckoutTicketScreenState extends State<CheckoutTicketScreen>
    with WidgetsBindingObserver {
  String id = "";
  final StreamController countDownController = StreamController();
  final SelectSeatBloc selectSeatBloc = SelectSeatBloc();
  int currentSecond = 300;
  bool isInited = false;
  Timer? _timer;
  final SelectSeatRepo selectSeatRepo = SelectSeatRepo();
  final service = FlutterBackgroundService();
  Voucher? voucher;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    id = (Random().nextInt(99999999) + 100000000).toString() +
        DateFormat('yyyyMMddHHmmss').format(DateTime.now()).toString();
    widget.ticket.id = id;
    service.startService();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentSecond--;
      if (currentSecond == 0) {
        service.invoke("deleteTicket", {
          "cityName": widget.ticket.cinema!.cityName,
          "cinemaType": widget.ticket.cinema!.type.name,
          "cinemaID": widget.ticket.cinema!.id,
          "date":
              "${widget.ticket.date!.day}-${widget.ticket.date!.month}-${widget.ticket.date!.year}",
          "movieID": widget.ticket.movie!.id,
          "showtimes":
              "${widget.ticket.showtimes} - ${widget.ticket.cinema!.rooms!.first.id}",
          "seats": widget.ticket.seats!.map((e) => e.name).toList()
        });
        _timer!.cancel();
      }
      countDownController.sink.add(currentSecond);
    });

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    debugLog(state.name);
    if (state == AppLifecycleState.detached) {
      print("on destry");
      service.invoke("deleteTicket", {
        "cityName": widget.ticket.cinema!.cityName,
        "cinemaType": widget.ticket.cinema!.type.name,
        "cinemaID": widget.ticket.cinema!.id,
        "date":
            "${widget.ticket.date!.day}-${widget.ticket.date!.month}-${widget.ticket.date!.year}",
        "movieID": widget.ticket.movie!.id,
        "showtimes":
            "${widget.ticket.showtimes} - ${widget.ticket.cinema!.rooms!.first.id}",
        "seats": widget.ticket.seats!.map((e) => e.name).toList()
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = null;
    countDownController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isInited = true;
    return WillPopScope(
      onWillPop: () {
        service.invoke("stopService");
        selectSeatBloc.add(DeleteSeatEvent(ticket: widget.ticket));
        return Future.value(true);
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
                height: 10.h,
              ),
              _buildInformationTicket(),
              SizedBox(
                height: 10.h,
              ),
              Divider(
                height: 2.h,
                color: AppColors.white,
              ),
              SizedBox(
                height: 20.h,
              ),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                      context, RouteName.selectVoucherScreen, arguments: {
                    "voucherSelected": voucher,
                    "cinemasType": widget.ticket.cinema!.type
                  });
                  if (result != null) {
                    setState(() {
                      voucher = result as Voucher;
                      widget.ticket.price =
                          widget.ticket.price! - voucher!.priceDiscount;
                    });
                  } else {
                    setState(() {
                      if (voucher != null) {
                        widget.ticket.price =
                            widget.ticket.price! + voucher!.priceDiscount;
                      }

                      voucher = null;
                    });
                  }
                },
                child: Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  decoration:
                      BoxDecoration(border: Border.all(color: AppColors.grey)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.h,
                      ),
                      Text(
                        "Chọn Voucher",
                        style: AppStyle.subTitleStyle,
                      ),
                      Expanded(
                          child: voucher != null
                              ? Text(
                                  "-${formatPrice(voucher!.priceDiscount)}",
                                  style: AppStyle.subTitleStyle,
                                  textAlign: TextAlign.end,
                                )
                              : Container())
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 9,
                alignment: Alignment.bottomCenter,
                child: ButtonWidget(
                  title: "Thanh Toán",
                  height: 50.h,
                  width: 150.w,
                  onPressed: () {
                    Navigator.pushNamed(context, RouteName.selectCardScreen,
                        arguments: {
                          "ticket": widget.ticket,
                          "voucher": voucher
                        });
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
              title: "Mã Giảm giá: ",
              value: voucher == null
                  ? "0 VND"
                  : "- ${formatPrice(voucher!.priceDiscount)} VND"),
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
}
