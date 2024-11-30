import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/core/utils/loaction_util.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/rating_widget.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  late final List<Movie> movies;
  List<Movie> moviesFilter = [];
  int currentIndexFilter = 1;

  @override
  void initState() {
    movies = getInitMovie(context);
    moviesFilter = movies.sublist(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Row(
              children: [
                Expanded(
                  child: ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [Colors.blue, Colors.purple],
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      );
                    },
                    child: Text(
                      'BẢNG XẾP HẠNG',
                      textAlign: TextAlign.center,
                      style: AppStyle.titleStyle.copyWith(fontSize: 25.sp),
                    ),
                  ),
                ),
                PopupMenuButton(
                  position: PopupMenuPosition.under,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Expanded(child: Text("Lượt Mua Vé")),
                            if (currentIndexFilter == 0)
                              Icon(
                                Icons.check,
                                color: AppColors.buttonColor,
                              )
                          ],
                        ),
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Expanded(child: Text("Điểm Đánh Giá")),
                            if (currentIndexFilter == 1)
                              Icon(
                                Icons.check,
                                color: AppColors.buttonColor,
                              )
                          ],
                        ),
                        onTap: () {},
                      ),
                    ];
                  },
                  icon: Icon(
                    Icons.filter_alt,
                    color: AppColors.white,
                    size: 30.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  return _buildItemMovie(
                    movie: movies[index],
                    index: index,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Movie> getInitMovie(BuildContext context) {
    final movies =
        context.read<DataAppProvider>().homeData!.nowShowings.sublist(0);

    movies.sort(
      (a, b) => b.rating!.compareTo(a.rating ?? 0),
    );
    return movies;
  }

  Widget _buildItemMovie({required Movie movie, required int index}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RouteName.detailMovieScreen, arguments: movie);
      },
      child: Column(
        children: [
          SizedBox(
            height: 150.h,
            child: Row(
              children: [
                SizedBox(
                  width: 30.w,
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(
                      fontSize: index == 0
                          ? 40.sp
                          : index == 1
                              ? 35.sp
                              : index == 2
                                  ? 30.sp
                                  : 25.sp,
                      fontWeight: FontWeight.bold,
                      color: index == 0
                          ? AppColors.red
                          : index == 1
                              ? AppColors.buttonColor
                              : index == 2
                                  ? AppColors.orange300
                                  : AppColors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                ImageNetworkWidget(
                  url: movie.thumbnail!,
                  height: 150.h,
                  width: 100.w,
                  borderRadius: 10.h,
                ),
                SizedBox(width: 10.w),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.titleStyle,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      movie.getCaterogies(),
                      style: AppStyle.defaultStyle.copyWith(fontSize: 12.sp),
                    ),
                    SizedBox(height: 10.h),
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
                          "${movie.duration} Phút",
                          style:
                              AppStyle.defaultStyle.copyWith(fontSize: 12.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        RatingWidget(rating: movie.rating ?? 0),
                        Text(
                          '(${movie.rating?.toStringAsFixed(1) ?? 0})',
                          style: AppStyle.defaultStyle,
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
}
