// ignore_for_file: must_be_immutable

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/seat.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/moduels/seat/seat_exception.dart';
import 'package:ticket_app/moduels/seat/select_seat_bloc.dart';
import 'package:ticket_app/moduels/seat/select_seat_event.dart';
import 'package:ticket_app/moduels/seat/select_seat_repo.dart';
import 'package:ticket_app/moduels/seat/select_seat_state.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class SelectSeatScreen extends StatefulWidget {
  SelectSeatScreen({super.key, required this.ticket});

  Ticket ticket;

  @override
  State<SelectSeatScreen> createState() => _SelectSeatScreenState();
}

class _SelectSeatScreenState extends State<SelectSeatScreen> {
  final List<Seat> seatsSelected = [];
  TransformationController viewTransformationController =
      TransformationController();
  final StreamController detailTiketController = StreamController();
  final SelectSeatBloc seatBloc = SelectSeatBloc();
  bool isAwaitPayment = false;

  @override
  void initState() {
    super.initState();
    viewTransformationController.value = Matrix4.identity()..scale(0.5);
  }

  @override
  void dispose() {
    viewTransformationController.dispose();
    detailTiketController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: seatBloc,
      listener: (context, state) async {
        _onListener(state);
      },
      child: Scaffold(
        backgroundColor: AppColors.seccondBackgroud,
        appBar: appBarWidget(
            title: widget.ticket.movie!.name,
            color: AppColors.seccondBackgroud),
        body: SafeArea(
            child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            _buildHeader(),
            SizedBox(
              height: 20.h,
            ),
            Expanded(child: _buildSelectSeat()),
            SizedBox(
              height: 20.h,
            ),
            _buildBottomBook(),
            SizedBox(
              height: 20.h,
            ),
          ],
        )),
      ),
    );
  }

  InteractiveViewer _buildSelectSeat() {
    return InteractiveViewer(
      transformationController: viewTransformationController,
      constrained: false,
      minScale: 0.1,
      maxScale: 1.0,
      child: StreamBuilder(
          stream: SelectSeatRepo.getListSeatCinema(
              cinema: widget.ticket.cinema!,
              movie: widget.ticket.movie!,
              date: formatDate(widget.ticket.date!),
              showtimes:
                  "${widget.ticket.showtimes} - ${widget.ticket.cinema!.rooms![0].id}"),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(context).size.height / 1.5 * 2,
                width: MediaQuery.of(context).size.width * 2,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.buttonColor,
                  ),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.active) {
              return _buildListSeat(snapshot.data!);
            }
            return Container();
          }),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${widget.ticket.cinema!.name} - ${widget.ticket.showtimes}",
            style: AppStyle.subTitleStyle,
          ),
          SizedBox(
            height: 30.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildItemInformationSeat(color: AppColors.grey, title: "Thường"),
              _buildItemInformationSeat(color: Colors.deepPurple, title: "vip"),
              _buildItemInformationSeat(
                  color: AppColors.darkBackground, title: "Đã Đặt"),
              _buildItemInformationSeat(
                  color: AppColors.buttonColor, title: "Đang chọn")
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemInformationSeat(
      {required Color color, required String title}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 15.h,
          width: 15.h,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(3.r)),
        ),
        SizedBox(
          width: 5.w,
        ),
        Text(
          title,
          style: AppStyle.defaultStyle,
        )
      ],
    );
  }

  Widget _buildBottomBook() {
    return StreamBuilder(
        stream: detailTiketController.stream,
        builder: (context, snapshot) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      "Số lượng: (${seatsSelected.length}) vé",
                      style: AppStyle.defaultStyle,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${formatPrice(getPriceListSeat(seatsSelected))} VND",
                      style: AppStyle.defaultStyle,
                    ),
                  ],
                ),
                ButtonWidget(
                  title: "Đặt Vé",
                  color: seatsSelected.isNotEmpty
                      ? AppColors.buttonColor
                      : AppColors.grey,
                  height: 40.h,
                  width: 100.w,
                  onPressed: () {
                    _onTapBookTicket();
                  },
                )
              ],
            ),
          );
        });
  }

  Widget _buildListSeat(List<Seat> seats) {
    return Container(
      decoration: const BoxDecoration(color: AppColors.background),
      padding: EdgeInsets.all(200.h),
      child: Column(
        children: [
          Center(
            child: Image.asset(AppAssets.imgScreen),
          ),
          SizedBox(
            height: 100.h,
          ),
          SizedBox(
            height: widget.ticket.cinema!.rooms![0].column! * 60.h,
            width: widget.ticket.cinema!.rooms![0].row! * 60.h,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: widget.ticket.cinema!.rooms![0].row!,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.h,
                  mainAxisExtent: 50.h),
              itemCount: seats.length,
              itemBuilder: (context, index) {
                return _buildItemSeat(seats[index]);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemSeat(Seat seat) {
    bool isSelect = false;
    for (var element in seatsSelected) {
      if (element.name == seat.name && isAwaitPayment == false) {
        if (seat.status == 1) {
          isSelect = false;
          removeSeatSelected(seat);
          break;
        }
        isSelect = true;
      }
    }
    Color? color;

    return StatefulBuilder(
      builder: (context, setState) {
        if (seat.status == 0) {
          if (isSelect) {
            color = AppColors.buttonColor;
          } else {
            switch (seat.typeSeat) {
              case TypeSeat.normal:
                color = AppColors.grey;
                break;
              case TypeSeat.vip:
                color = Colors.deepPurple;
                break;
              case TypeSeat.sweetBox:
                AppColors.orange300;
                break;
            }
          }
        } else {
          isSelect = false;
          color = AppColors.darkBackground;
        }
        return GestureDetector(
          onTap: () {
            if (seat.status == 0) {
              setState(() {
                isSelect = !isSelect;
                if (isSelect) {
                  seatsSelected.add(seat);
                } else {
                  seatsSelected.remove(seat);
                }
                detailTiketController.sink.add(null);
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: isSelect ? AppColors.buttonColor : color,
                borderRadius: BorderRadius.circular(5.r)),
            child: Text(
              seat.name,
              style: AppStyle.defaultStyle,
            ),
          ),
        );
      },
    );
  }

  String formatDate(DateTime dateTime) {
    String day = dateTime.day.toString().length == 1
        ? "0${dateTime.day}"
        : dateTime.day.toString();
    String month = dateTime.month.toString().length == 1
        ? "0${dateTime.month}"
        : dateTime.month.toString();
    return "$day-$month-${dateTime.year}";
  }

  String formatPrice(int price) {
    String formattedNumber = NumberFormat.decimalPattern().format(price);
    return formattedNumber;
  }

  void _onTapBookTicket() {
    if (seatsSelected.isNotEmpty) {
      isAwaitPayment = true;
      widget.ticket.price = getPriceListSeat(seatsSelected);
      widget.ticket.quantity = seatsSelected.length;
      widget.ticket.seats = seatsSelected.sublist(0);
      widget.ticket.seats!.sort((a, b) => a.index.compareTo(b.index));
      seatBloc.add(HoldSeatEvent(ticket: widget.ticket));
    }
  }

  int getPriceListSeat(List<Seat> seats) {
    int price = 0;
    for (var seat in seats) {
      price += seat.price;
    }
    return price;
  }

  void removeSeatSelected(Seat seat) {
    for (int i = 0; i < seatsSelected.length; i++) {
      if (seatsSelected[i].name == seat.name) {
        seatsSelected.removeAt(i);
        detailTiketController.sink.add("");
      }
    }
  }

  void _onListener(Object? state) async {
    if (state is SeatState) {
      if (state.isLoading == true) {
        DialogLoading.show(context);
      }
      if (state.isSuccess == true) {
        Navigator.of(context, rootNavigator: true).pop();
        await Navigator.pushNamed(context, RouteName.checkoutTicketScreen,
            arguments: widget.ticket);
        isAwaitPayment = false;
        seatsSelected.clear();
        detailTiketController.sink.add(null);
      }
      if (state.error != null) {
        Navigator.of(context, rootNavigator: true).pop();
        seatsSelected.clear();
        detailTiketController.sink.add(null);
        widget.ticket.seats!.clear();
        if (state.error is NoInternetException) {
          DialogError.show(
            context: context,
            message: "Không có kết nối internet, vui lòng kiểm tra lại",
          );
          return;
        }
        if (state.error is SeatReservedException) {
          DialogError.show(
            context: context,
            message: "Ghế đã được đặt, vui lòng chọn ghế khác",
          );
          return;
        }
        DialogError.show(
          context: context,
          message: "Đã có lỗi xãy ra, vui lòng thử lại",
        );
      }
    }
  }
}
