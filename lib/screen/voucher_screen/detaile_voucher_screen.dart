import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/models/voucher.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/divider_custom.dart';

class DetailVoucherScreen extends StatefulWidget {
  const DetailVoucherScreen({super.key});

  @override
  State<DetailVoucherScreen> createState() => _DetailVoucherScreenState();
}

class _DetailVoucherScreenState extends State<DetailVoucherScreen> {
  final voucher = Get.arguments as Voucher;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appBarWidget(title: "Chi Tiết Mã Giảm Giá"),
      body: Padding(
        padding: EdgeInsets.all(20.h),
        child: Column(
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(
                  color: AppColors.darkBackground,
                  borderRadius: BorderRadius.circular(10.r)),
              child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    height: 70.h,
                    width: 70.h,
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
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text(
                    voucher.title,
                    style: AppStyle.titleStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  // Text(
                  //   "cho hóa đơn từ ${widget.voucher.applyInvoices}đ",
                  //   style: AppStyle.defaultStyle,
                  // ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Text(
                      formatExpiredTime(voucher.expiredTime),
                      style:
                          AppStyle.subTitleStyle.copyWith(color: Colors.black),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const DividerCustom(),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Áp dụng",
                          style: AppStyle.subTitleStyle,
                        ),
                        SizedBox(
                          height: 5,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Text(
                          voucher.getStringAppliesToCinemas(),
                          style: AppStyle.defaultStyle,
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Ưu Đãi",
                          style: AppStyle.subTitleStyle,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          voucher.description,
                          style: AppStyle.defaultStyle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    ));
  }

  String formatExpiredTime(int expiredTime) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(expiredTime * 1000);
    return "HSD: ${DateFormat("dd-MM-yyyy").format(date)}";
  }
}
