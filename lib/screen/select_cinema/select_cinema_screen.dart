import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/core/dialogs/dialog_error.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/showtimes.dart';
import 'package:ticket_app/screen/select_cinema/select_cinema_controller.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/item_day_widget.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/item_list_showtimes.dart';

class SelectCinemaScreen extends GetView<SelectCinemaController> {
  const SelectCinemaScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(title: controller.movie.name),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            _searchCity(),
            SizedBox(
              height: 20.h,
            ),
            _buildSelectDate(),
            SizedBox(
              height: 20.h,
            ),
            _builSelectCinemaType(),
            SizedBox(
              height: 20.h,
            ),
            Obx(
              () => controller.isLoading.value
                  ? _buildLoading()
                  : _buildRecomendCinema(),
            )
          ],
        ),
      )),
    );
  }

  Widget _buildLoading() => const Expanded(
        child: Center(
          child: CircularProgressIndicator(
            color: AppColors.buttonColor,
          ),
        ),
      );

  Widget _searchCity() {
    return Obx(
      () => Container(
        height: 50.h,
        width: MediaQuery.of(Get.context!).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.h),
            color: AppColors.darkBackground),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: controller.selectCity.value,
            hint: Text(
              "-- Tìm Kiếm Tĩnh Thành Phố --",
              style: AppStyle.defaultStyle,
            ),
            items: cities.map((element) {
              return DropdownMenuItem(
                value: element,
                child: Text(
                  element,
                  style: AppStyle.defaultStyle,
                ),
              );
            }).toList(),
            onChanged: (value) => controller.onChangeCity(value!),
            buttonStyleData: const ButtonStyleData(
              height: 40,
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
                  maxLines: 1,
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

  Widget _buildSelectDate() {
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        itemBuilder: (context, index) {
          return Obx(
            () => ItemDayWidget(
              day: controller.listDateTime[index].day,
              isActive: index == controller.currentSelectedDateIndex.value,
              onTap: () => controller.onTapSelectDate(index),
            ),
          );
        },
      ),
    );
  }

  Widget _builSelectCinemaType() {
    return Obx(
      () => SizedBox(
        height: 80.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            GestureDetector(
              onTap: () => controller.onTapCinemaType(0),
              child: Stack(
                children: [
                  Container(
                    height: 50.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(10.h),
                        border: Border.all(
                            color:
                                controller.currentSelctCinemaTypeIndex.value ==
                                        0
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
            _buildItemCinemaType(
              title: "CGV",
              isACtive: controller.currentSelctCinemaTypeIndex.value == 1,
              prices: Get.context!
                  .read<DataAppProvider>()
                  .ticketPrices!
                  .cgv
                  .ticket2D
                  .normal,
              img: AppAssets.imgCGV,
              onTap: () => controller.onTapCinemaType(1),
            ),
            SizedBox(
              width: 20.w,
            ),
            _buildItemCinemaType(
              title: "Lotte",
              isACtive: controller.currentSelctCinemaTypeIndex.value == 2,
              prices: Get.context!
                  .read<DataAppProvider>()
                  .ticketPrices!
                  .lotte
                  .ticket2D
                  .before5pm
                  .normal,
              img: AppAssets.imgLotte,
              onTap: () => controller.onTapCinemaType(2),
            ),
            SizedBox(
              width: 20.w,
            ),
            _buildItemCinemaType(
              title: "Galaxy",
              isACtive: controller.currentSelctCinemaTypeIndex.value == 3,
              prices: Get.context!
                  .read<DataAppProvider>()
                  .ticketPrices!
                  .galaxy
                  .ticket2D
                  .before5pm,
              img: AppAssets.imgGalaxy,
              onTap: () => controller.onTapCinemaType(3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCinemaType({
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

  Widget _buildRecomendCinema() {
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
                () => controller.locationPermisstion.value !=
                        PermissionStatus.granted
                    ? GestureDetector(
                        onTap: () => controller.resquestPermission(),
                        child: Icon(
                          Icons.error,
                          color: AppColors.white,
                          size: 25.h,
                        ),
                      )
                    : Container(),
              )
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Obx(
            () => Expanded(
              child: controller.showtimesByCinemaType.isNotEmpty
                  ? ListView.builder(
                      itemCount: controller.showtimesByCinemaType.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            _buildItemCinema(
                              showtimes:
                                  controller.showtimesByCinemaType[index],
                            ),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        );
                      },
                    )
                  : Center(
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
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItemCinema({required Showtimes showtimes}) {
    bool isShowMore = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            setState(() {
              isShowMore = !isShowMore;
            });
          },
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 30.h,
                    width: 30.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        showtimes.cinema!.getImageCinem(),
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
                          showtimes.cinema!.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.titleStyle.copyWith(fontSize: 14.sp),
                        ),
                        Text(
                          showtimes.cinema!.address,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style:
                              AppStyle.defaultStyle.copyWith(fontSize: 10.sp),
                        )
                      ],
                    ),
                  ),
                  isShowMore
                      ? Container(
                          width: 80.w,
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.white,
                            size: 30.h,
                          ))
                      : SizedBox(
                          width: 80.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                showtimes.cinema!.getDistanceFormat(),
                                style: AppStyle.defaultStyle.copyWith(
                                    color: AppColors.buttonColor,
                                    fontSize: 10.sp),
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
              SizedBox(
                height: 10.h,
              ),
              Visibility(
                visible: isShowMore,
                child: Column(
                  children: [
                    BuildListShowtimnes(
                      movieTimes: showtimes.times,
                      crossAxisCount: 3,
                      title: "Phim 2D Phụ Đề",
                      onTap: (index) => controller.onTapShowtimes(
                        showtimes,
                        index,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
