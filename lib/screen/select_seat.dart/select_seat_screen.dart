// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/models/seat.dart';
import 'package:ticket_app/screen/select_seat.dart/select_seat_controller.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class SelectSeatScreen extends GetView<SelectSeatController> {
  const SelectSeatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.seccondBackgroud,
      appBar: appBarWidget(
        title: controller.movie.name,
        color: AppColors.seccondBackgroud,
      ),
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
    );
  }

  Widget _buildSelectSeat() {
    return Obx(
      () => controller.isLoading.value
          ? _buildLoading()
          : InteractiveViewer(
              transformationController: controller.viewTransformationController,
              constrained: false,
              minScale: 0.1,
              maxScale: 1.0,
              child: _buildListSeat(),
            ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.buttonColor,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "${controller.cinema.name} - ${controller.time.time}",
            style: AppStyle.subTitleStyle,
          ),
          SizedBox(
            height: 30.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildItemInformationSeat(color: AppColors.grey, title: "Thường"),
              _buildItemInformationSeat(color: AppColors.purple, title: "vip"),
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
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Số lượng: (${controller.seatsSelected.length}) vé",
                  style: AppStyle.defaultStyle,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "${controller.formatPrice(controller.getPriceListSeat())} VND",
                  style: AppStyle.defaultStyle,
                ),
              ],
            ),
            ButtonWidget(
              title: "Đặt Vé",
              color: controller.seatsSelected.isNotEmpty
                  ? AppColors.buttonColor
                  : AppColors.grey,
              height: 40.h,
              width: 100.w,
              onPressed: () => controller.onTapBookTicket(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListSeat() {
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
          Obx(
            () => SizedBox(
              height: controller.room.column! * 60.h,
              width: controller.room.row! * 60.h,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: controller.room.row!,
                  mainAxisSpacing: 10.h,
                  crossAxisSpacing: 10.h,
                  mainAxisExtent: 50.h,
                ),
                itemCount: controller.listSeat.length,
                itemBuilder: (context, index) {
                  final seat = controller.listSeat[index];
                  return _buildItemSeat(seat);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemSeat(ItemSeat seat) {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.onSelectSeat(seat),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: controller.seatsSelected.contains(seat)
                  ? AppColors.buttonColor
                  : controller.getColorSeat(seat),
              borderRadius: BorderRadius.circular(5.r)),
          child: Text(
            seat.name,
            style: AppStyle.defaultStyle,
          ),
        ),
      ),
    );
  }
}
