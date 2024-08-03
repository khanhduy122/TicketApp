import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/core/const/logger.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/models/voucher.dart';
import 'package:ticket_app/screen/select_voucher/select_voucher_controller.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class SelectVoucherScreen extends GetView<SelectVoucherController> {
  const SelectVoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appBarWidget(title: "Chọn Mã Giảm Giá"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => controller.isLoading.value
                    ? _buildLoading()
                    : controller.isLoadFaild.value
                        ? _buildLoadFaild()
                        : _buildListVoucher(),
              ),
            ),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildListVoucher() {
    if (controller.vouchers.isEmpty) {
      return _buildEmpty();
    }

    return ListView.builder(
      itemCount: controller.vouchers.length,
      itemBuilder: (context, index) {
        final voucher = controller.vouchers[index];
        return Column(
          children: [
            _buildVoucherItem(voucher),
            SizedBox(
              height: 10.h,
            ),
          ],
        );
      },
    );
  }

  Column _buildEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 100.h,
          width: 100.h,
          child: Image.asset(AppAssets.imgEmpty),
        ),
        SizedBox(
          height: 10.h,
          width: 1.sw,
        ),
        Text(
          'Không có phiếu ưu đãi',
          style: AppStyle.defaultStyle,
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return const SizedBox.expand(
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.buttonColor,
        ),
      ),
    );
  }

  Widget _buildLoadFaild() {
    return SizedBox.expand(
      child: Center(
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget _buildVoucherItem(Voucher voucher) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
          color: AppColors.darkBackground,
          borderRadius: BorderRadius.circular(5.r)),
      child: Row(
        children: [
          SizedBox(
            width: 10.w,
          ),
          GestureDetector(
            onTap: () =>
                Get.toNamed(RouteName.detailVoucherScreen, arguments: voucher),
            child: Container(
              height: 40.h,
              width: 40.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: AssetImage(
                    voucher.getImageVoucher(),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => Get.toNamed(
                RouteName.detailVoucherScreen,
                arguments: voucher,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(voucher.title, style: AppStyle.titleStyle),
                  Text(
                    voucher.getStringAppliesToCinemas(),
                    style: AppStyle.defaultStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    formatExpiredTime(voucher.expiredTime),
                    style: AppStyle.defaultStyle,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          GestureDetector(
            onTap: () => Get.back(result: voucher),
            child: Text(
              'Dùng ngày',
              style: AppStyle.subTitleStyle.copyWith(
                color: AppColors.buttonColor,
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
    );
  }

  String formatExpiredTime(int expiredTime) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(expiredTime * 1000);
    return "HSD: ${DateFormat("dd-MM-yyyy").format(date)}";
  }
}
