import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class DetailMyTicketScreen extends StatefulWidget {
  const DetailMyTicketScreen({
    super.key,
  });

  @override
  State<DetailMyTicketScreen> createState() => _DetailMyTicketScreenState();
}

class _DetailMyTicketScreenState extends State<DetailMyTicketScreen> {
  final ticket = Get.arguments as Ticket;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: "Chi Tiết"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20.h),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: AppColors.seccondBackgroud,
                  borderRadius: BorderRadius.circular(10.r)),
            ),
            _builDetailTicket(context),
          ],
        ),
      ),
    );
  }

  Container _builDetailTicket(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(20.h),
      child: Column(
        children: [
          Expanded(
              flex: 7,
              child: Column(
                children: [_buidHeader(), _buildInformationTicket()],
              )),
          Expanded(
            flex: 3,
            child: QrImageView(
              data: ticket.ticketId!.toString(),
              backgroundColor: AppColors.white,
              version: QrVersions.auto,
            ),
          )
        ],
      ),
    );
  }

  SizedBox _buidHeader() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageNetworkWidget(
            url: ticket.movie!.thumbnail!,
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
                  ticket.movie!.name!,
                  maxLines: 3,
                  style: AppStyle.subTitleStyle,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  ticket.movie!.getCaterogies(),
                  maxLines: 3,
                  style: AppStyle.defaultStyle,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "${ticket.movie!.duration} phút",
                  style: AppStyle.defaultStyle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildInformationTicket() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildItemInformation(
              title: "ID: ", value: ticket.ticketId!.toString()),
          _buildItemInformation(title: "Rạp: ", value: ticket.cinema!.name),
          _buildItemInformation(
            title: "Ngày giờ: ",
            value: ticket.formatDateTime(),
          ),
          _buildItemInformation(title: "Ghế: ", value: ticket.getSeatString()),
          _buildItemInformation(
            title: "Tổng tiền: ",
            value: "${formatPrice(ticket.price!)} VND",
          ),
          SizedBox(
            height: 10.h,
          )
        ],
      ),
    );
  }

  Widget _buildItemInformation({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          maxLines: 10,
          textAlign: TextAlign.end,
        )),
      ],
    );
  }

  String formatPrice(int price) {
    String formattedNumber = NumberFormat.decimalPattern().format(price);
    return formattedNumber;
  }
}
