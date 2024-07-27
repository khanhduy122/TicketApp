import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/screen/checkout_ticket/checkout_ticket_controller.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class CheckoutTicketScreen extends GetView<CheckoutTicketController> {
  const CheckoutTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => controller.cancelSeat(),
      child: Scaffold(
        appBar: appBarWidget(
          title: "Thanh Toán",
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
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
                Divider(
                  height: 2.h,
                  color: AppColors.white,
                ),
                SizedBox(
                  height: 20.h,
                ),
                _buildSelectVoucher(context),
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
                    onPressed: () => controller.onTapCheckout(),
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

  GestureDetector _buildSelectVoucher(BuildContext context) {
    return GestureDetector(
      onTap: () async {},
      child: Container(
        height: 50.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(border: Border.all(color: AppColors.grey)),
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
                child: controller.voucherSelected.value != null
                    ? Text(
                        "-${controller.formatPrice(controller.voucherSelected.value!.priceDiscount)}",
                        style: AppStyle.subTitleStyle,
                        textAlign: TextAlign.end,
                      )
                    : Container())
          ],
        ),
      ),
    );
  }

  SizedBox _buidHeader() {
    return SizedBox(
      height: 1.sh / 4,
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
              Obx(
                () => Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                      color: AppColors.buttonColor,
                      borderRadius: BorderRadius.circular(5.h)),
                  child: Text(
                    controller
                        .formatTimeCountDown(controller.currentSecond.value),
                    style:
                        AppStyle.defaultStyle.copyWith(color: AppColors.white),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageNetworkWidget(
                url: controller.ticket.movie!.thumbnail!,
                height: 0.18.sh,
                width: 100.w,
                boxFit: BoxFit.cover,
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
                      controller.ticket.movie!.name!,
                      maxLines: 3,
                      style: AppStyle.subTitleStyle,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      controller.ticket.movie!.getCaterogies(),
                      style: AppStyle.defaultStyle,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "${controller.ticket.movie!.duration} phút",
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
    return Column(
      children: [
        SizedBox(height: 20.h),
        _buildItemInformation(title: "ID: ", value: controller.id),
        SizedBox(height: 20.h),
        _buildItemInformation(
          title: "Rạp: ",
          value: controller.ticket.cinema!.name,
        ),
        SizedBox(height: 20.h),
        _buildItemInformation(
          title: "Ngày giờ: ",
          value: controller.formatDateTime(
            showtimes: controller.ticket.showtimes!.time,
            dateTime: controller.ticket.date!,
          ),
        ),
        SizedBox(height: 20.h),
        _buildItemInformation(
          title: "Ghế: ",
          value: controller.formatListSeat(),
        ),
        SizedBox(height: 20.h),
        _buildItemInformation(
          title: "Giá vé: ",
          value: controller.formatPrice(
            controller.ticket.price! - controller.getPriceFood(),
          ),
        ),
        SizedBox(height: 20.h),
        _buildItemInformation(
          title: "Combo bắp nước: ",
          value: controller.ticket.foods == null ||
                  controller.ticket.foods!.isEmpty
              ? "0 VND"
              : "${controller.formatPrice(controller.getPriceFood())} VND",
        ),
        SizedBox(height: 20.h),
        _buildItemInformation(
          title: "Giảm giá: ",
          value: controller.voucherSelected.value == null
              ? "0 VND"
              : "${controller.formatPrice(controller.voucherSelected.value!.priceDiscount)} VND",
        ),
        SizedBox(height: 20.h),
        _buildItemInformation(
          title: "Tổng tiền: ",
          value: "${controller.formatPrice(controller.ticket.price!)} VND",
        ),
        SizedBox(height: 20.h),
      ],
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
}
