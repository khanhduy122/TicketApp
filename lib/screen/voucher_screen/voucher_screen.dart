import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
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
      body: StreamBuilder(
        stream: UserRepo.getListVoucher(), 
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if(snapshot.connectionState == ConnectionState.active){
            return _buildListVoucher(snapshot.data!);
          }
          return Container();
        },
      )
    );
  }

  Widget _buildListVoucher(List<Voucher> vouchers) {
    if(vouchers.isEmpty){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SizedBox(
              height: 100.h,
              width: 100.w,
              child: Image.asset(AppAssets.imgEmpty),
            )
          ),
        ],
      );
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: vouchers.length,
            itemBuilder: (context, index) {
              return _buildVoucherItem();
            },
        )
        )
      ],
    );
  }

  Widget _buildVoucherItem() {
    return Column(
      children: [
        Container(),
      ],
    );
  }
}