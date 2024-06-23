import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/moduels/cinema/cinema_event.dart';
import 'package:ticket_app/screen/detail_movie_screen/detail_movie/detail_movie_controller.dart';
import 'package:ticket_app/widgets/button_back_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/rating_widget.dart';

class DetailMovieScreen extends GetView<DetailMovieController> {
  const DetailMovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          _buidHeader(size),
          SizedBox(
            height: 20.h,
          ),
          _buildTabBar(size),
          SizedBox(
            height: 20.h,
          ),
          Expanded(child: _buildTabView())
        ],
      ),
    );
  }

  SizedBox _buidHeader(Size size) {
    return SizedBox(
      height: 300.h,
      child: Stack(
        children: [
          ImageNetworkWidget(
            url: controller.movie.banner!,
            height: 200.h,
            width: size.width,
            boxFit: BoxFit.cover,
          ),
          Container(
            height: 200.h,
            width: size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, AppColors.background],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 150.h,
              width: size.width - 20.w,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  ImageNetworkWidget(
                    url: controller.movie.thumbnail!,
                    height: 150.h,
                    width: 100.w,
                    boxFit: BoxFit.fill,
                    borderRadius: 10.h,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.movie.name!,
                          maxLines: 3,
                          style: AppStyle.subTitleStyle,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          controller.movie.getCaterogies(),
                          maxLines: 3,
                          style:
                              AppStyle.defaultStyle.copyWith(fontSize: 10.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        RatingWidget(
                            rating: controller.movie.rating ?? 0,
                            total: controller.movie.totalReview ?? 0),
                        SizedBox(
                          height: 10.h,
                        ),
                        controller.movie.status == 1
                            ? ButtonWidget(
                                title: "Đặt vé",
                                height: 30.h,
                                width: 90.w,
                                onPressed: () {},
                              )
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(top: 30.h, left: 10.w, child: const ButtonBackWidget()),
        ],
      ),
    );
  }

  Widget _buildTabBar(Size size) {
    return TabBar(
        controller: controller.tabController,
        dividerColor: Colors.transparent,
        indicatorColor: AppColors.buttonColor,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          Tab(
              child: Text(
            "Thông Tin",
            style: AppStyle.subTitleStyle,
          )),
          Tab(
              child: Text(
            "Đánh Giá",
            style: AppStyle.subTitleStyle,
          ))
        ]);
  }

  Widget _buildTabView() {
    return TabBarView(controller: controller.tabController, children: [
      _buildInformation(),
      Obx(
        () => _buildReview(controller.reviews),
      )
    ]);
  }

  Widget _buildInformation() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Tóm tắt",
              style: AppStyle.subTitleStyle,
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              controller.movie.content ?? "",
              style: AppStyle.defaultStyle,
            ),
            SizedBox(
              height: 20.h,
            ),
            _itemInformation("Ngày Phát Hành", controller.movie.date ?? ""),
            _itemInformation("Đạo diễn", controller.movie.director ?? ""),
            _itemInformation("Ngôn ngữ", controller.movie.getLanguages()),
            _itemInformation("Thời lượng", "${controller.movie.duration} phút"),
            _itemInformation("Thể loại", controller.movie.getCaterogies()),
            _itemInformation(
                "Quốc gia sản xuất", controller.movie.nation ?? ""),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Đạo diễn và diễn viên",
              style: AppStyle.subTitleStyle,
            ),
            SizedBox(
              height: 10.h,
            ),
            _buildActors(),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Trailer",
              style: AppStyle.subTitleStyle,
            ),
            SizedBox(
              height: 10.h,
            ),
            _buildTrailer(),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildTrailer() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.playVideoTrailerScreen,
            arguments: controller.movie);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ImageNetworkWidget(
            url: controller.movie.banner!,
            height: 150.h,
            width: 250.w,
            borderRadius: 10.h,
          ),
          Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
                color: AppColors.grey.withAlpha(100),
                borderRadius: BorderRadius.circular(25.h)),
            child: const Icon(Icons.play_arrow),
          )
        ],
      ),
    );
  }

  SizedBox _buildActors() {
    return SizedBox(
      height: 100.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.movie.actors!.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 10.w),
            child: Column(
              children: [
                ImageNetworkWidget(
                  url: controller.movie.actors![index].thumbnail,
                  height: 70.h,
                  width: 70.w,
                  borderRadius: 10.h,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  controller.movie.actors![index].name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.defaultStyle.copyWith(fontSize: 10.sp),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _itemInformation(String title, String value) {
    return Column(
      children: [
        RichText(
            maxLines: 2,
            text: TextSpan(
                text: '$title: ',
                style: AppStyle.defaultStyle,
                children: [
                  TextSpan(
                    text: value,
                    style: AppStyle.defaultStyle,
                  )
                ])),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  Widget _buildReview(List<Review> reviews) {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.buttonColor,
        ),
      );
    }
    if (controller.messageFaild.value.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              controller.getReviewMovie();
            },
            child: Icon(
              Icons.refresh,
              size: 25.h,
              color: AppColors.white,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            controller.messageFaild.value,
            style: AppStyle.defaultStyle,
          )
        ],
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: reviews.isNotEmpty
          ? ListView.builder(
              itemCount: reviews.length,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _buildItemReview(review: reviews[index]),
                    index == reviews.length - 1
                        ? ButtonWidget(
                            title: "Xem tất cả",
                            height: 50.h,
                            width: MediaQuery.of(context).size.width / 2,
                            onPressed: () {
                              Get.toNamed(RouteName.allReviewScreen,
                                  arguments: {
                                    "movie": controller.movie,
                                    "reviews": controller.reviews,
                                  });
                            },
                          )
                        : Container(),
                    index == reviews.length - 1
                        ? SizedBox(
                            height: 20.h,
                          )
                        : Container()
                  ],
                );
              },
            )
          : Center(
              child: Text(
                "Không có đánh giá nào",
                style: AppStyle.titleStyle,
              ),
            ),
    );
  }

  Widget _buildItemReview({required Review review}) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            review.userPhoto == null
                ? SizedBox(
                    height: 40.h,
                    width: 40.w,
                    child: Image.asset(AppAssets.imgAvatarDefault))
                : ImageNetworkWidget(
                    url: review.userPhoto!,
                    height: 40.h,
                    width: 40.w,
                    borderRadius: 30.r,
                  ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.userName,
                    style: AppStyle.subTitleStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  RatingWidget(rating: review.rating),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    review.content,
                    style: AppStyle.defaultStyle,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  (review.images != null)
                      ? Wrap(
                          spacing: 10.w,
                          runSpacing: 10.h,
                          children: [
                            for (var image in review.images!)
                              GestureDetector(
                                onTap: () {},
                                child: ImageNetworkWidget(
                                  url: image,
                                  height: 100.h,
                                  width: 100.w,
                                ),
                              ),
                          ],
                        )
                      : Container()
                ],
              ),
            )
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
        const Divider(
          color: AppColors.grey,
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }
}
