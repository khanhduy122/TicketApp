import 'dart:math';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/screen/main_screen/choose_cinema/choose_cinema_controller.dart';
import 'package:ticket_app/widgets/button_widget.dart';

class ChooseCinemaScreen extends GetView<ChooseCinemaController> {
  const ChooseCinemaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            _searchCity(),
            SizedBox(
              height: 20.h,
            ),
            _selectCinemaType(),
            SizedBox(
              height: 20.h,
            ),
            _recomendCinema(context),
          ],
        ),
      )),
    );
  }

  Widget _searchCity() {
    return Obx(
      () => Container(
        height: 50.h,
        width: MediaQuery.of(Get.context!).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.h),
            color: AppColors.darkBackground),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: controller.selectCity.value,
            items: cities.map((element) {
              return DropdownMenuItem(
                value: element,
                child: Text(
                  element,
                  style: AppStyle.defaultStyle,
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value == null) return;

              controller.onChangeCity(value, controller.position);
            },
            buttonStyleData: ButtonStyleData(
              height: 40,
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            dropdownStyleData: DropdownStyleData(
                maxHeight: MediaQuery.of(Get.context!).size.height / 2,
                decoration:
                    const BoxDecoration(color: AppColors.darkBackground)),
            menuItemStyleData: MenuItemStyleData(
                height: 40,
                overlayColor: MaterialStateProperty.all<Color>(
                    AppColors.buttonPressColor)),
            dropdownSearchData: DropdownSearchData(
              searchController: controller.searchCityTextController,
              searchInnerWidgetHeight: 50,
              searchInnerWidget: Container(
                height: 50,
                padding: const EdgeInsets.only(
                  top: 8,
                  bottom: 4,
                  right: 8,
                  left: 8,
                ),
                child: TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: controller.searchCityTextController,
                  style: AppStyle.defaultStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    hintText: '-- Tìm Kiếm Tĩnh Thành Phố --',
                    hintStyle: AppStyle.defaultStyle,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.white),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value
                    .toString()
                    .toLowerCase()
                    .contains(searchValue.toLowerCase());
              },
            ),
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                controller.searchCityTextController.clear();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _selectCinemaType() {
    return Obx(
      () => SizedBox(
        height: 80.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            GestureDetector(
              onTap: () {
                controller.onSelectCinemaType(0);
              },
              child: Stack(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.h),
                        border: Border.all(
                            color: controller.currentIndexCinemaType.value == 0
                                ? AppColors.buttonColor
                                : AppColors.grey,
                            width: 2.h)),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.h),
                            image: const DecorationImage(
                                image: AssetImage(AppAssets.icRecommend),
                                fit: BoxFit.scaleDown)),
                      ),
                      Center(
                        child: Text(
                          "Tất Cả",
                          style: AppStyle.defaultStyle,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            _itemCinemaType(
              title: "CGV",
              isACtive: controller.currentIndexCinemaType.value == 1,
              img: AppAssets.imgCGV,
              prices: Get.context!
                  .read<DataAppProvider>()
                  .ticketPrices!
                  .cgv
                  .ticket2D
                  .normal,
              onTap: () {
                controller.onSelectCinemaType(1);
              },
            ),
            SizedBox(
              width: 20.w,
            ),
            _itemCinemaType(
              title: "Lotte",
              isACtive: controller.currentIndexCinemaType.value == 2,
              prices: Get.context!
                  .read<DataAppProvider>()
                  .ticketPrices!
                  .lotte
                  .ticket2D
                  .before5pm
                  .normal,
              img: AppAssets.imgLotte,
              onTap: () {
                controller.onSelectCinemaType(2);
              },
            ),
            SizedBox(
              width: 20.w,
            ),
            _itemCinemaType(
              title: "Galaxy",
              isACtive: controller.currentIndexCinemaType.value == 3,
              prices: Get.context!
                  .read<DataAppProvider>()
                  .ticketPrices!
                  .galaxy
                  .ticket2D
                  .before5pm,
              img: AppAssets.imgGalaxy,
              onTap: () {
                controller.onSelectCinemaType(3);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemCinemaType({
    required String title,
    required String img,
    required bool isACtive,
    required int prices,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 50.h,
            width: 50.h,
            foregroundDecoration: RotatedCornerDecoration.withColor(
              color: AppColors.buttonColor,
              badgeSize: const Size(35, 35),
              badgeCornerRadius: Radius.circular(10.h),
              badgePosition: BadgePosition.topEnd,
              textSpan: TextSpan(
                text: controller.formatPrice(prices),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.h),
              border: Border.all(
                color: isACtive ? AppColors.buttonColor : AppColors.grey,
                width: 2.h,
              ),
              image: DecorationImage(
                image: AssetImage(img),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: AppStyle.defaultStyle,
            ),
          )
        ],
      ),
    );
  }

  Widget _recomendCinema(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rạp Đề Xuất",
                style: AppStyle.titleStyle,
              ),
              Obx(
                () {
                  if (controller.locationPermisstion.value !=
                          PermissionStatus.granted &&
                      controller.currentCinemaCity.value != null) {
                    return GestureDetector(
                      onTap: controller.onTapWaring,
                      child: Icon(
                        Icons.error,
                        size: 30.sp,
                        color: AppColors.red,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Obx(() {
            return Expanded(
              child: controller.isLoading.value
                  ? _buildLoadding()
                  : controller.locationPermisstion.value !=
                              PermissionStatus.granted &&
                          controller.currentCinemaCity.value == null
                      ? _buildPermissionDeny(context)
                      : controller.fillterCinema.isNotEmpty
                          ? _buildListCinema()
                          : _buildListCinemaEmpty(),
            );
          })
        ],
      ),
    );
  }

  Widget _buildLoadding() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.buttonColor,
      ),
    );
  }

  Center _buildListCinemaEmpty() {
    return Center(
      child: Column(
        children: [
          Image.asset(AppAssets.imgEmpty),
          SizedBox(
            height: 20.h,
          ),
          Text(
            "Không có rạp phim",
            style: AppStyle.defaultStyle,
          )
        ],
      ),
    );
  }

  ListView _buildListCinema() {
    return ListView.builder(
      controller: controller.scrollController,
      itemCount: controller.fillterCinema.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            _itemCinema(controller.fillterCinema[index]),
            SizedBox(
              height: 20.h,
            )
          ],
        );
      },
    );
  }

  Center _buildPermissionDeny(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(AppAssets.imgEmpty),
          SizedBox(
            height: 20.h,
          ),
          Text(
            "Cho phép truy cập vào vị trí mở mục cài đặt của điện thoại để MovieTicket có thể gợi ý cho bạn rạp phim gần nhất",
            style: AppStyle.defaultStyle,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 20.h,
          ),
          ButtonWidget(
            title: "Cho phép",
            width: 0.5.sw,
            onPressed: () {
              controller.resquestPermission(context);
            },
          )
        ],
      ),
    );
  }

  Widget _itemCinema(Cinema cinema) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.selectMovieScreen, arguments: cinema);
      },
      child: Row(
        children: [
          SizedBox(
            height: 30.h,
            width: 30.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.asset(
                cinema.getImageCinem(),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  cinema.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.titleStyle.copyWith(fontSize: 14.sp),
                ),
                Text(
                  cinema.address,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.defaultStyle.copyWith(fontSize: 10.sp),
                )
              ],
            ),
          ),
          SizedBox(
              width: 80.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    cinema.getDistanceFormat(),
                    style: AppStyle.defaultStyle.copyWith(
                        color: AppColors.buttonColor, fontSize: 10.sp),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.buttonColor,
                    size: 20.h,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
