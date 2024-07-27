import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/models/food.dart';
import 'package:ticket_app/screen/select_food/select_food_controller.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class SelectFoodScreen extends GetView<SelectFoodController> {
  const SelectFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => controller.cancelSeat(),
      child: Scaffold(
        appBar: appBarWidget(title: "Combo Bắp Nước"),
        body: Obx(
          () => controller.isLoading.value
              ? _buildLoading()
              : controller.isLoadFaild.value
                  ? _buildLoadFaild()
                  : _buildListFood(),
        ),
      ),
    );
  }

  Widget _buildListFood() {
    return SizedBox.expand(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: ListView.builder(
          itemCount: controller.foodDetail.data.length,
          itemBuilder: (context, index) {
            final item = controller.foodDetail.data[index];
            return Column(
              children: [
                buildFoodItem(item, index),
                SizedBox(
                  height: 20.h,
                ),
                if (index == controller.foodDetail.data.length - 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(
                        () => Text(
                          controller.getPriceFood(),
                          style: AppStyle.subTitleStyle,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      ButtonWidget(
                        title: 'Tiếp Tục',
                        onPressed: () => controller.onTapContinue(),
                      ),
                    ],
                  )
              ],
            );
          },
        ),
      ),
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
          icon: const Icon(
            Icons.refresh,
          ),
        ),
      ),
    );
  }

  Widget buildFoodItem(FoodItem item, int index) {
    return SizedBox(
      width: double.infinity,
      height: 100.h,
      child: Row(
        children: [
          ImageNetworkWidget(
            url: item.thumbnail,
            height: 100.h,
            width: 100.h,
            boxFit: BoxFit.contain,
          ),
          SizedBox(
            width: 10.w,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                item.name,
                style: AppStyle.subTitleStyle,
              ),
              Text(
                controller.formatPrice(item.price),
                style: AppStyle.titleStyle,
              ),
              Row(
                children: [
                  Container(
                    height: 30.h,
                    width: 30.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.grey),
                    ),
                    child: GestureDetector(
                      onTap: () => controller.onTapDecrease(index),
                      child: const Icon(
                        Icons.remove,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Obx(
                    () => Text(
                      controller.listQuantity[index].toString(),
                      style: AppStyle.titleStyle,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    height: 30.h,
                    width: 30.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.buttonColor),
                    ),
                    child: GestureDetector(
                      onTap: () => controller.onTapIncrease(index),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.buttonColor,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
