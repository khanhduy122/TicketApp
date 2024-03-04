import 'package:flutter/material.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/models/voucher.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';

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
      body: Column(
        children: [
          Expanded(
              child: Column(
            children: [],
          ))
        ],
      ),
    ));
  }
}
