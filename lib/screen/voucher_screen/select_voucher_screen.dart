import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/voucher.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';

// ignore: must_be_immutable
class SelectVoucherScreen extends StatefulWidget {
  SelectVoucherScreen(
      {super.key, this.voucherSelected, required this.cinemasType});

  Voucher? voucherSelected;
  final CinemasType cinemasType;

  @override
  State<SelectVoucherScreen> createState() => _SelectVoucherScreenState();
}

class _SelectVoucherScreenState extends State<SelectVoucherScreen> {
  List<Voucher> vouchers = [];
  int appliesToCinemas = 0;

  @override
  void initState() {
    switch (widget.cinemasType) {
      case CinemasType.CGV:
        appliesToCinemas = 1;
        break;
      case CinemasType.Galaxy:
        appliesToCinemas = 2;
        break;
      case CinemasType.Lotte:
        appliesToCinemas = 3;
        break;
    }
    vouchers.where((element) => (element.appliesToCinemas == 0 ||
        element.appliesToCinemas == appliesToCinemas));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: appBarWidget(title: "Chọn Mã Giảm Giá"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            // Expanded(
            //     child: _buildListVoucher(
            //         context.read<DataAppProvider>().vouchers)),
            ButtonWidget(
                title: "Ok",
                height: 50.h,
                width: 250.w,
                onPressed: () {
                  Navigator.of(context).pop(widget.voucherSelected);
                }),
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildListVoucher(List<Voucher> vouchers) {
    if (vouchers.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Center(
            child: SizedBox(
              height: 100.h,
              width: 100.w,
              child: Image.asset(AppAssets.imgEmpty),
            ),
          )),
        ],
      );
    }
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
          itemCount: vouchers.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                _buildVoucherItem(
                    vouchers[index],
                    (widget.voucherSelected != null &&
                        vouchers[index].id == widget.voucherSelected!.id)),
                SizedBox(
                  height: 10.h,
                )
              ],
            );
          },
        ))
      ],
    );
  }

  Widget _buildVoucherItem(Voucher voucher, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.voucherSelected != null &&
              voucher.id == widget.voucherSelected!.id) {
            widget.voucherSelected = null;
          } else {
            widget.voucherSelected = voucher;
          }
        });
      },
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
            color: AppColors.darkBackground,
            borderRadius: BorderRadius.circular(5.r)),
        child: Row(
          children: [
            Container(
              height: 60.h,
              width: 60.w,
              decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage(AppAssets.imgLogo))),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(voucher.title, style: AppStyle.titleStyle),
                  Text(
                    "Hóa đơn tối thiểu ${voucher.applyInvoices}đ",
                    style: AppStyle.defaultStyle,
                  ),
                  Text(
                    formatExpiredTime(voucher.expiredTime),
                    style: AppStyle.defaultStyle,
                  )
                ],
              ),
            ),
            Radio(
              fillColor:
                  MaterialStateProperty.all<Color>(AppColors.buttonColor),
              activeColor: AppColors.buttonColor,
              value: isSelected,
              groupValue: true,
              onChanged: (value) {},
            )
          ],
        ),
      ),
    );
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
