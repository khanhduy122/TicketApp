import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/enum_model.dart';
import 'package:ticket_app/models/home_data.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/rating_widget.dart';

class ChooseMovieScreen  extends StatefulWidget {
  const ChooseMovieScreen({super.key});

  @override
  State<ChooseMovieScreen> createState() => _ChooseMovieScreenState();
}

class _ChooseMovieScreenState extends State<ChooseMovieScreen> {
  
  late final HomeData _homeData;

  @override
  void initState() {
    super.initState();
    _homeData = context.read<DataAppProvider>().homeData;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: 40.h,),

              _appBar(),

              SizedBox(height: 20.h,),
              
              _banner(size),

              SizedBox(height: 30.h,),

              _nowPlaying(),

              SizedBox(height: 30.h,),

              _comingSoon()

            ],
          ),
        )
      ),
    );
  }

  Widget _banner(Size size) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider(
            items: _homeData.banners.map((e){
              return Builder(
                builder: (BuildContext context) {
                  return ImageNetworkWidget(
                    borderRadius: 10.h,
                    url: e.thumbnail, 
                    height: 150.h, 
                    width: size.width,
                    boxFit: BoxFit.cover,
                  );
                },
              );
            }).toList(), 
            options: CarouselOptions(
              viewportFraction: 1,
              height: 150.h,
              autoPlay: true,
            )
          ), 
        ],
      ),
    );
  }

  Widget _nowPlaying(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Đang Khởi Chiếu", style: AppStyle.titleStyle),
          SizedBox(height: 20.h,),
          CarouselSlider(
            items: _homeData.nowShowing.map((element){
              return _buildItemNowShowing(element);
            }).toList(), 
            options: CarouselOptions(
              viewportFraction: 0.7,
              height: 470.h,
              enlargeCenterPage: true,
              enlargeFactor: 0.2
            )
          ),
        ],
      ),
    );
  }

  Widget _buildItemNowShowing(Movie nowShowing) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteName.detailMovieScreen, arguments: nowShowing);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              ImageNetworkWidget(
                height: 300,
                width: 200,
                url: nowShowing.thumbnail!, 
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
                    color: nowShowing.ban == Ban.c13 ? AppColors.orange300
                          : nowShowing.ban == Ban.c16 ? AppColors.orange  
                          : nowShowing.ban == Ban.c18 ? AppColors.red : AppColors.green
                  ),
                  child: Text(nowShowing.getBan(), style: AppStyle.defaultStyle.copyWith(fontSize: 10.sp),),
                )
              ),
            ],
          ),
          SizedBox(height: 10.h,),
          Text(nowShowing.name!, 
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.titleStyle,
          ),
          SizedBox(height: 10.h,),
          Text(
            nowShowing.getCaterogies(),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppStyle.defaultStyle.copyWith(fontSize: 12.sp),
          ),
          SizedBox(height: 10.h,),
          RatingWidget(rating: nowShowing.rating ?? 0, total: nowShowing.totalReview ?? 0, isCenter: true,),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ButtonWidget(
                title: "Đặt Vé", 
                height: 40.h, 
                width: 80.w, 
                onPressed: () {
                  Navigator.pushNamed(context, RouteName.detailMovieScreen, arguments: nowShowing);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _comingSoon(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sắp Được Khởi Chiếu", style: AppStyle.titleStyle,),
          SizedBox(height: 20.h,),
          SizedBox(
            height: _homeData.comingSoon.length * 170.h,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _homeData.comingSoon.length,
              itemBuilder: (context, index) {
                return _buildItemComingSoon(comingSoon: _homeData.comingSoon[index]);
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
                child: Image.asset(AppAssets.imgLogo, fit: BoxFit.fill,),
              ), 
              RichText(
                text: TextSpan(
                  text: "Movie",
                  style: AppStyle.titleStyle.copyWith(fontSize: 24.sp, color: AppColors.buttonColor, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: "Ticket",
                      style: AppStyle.titleStyle.copyWith(color: AppColors.buttonColor, fontWeight: FontWeight.normal, fontSize: 24.sp)
                    )
                  ]
                ),
              )
            ],
          ),
          GestureDetector(
            onTap: () {
              
            },
            child: Icon(Icons.search, color: AppColors.white, size: 30.h,)
          ),
          
        ],
      ),
    );
  }

  Widget _buildItemComingSoon({required Movie comingSoon}){
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteName.detailMovieScreen, arguments: comingSoon);
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
                SizedBox(width: 10.w,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                           comingSoon.name!, 
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppStyle.titleStyle,
                          ),
                          SizedBox(height: 10.h,),
                          Text(
                            comingSoon.getCaterogies(),
                            style: AppStyle.defaultStyle.copyWith(fontSize: 12.sp),
                          ),
                          SizedBox(height: 10.h,),
                        ],
                      ),
                      
                      Row(
                        children: [
                          SizedBox(
                            height: 16.h,
                            width: 16.w,
                            child: Image.asset(AppAssets.icClock, fit: BoxFit.contain,),
                          ),
                          SizedBox(width: 10.w,),
                          Text(
                            "${comingSoon.duration} Phút",
                            style: AppStyle.defaultStyle.copyWith(fontSize: 12.sp),
                          ),
                        ],
                      )
                      
                    ],
                  )
                )
              ],
            ),
          ),
          SizedBox(height: 20.h,),
        ],
      ),
    );
  }
}