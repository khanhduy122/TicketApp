import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/const/logger.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/moduels/auth/auth_exception.dart';
import 'package:ticket_app/moduels/review/review_bloc.dart';
import 'package:ticket_app/moduels/review/review_event.dart';
import 'package:ticket_app/moduels/review/review_state.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_outline_widget.dart';
import 'package:ticket_app/widgets/button_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/rating_widget.dart';

class AllReviewScreen extends StatefulWidget {
  const AllReviewScreen({super.key, required this.movie});

  final Movie movie;

  @override
  State<AllReviewScreen> createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen>
    with TickerProviderStateMixin {
  final ReviewBloc reviewBloc = ReviewBloc();
  final ScrollController listReviewScrollController = ScrollController();
  List<Review> reviewsDisplay = [];
  List<Review> allReviewsLoaded = [];
  int currentIndex = 0;
  int currentIndexIndicator = 0;

  @override
  void initState() {
    super.initState();
    reviewBloc.add(
        GetInitReviewMovieEvent(id: widget.movie.id!, rating: currentIndex));
  }

  @override
  void dispose() {
    listReviewScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: reviewBloc,
      listener: (context, state) {
        _onListener(state!);
      },
      child: Scaffold(
        appBar: appBarWidget(title: "Đánh Giá"),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              _buildTabBar(),
              SizedBox(
                height: 20.h,
              ),
              const Divider(
                color: AppColors.grey,
              ),
              SizedBox(
                height: 20.h,
              ),
              _buildTabView(),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _buildTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (currentIndex != 0) {
                currentIndex = 0;
                currentIndexIndicator = 0;
                reviewBloc.add(GetInitReviewMovieEvent(
                    id: widget.movie.id!, rating: currentIndex));
                setState(() {});
              }
            },
            child: Row(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                decoration: BoxDecoration(
                    color: currentIndex == 0
                        ? AppColors.buttonColor
                        : AppColors.darkBackground,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Row(
                  children: [
                    Text(
                      "Tất cả",
                      style: AppStyle.subTitleStyle,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "(${widget.movie.totalReview})",
                      style: AppStyle.defaultStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12.w,
              )
            ]),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex != 1) {
                currentIndex = 1;
                currentIndexIndicator = 0;
                reviewBloc.add(GetInitReviewMovieEvent(
                    id: widget.movie.id!, rating: currentIndex));
                setState(() {});
              }
            },
            child: Row(children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                decoration: BoxDecoration(
                    color: currentIndex == 1
                        ? AppColors.buttonColor
                        : AppColors.darkBackground,
                    borderRadius: BorderRadius.circular(10.r)),
                child: Row(
                  children: [
                    Text(
                      "Có Hình Ảnh",
                      style: AppStyle.subTitleStyle,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      "(${widget.movie.totalRatingWithPicture})",
                      style: AppStyle.defaultStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 12.w,
              )
            ]),
          ),
          _itemTabBar(
            title: "5",
            isSelected: currentIndex == 2,
            total: widget.movie.totalFiveRating ?? 0,
            onTap: () {
              if (currentIndex != 2) {
                currentIndex = 2;
                currentIndexIndicator = 0;
                reviewBloc.add(GetInitReviewMovieEvent(
                    id: widget.movie.id!, rating: currentIndex));
                setState(() {});
              }
            },
          ),
          _itemTabBar(
            title: "4",
            isSelected: currentIndex == 3,
            total: widget.movie.totalFourRating ?? 0,
            onTap: () {
              if (currentIndex != 3) {
                currentIndex = 3;
                currentIndexIndicator = 0;
                reviewBloc.add(GetInitReviewMovieEvent(
                    id: widget.movie.id!, rating: currentIndex));
                setState(() {});
              }
            },
          ),
          _itemTabBar(
            title: "3",
            isSelected: currentIndex == 4,
            total: widget.movie.totalThreeRating ?? 0,
            onTap: () {
              if (currentIndex != 4) {
                currentIndex = 4;
                currentIndexIndicator = 0;
                reviewBloc.add(GetInitReviewMovieEvent(
                    id: widget.movie.id!, rating: currentIndex));
                setState(() {});
              }
            },
          ),
          _itemTabBar(
            title: "2",
            isSelected: currentIndex == 5,
            total: widget.movie.totalTwoRating ?? 0,
            onTap: () {
              if (currentIndex != 5) {
                currentIndex = 5;
                currentIndexIndicator = 0;
                reviewBloc.add(GetInitReviewMovieEvent(
                    id: widget.movie.id!, rating: currentIndex));
                setState(() {});
              }
            },
          ),
          _itemTabBar(
            title: "1",
            isSelected: currentIndex == 6,
            total: widget.movie.totalOneRating ?? 0,
            onTap: () {
              if (currentIndex != 6) {
                currentIndex = 6;
                currentIndexIndicator = 0;
                reviewBloc.add(GetInitReviewMovieEvent(
                    id: widget.movie.id!, rating: currentIndex));
                setState(() {});
              }
            },
          )
        ],
      ),
    );
  }

  Widget _itemTabBar(
      {required String title,
      required bool isSelected,
      required int total,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.buttonColor
                    : AppColors.darkBackground,
                borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              children: [
                Text(
                  title,
                  style: AppStyle.subTitleStyle,
                ),
                Icon(
                  Icons.star,
                  color: AppColors.rating,
                  size: 15.h,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Text(
                  "($total)",
                  style: AppStyle.defaultStyle,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 12.w,
          )
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return Expanded(
      child: ListView.builder(
        controller: listReviewScrollController,
        itemCount: reviewsDisplay.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildItemReview(review: reviewsDisplay[index]),
              index == reviewsDisplay.length - 1
                  ? SizedBox(
                      height: 20.h,
                    )
                  : Container(),
              index == reviewsDisplay.length - 1
                  ? _buildIndicator()
                  : Container(),
            ],
          );
        },
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
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    RouteName.openImageScreen,
                                    arguments: {
                                      'review': review,
                                      'index': review.images!.indexOf(image)
                                    },
                                  );
                                },
                                child: ImageNetworkWidget(
                                  url: image,
                                  height: 80.h,
                                  width: 80.w,
                                ),
                              )
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

  Widget _buildIndicator() {
    int totaIndex = 0;

    switch (currentIndex) {
      case 0:
        if (widget.movie.totalReview! ~/ 10 == 0 &&
            widget.movie.totalReview! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = widget.movie.totalReview! ~/ 10;
        if (widget.movie.totalReview! % 10 != 0) {
          totaIndex + 1;
        }
        break;
      case 1:
        if (widget.movie.totalRatingWithPicture! ~/ 10 == 0 &&
            widget.movie.totalRatingWithPicture! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = widget.movie.totalRatingWithPicture! ~/ 10;
        if (widget.movie.totalRatingWithPicture! % 10 != 0) {
          totaIndex += 1;
        }
        break;
      case 2:
        if (widget.movie.totalFiveRating! ~/ 10 == 0 &&
            widget.movie.totalFiveRating! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = widget.movie.totalFiveRating! ~/ 10;
        if (widget.movie.totalFiveRating! % 10 != 0) {
          totaIndex += 1;
        }
        break;
      case 3:
        if (widget.movie.totalFourRating! ~/ 10 == 0 &&
            widget.movie.totalFourRating! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = widget.movie.totalFourRating! ~/ 10;
        if (widget.movie.totalFourRating! % 10 != 0) {
          totaIndex += 1;
        }
        break;
      case 4:
        if (widget.movie.totalThreeRating! ~/ 10 == 0 &&
            widget.movie.totalThreeRating! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = widget.movie.totalThreeRating! ~/ 10;

        if (widget.movie.totalThreeRating! % 10 != 0) {
          totaIndex += 1;
        }
        break;
      case 5:
        if (widget.movie.totalTwoRating! ~/ 10 == 0 &&
            widget.movie.totalTwoRating! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = widget.movie.totalTwoRating! ~/ 10;
        if (widget.movie.totalTwoRating! % 10 != 0) {
          totaIndex += 1;
        }
        break;
      case 6:
        if (widget.movie.totalOneRating! ~/ 10 == 0 &&
            widget.movie.totalOneRating! > 0) {
          totaIndex = 1;
          break;
        }
        totaIndex = widget.movie.totalOneRating! ~/ 10;
        if (widget.movie.totalOneRating! % 10 != 0) {
          totaIndex += 1;
        }
        break;
    }

    return Row(
      mainAxisAlignment:
          currentIndexIndicator == 0 || currentIndexIndicator + 1 == totaIndex
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceAround,
      children: [
        currentIndexIndicator != 0
            ? ButtonOutlineWidget(
                title: "Trước",
                height: 50.h,
                width: 100.w,
                onPressed: _onTapPreviousPage,
              )
            : Container(),
        currentIndexIndicator + 1 != totaIndex
            ? ButtonWidget(
                title: "Tiếp Theo",
                height: 50.h,
                width: 100.w,
                onPressed: _onTapNextPage,
              )
            : Container()
      ],
    );
  }

  void _onListener(Object state) {
    if (state is GetInitReviewMovieState) {
      if (state.isLoading == true) {
        DialogLoading.show(context);
      }
      if (state.reviews != null) {
        Navigator.pop(context);
        listReviewScrollController.jumpTo(
          0.0,
        );
        setState(() {
          debugLog(allReviewsLoaded.length.toString());
          allReviewsLoaded = state.reviews!.sublist(0);
          reviewsDisplay = state.reviews!.sublist(0);
        });
      }
      if (state.error != null) {
        Navigator.pop(context);
        if (state.error is TimeOutException) {
          DialogError.show(
            context: context,
            message: "Đã có lỗi xảy ra, vui lòng kiểm tra lại đường truyền",
            onTap: () {
              Navigator.popUntil(
                  context,
                  (route) =>
                      route.settings.name == RouteName.detailMovieScreen);
            },
          );
        } else {
          DialogError.show(
            context: context,
            message: "Đã có lỗi xảy ra, vui lòng thử lại sau",
            onTap: () {
              Navigator.popUntil(
                  context,
                  (route) =>
                      route.settings.name == RouteName.detailMovieScreen);
            },
          );
        }
      }
    }

    if (state is LoadMoreReviewMovieState) {
      if (state.isLoading == true) {
        DialogLoading.show(context);
      }
      if (state.reviews != null) {
        Navigator.pop(context);
        listReviewScrollController.animateTo(0.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut);
        setState(() {
          allReviewsLoaded.insertAll(allReviewsLoaded.length, state.reviews!);
          reviewsDisplay = state.reviews!.sublist(0);
        });
      }
      if (state.error != null) {
        Navigator.pop(context);
        if (state.error is TimeOutException) {
          DialogError.show(
            context: context,
            message: "Đã có lỗi xảy ra, vui lòng kiểm tra lại đường truyền",
            onTap: () {
              Navigator.popUntil(
                  context,
                  (route) =>
                      route.settings.name == RouteName.detailMovieScreen);
            },
          );
        } else {
          DialogError.show(
            context: context,
            message: "Đã có lỗi xảy ra, vui lòng thử lại sau",
            onTap: () {
              Navigator.popUntil(
                  context,
                  (route) =>
                      route.settings.name == RouteName.detailMovieScreen);
            },
          );
        }
      }
    }
  }

  void _onTapNextPage() {
    currentIndexIndicator++;
    listReviewScrollController.animateTo(0.0,
        duration: const Duration(microseconds: 100), curve: Curves.easeInOut);
    if (allReviewsLoaded.length > (currentIndexIndicator * 10)) {
      setState(() {
        if ((currentIndexIndicator * 10) + 10 < allReviewsLoaded.length) {
          reviewsDisplay = allReviewsLoaded.sublist(
              currentIndexIndicator * 10, (currentIndexIndicator * 10) + 10);
        } else {
          reviewsDisplay = allReviewsLoaded.sublist(currentIndexIndicator * 10);
        }
      });
    } else {
      reviewBloc.add(
          LoadMoreReviewMovieEvent(id: widget.movie.id!, rating: currentIndex));
    }
  }

  void _onTapPreviousPage() {
    listReviewScrollController.animateTo(0.0,
        duration: const Duration(microseconds: 100), curve: Curves.easeInOut);
    setState(() {
      currentIndexIndicator--;
      reviewsDisplay = allReviewsLoaded.sublist(
          currentIndexIndicator * 10, (currentIndexIndicator * 10) + 10);
    });
  }
}
