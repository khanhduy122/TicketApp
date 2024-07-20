import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/models/voucher.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/divider_custom.dart';

class DetailVoucherScreen extends StatefulWidget {
  const DetailVoucherScreen({super.key, required this.voucher});

  final Voucher voucher;

  @override
  State<DetailVoucherScreen> createState() => _DetailVoucherScreenState();
}

class _DetailVoucherScreenState extends State<DetailVoucherScreen> {
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
                    height: 100.h,
                    width: 100.h,
                    child: Image.asset(AppAssets.imgLogo),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text(
                    widget.voucher.title,
                    style: AppStyle.titleStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    "cho hóa đơn từ ${widget.voucher.applyInvoices}đ",
                    style: AppStyle.defaultStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    padding: EdgeInsets.all(10.h),
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: Text(
                      formatExpiredTime(widget.voucher.expiredTime),
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
                          widget.voucher.getStringAppliesToCinemas(),
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
                          widget.voucher.informations.replaceAll('\\n', '\n'),
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
    DateTime expiredTimeFormat =
        DateTime.fromMillisecondsSinceEpoch(expiredTime, isUtc: true);

    Duration difference = expiredTimeFormat.difference(DateTime.now());
    if (difference.inDays.abs() > 0) {
      return "Hạn sử dụng đến hết ngày ${DateFormat("dd-MM-yyyy").format(expiredTimeFormat)}";
    }
    return "Hiệu lực còn ${difference.inHours}";
  }
}
