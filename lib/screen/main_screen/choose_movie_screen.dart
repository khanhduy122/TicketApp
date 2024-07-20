import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/models/banner.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/home_data.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/rating_widget.dart';

class ChooseMovieScreen extends StatefulWidget {
  const ChooseMovieScreen({super.key});

  @override
  State<ChooseMovieScreen> createState() => _ChooseMovieScreenState();
}

class _ChooseMovieScreenState extends State<ChooseMovieScreen> {
  late final HomeData _homeData;

  @override
  void initState() {
    super.initState();
    _homeData = context.read<DataAppProvider>().homeData!;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            _appBar(),
            SizedBox(
              height: 20.h,
            ),
            _banner(size),
            SizedBox(
              height: 30.h,
            ),
            _nowPlaying(),
            SizedBox(
              height: 30.h,
            ),
            _comingSoon()
          ],
        ),
      )),
    );
  }

  Widget _banner(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
              items: _homeData.banners.map((e) {
                return Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTap: () => _onTapBanner(e),
                      child: ImageNetworkWidget(
                        borderRadius: 10.h,
                        url: e.thumbnail,
                        height: 150.h,
                        width: size.width,
                        boxFit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                viewportFraction: 1,
                height: 150.h,
                autoPlay: true,
              )),
        ],
      ),
    );
  }

  Widget _nowPlaying() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Đang Khởi Chiếu", style: AppStyle.titleStyle),
          SizedBox(
            height: 20.h,
          ),
          CarouselSlider(
            items: _homeData.nowShowings.map((element) {
              return _buildItemNowShowing(element);
            }).toList(),
            options: CarouselOptions(
                viewportFraction: 0.7,
                height: 470.h,
                enlargeCenterPage: true,
                enlargeFactor: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildItemNowShowing(Movie movie) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.detailMovieScreen, arguments: movie);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              ImageNetworkWidget(
                height: 300,
                width: 200,
                url: movie.thumbnail!,
                borderRadius: 10.h,
              ),
              Positioned(
                  top: 10.h,
                  left: 10.w,
                  child: Container(
                    height: 20.h,
                    width: 40.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.h),
                        color: movie.ban == Ban.c13
                            ? AppColors.orange300
                            : movie.ban == Ban.c16
                                ? Colors.orange
                                : movie.ban == Ban.c18
                                    ? AppColors.red
                                    : Colors.green),
                    child: Text(
                      movie.getBan(),
                      style: AppStyle.defaultStyle.copyWith(fontSize: 10.sp),
                    ),
                  )),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            movie.name!,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.titleStyle,
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            movie.getCaterogies(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.defaultStyle.copyWith(fontSize: 12.sp),
          ),
          SizedBox(
            height: 10.h,
          ),
          RatingWidget(
            rating: movie.rating ?? 0,
            total: movie.totalReview ?? 0,
            isCenter: true,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ButtonWidget(
                title: "Đặt Vé",
                height: 40.h,
                width: 90.w,
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.detailMovieScreen,
                      arguments: movie);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _comingSoon() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sắp Được Khởi Chiếu",
            style: AppStyle.titleStyle,
          ),
          SizedBox(
            height: 20.h,
          ),
          SizedBox(
            height: _homeData.comingSoons.length * 170.h,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _homeData.comingSoons.length,
              itemBuilder: (context, index) {
                return _buildItemComingSoon(
                    comingSoon: _homeData.comingSoons[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 70.h,
                width: 70.w,
                child: Image.asset(
                  AppAssets.imgLogo,
                  fit: BoxFit.fill,
                ),
              ),
              RichText(
                text: TextSpan(
                    text: "Movie",
                    style: AppStyle.titleStyle.copyWith(
                        fontSize: 24.sp,
                        color: AppColors.buttonColor,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                          text: "Ticket",
                          style: AppStyle.titleStyle.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.normal,
                              fontSize: 24.sp))
                    ]),
              )
            ],
          ),
          InkWell(
              onTap: () {
                Get.toNamed(RouteName.searchScreen);
              },
              child: Icon(
                Icons.search,
                color: AppColors.white,
                size: 30.h,
              )),
        ],
      ),
    );
  }

  Widget _buildItemComingSoon({required Movie comingSoon}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.detailMovieScreen, arguments: comingSoon);
      },
      child: Column(
        children: [
          SizedBox(
            height: 150.h,
            child: Row(
              children: [
                ImageNetworkWidget(
                  url: comingSoon.thumbnail!,
                  height: 150.h,
                  width: 100.w,
                  borderRadius: 10.h,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comingSoon.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.titleStyle,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      comingSoon.getCaterogies(),
                      style: AppStyle.defaultStyle.copyWith(fontSize: 12.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 16.h,
                          width: 16.w,
                          child: Image.asset(
                            AppAssets.icClock,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "${comingSoon.duration} Phút",
                          style:
                              AppStyle.defaultStyle.copyWith(fontSize: 12.sp),
                        ),
                      ],
                    )
                  ],
                ))
              ],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  void _onTapBanner(BannerHome bannerHome) {
    switch (bannerHome.type) {
      case 1:
        Movie? movie;
        for (var element in _homeData.nowShowings) {
          if (element.id == bannerHome.movieId) {
            movie = element;
            break;
          }
        }
        if (movie == null) {
          for (var element in _homeData.comingSoons) {
            if (element.id == bannerHome.movieId) {
              movie = element;
              break;
            }
          }
        }
        Navigator.pushNamed(context, RouteName.detailMovieScreen,
            arguments: movie);
        break;
    }
  }
}
