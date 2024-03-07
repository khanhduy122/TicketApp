import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/voucher.dart';
import 'package:ticket_app/moduels/user/user_repo.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';

class VoucherScreen extends StatefulWidget {
  const VoucherScreen({super.key});

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(title: "Voucher"),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: StreamBuilder(
            stream: UserRepo.getListVoucherStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.connectionState == ConnectionState.active) {
                context
                    .read<DataAppProvider>()
                    .setListVoucher(vouchers: snapshot.data!);
                return _buildListVoucher(snapshot.data!);
              }
              return Container();
            },
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
                _buildVoucherItem(vouchers[index]),
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

  Widget _buildVoucherItem(Voucher voucher) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteName.detailVoucherScreen,
            arguments: voucher);
      },
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
            color: AppColors.darkBackground,
            borderRadius: BorderRadius.circular(5.r)),
        child: Row(
          children: [
            Container(
              height: 80.h,
              width: 80.w,
              decoration: BoxDecoration(
                  color: AppColors.buttonPressColor,
                  image: DecorationImage(image: AssetImage(AppAssets.imgLogo))),
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
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
