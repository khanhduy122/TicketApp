import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/models/payment_card.dart';
import 'package:ticket_app/screen/select_card/select_card_controller.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class SelectCardScreen extends GetView<SelectCardController> {
  const SelectCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isShowWebview.value
          ? _buildWebView()
          : _buildMethodPayment(context),
    );
  }

  Widget _buildWebView() {
    return Scaffold(
      appBar: appBarWidget(
        title: 'Thêm phương thức thanh toán',
        onTap: () {
          controller.isShowWebview.value = false;
        },
      ),
      body: Obx(
        () => controller.isLoadingWebView.value
            ? _buildLoading()
            : WebViewWidget(controller: controller.webViewController),
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

  Widget _buildMethodPayment(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: appBarWidget(title: 'Tài khoản thanh toán'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40.h,
              ),
              _buildListCard(controller.listCard),
              SizedBox(
                height: 50.h,
              ),
              _buildButtonAddCard(
                onTap: () {},
              ),
              SizedBox(
                height: 20.h,
              ),
              ButtonWidget(
                title: "Thanh Toán",
                height: 50.h,
                color: controller.currentIndex.value == 1000
                    ? AppColors.darkBackground
                    : AppColors.buttonColor,
                width: MediaQuery.of(context).size.width,
                onPressed: () => controller.onTapPayment(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCard(List<PaymentCard> listCard) {
    return listCard.isEmpty
        ? Center(
            child: Text(
              "Chưa có liên kết tài khoản ngân hàng",
              style: AppStyle.defaultStyle,
            ),
          )
        : SizedBox(
            height: listCard.length * 65.h,
            child: ListView.builder(
              itemCount: listCard.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _buildItemCard(
                      card: listCard[index],
                      isSelected: controller.currentIndex.value == index,
                      onTap: () {
                        controller.currentIndex.value = index;
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                );
              },
            ),
          );
  }

  Widget _buildItemCard(
      {required PaymentCard card,
      required bool isSelected,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        decoration: BoxDecoration(
            color: AppColors.darkBackground,
            borderRadius: BorderRadius.circular(5.r),
            border: Border.all(
                color: isSelected
                    ? AppColors.buttonColor
                    : AppColors.darkBackground)),
        child: Row(
          children: [
            SizedBox(
                height: 50.h,
                width: 50.h,
                child: Image.asset(card.getLogoCard())),
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: Text(
                card.cardNumber!,
                style: AppStyle.defaultStyle,
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

  Widget _buildButtonAddCard({required Function() onTap}) {
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all<Size>(Size(1.sw, 50.h)),
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        foregroundColor:
            MaterialStateProperty.all<Color>(AppColors.buttonPressColor),
      ),
      onPressed: () => controller.onTapCreateMethodPaymemt(),
      child: Row(
        children: [
          Expanded(
              child: Text(
            "Thêm phương thức thanh toán",
            style:
                AppStyle.subTitleStyle.copyWith(color: AppColors.buttonColor),
          )),
          const Icon(
            Icons.add,
            color: AppColors.buttonColor,
          )
        ],
      ),
    );
  }
}
