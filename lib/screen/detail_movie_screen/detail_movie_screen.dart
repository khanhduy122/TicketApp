import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/moduels/auth/auth_exception.dart';
import 'package:ticket_app/moduels/cinema/cinema_bloc.dart';
import 'package:ticket_app/moduels/cinema/cinema_event.dart';
import 'package:ticket_app/moduels/cinema/cinema_state.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/rating_widget.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({super.key, required this.movie});

  final Movie movie;

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final CinemaBloc cinemaBloc = CinemaBloc();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocListener(
      bloc: cinemaBloc,
      listener: (context, state) {
        if (state is GetCinemasShowingMovieState) {
          if (state.isLoading == true) {
            DialogLoading.show(context);
          }

          if (state.cinemaCity != null) {
            Navigator.of(context, rootNavigator: true).pop();
            Navigator.pushNamed(context, RouteName.selectCinemaScreen,
                arguments: {
                  "movie": widget.movie,
                  "cinemaCity": state.cinemaCity
                });
          }

          if (state.error != null) {
            Navigator.of(context, rootNavigator: true).pop();
            if (state.error is TimeOutException) {
              DialogError.show(
                  context: context,
                  message:
                      "Đã có lỗi xẩy ra, vui lòng kiểm tra lại đường truyền");
            } else {
              DialogError.show(
                  context: context,
                  message: "Đã có lỗi xảy ra vui lòng thử lại sao");
            }
          }
        }
      },
      child: Scaffold(
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
      ),
    );
  }

  SizedBox _buidHeader(Size size) {
    return SizedBox(
      height: 300.h,
      child: Stack(
        children: [
          ImageNetworkWidget(
            url: widget.movie.banner!,
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
                    colors: [Colors.transparent, AppColors.background])),
          ),
          Positioned(
            top: 10.h,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            )
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
                    url: widget.movie.thumbnail!,
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
                          widget.movie.name!,
                          maxLines: 3,
                          style: AppStyle.subTitleStyle,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          widget.movie.getCaterogies(),
                          maxLines: 3,
                          style:
                              AppStyle.defaultStyle.copyWith(fontSize: 10.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        RatingWidget(
                            rating: widget.movie.rating ?? 0,
                            total: widget.movie.totalReview ?? 0),
                        SizedBox(
                          height: 10.h,
                        ),
                        widget.movie.status == 1
                            ? ButtonWidget(
                                title: "Đặt vé",
                                height: 30.h,
                                width: 80.w,
                                onPressed: () {
                                  if(context.read<DataAppProvider>().reconmmedCinemas == null){
                                    if(context.read<DataAppProvider>().cityNameCurrent != null){
                                      
                                      String currentCityName = context.read<DataAppProvider>().cityNameCurrent!;
                                      DateTime now = DateTime.now();
                                      String day = now.day.toString().length == 1 ? "0${now.day}" : now.day.toString();
                                      String month = now.month.toString().length == 1 ? "0${now.month}" : now.month.toString();
                                      String currentDate = "$day-$month-${now.year}";
                                      cinemaBloc.add(GetCinemasShowingMovieEvent(
                                          cityName: currentCityName,
                                          movieID: widget.movie.id!,
                                          date: currentDate,
                                          context: context));
                                    }else{
                                      Navigator.pushNamed(context, RouteName.selectCinemaScreen,
                                        arguments: {
                                          "movie": widget.movie,
                                          "cinemaCity": context.read<DataAppProvider>().reconmmedCinemas
                                        });
                                    }
                                  }else{
                                    debugLog("aaa");
                                    String currentCityName = context.read<DataAppProvider>().reconmmedCinemas!.name ?? '';
                                    DateTime now = DateTime.now();
                                    String day = now.day.toString().length == 1 ? "0${now.day}" : now.day.toString();
                                    String month = now.month.toString().length == 1 ? "0${now.month}" : now.month.toString();
                                    String currentDate = "$day-$month-${now.year}";
                                    debugLog("currentCityName: $currentCityName, currentDate: $currentDate, movieID: ${widget.movie.id}");
                                    cinemaBloc.add(GetCinemasShowingMovieEvent(
                                        cityName: currentCityName,
                                        movieID: widget.movie.id!,
                                        date: currentDate,
                                        context: context));
                                    }
                                },
                              )
                            : Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTabBar(Size size) {
    return TabBar(
        controller: _tabController,
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
    return TabBarView(controller: _tabController, children: [
      _buildInformation(),
      _buildReview(widget.movie.reviews ?? []),
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
              widget.movie.content ?? "",
              style: AppStyle.defaultStyle,
            ),
            SizedBox(
              height: 20.h,
            ),
            _itemInformation("Ngày Phát Hành", widget.movie.date ?? ""),
            _itemInformation("Đạo diễn", widget.movie.director ?? ""),
            _itemInformation("Ngôn ngữ", widget.movie.getLanguages()),
            _itemInformation("Thời lượng", "${widget.movie.duration} phút"),
            _itemInformation("Thể loại", widget.movie.getCaterogies()),
            _itemInformation("Quốc gia sản xuất", widget.movie.nation ?? ""),
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
        Navigator.pushNamed(context, RouteName.playVideoTrailerScreen,
            arguments: widget.movie);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ImageNetworkWidget(
            url: widget.movie.banner!,
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
        itemCount: widget.movie.actors!.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 10.w),
            child: Column(
              children: [
                ImageNetworkWidget(
                  url: widget.movie.actors![index].thumbnail,
                  height: 70.h,
                  width: 70.w,
                  borderRadius: 10.h,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  widget.movie.actors![index].name,
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        children: [
          Expanded(
              child: reviews.isNotEmpty
                  ? ListView.builder(
                      itemCount: reviews.length > 10 ? 10 : reviews.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            _buildItemReview(review: reviews[index]),
                            index == reviews.length - 1
                                ? ButtonWidget(
                                    title: "Xem tất cả",
                                    height: 50.h,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                          context, RouteName.allReviewScreen,
                                          arguments: widget.movie);
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
                    )),
        ],
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
            Column(
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
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width - 70.w,
                        child: Wrap(
                          spacing: 10.w,
                          runSpacing: 10.h,
                          children: [
                            for (var image in review.images!)
                              ImageNetworkWidget(
                                url: image,
                                height: 100.h,
                                width: 100.w,
                              ),
                          ],
                        ),
                      )
                    : Container()
              ],
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
