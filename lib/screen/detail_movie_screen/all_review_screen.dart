import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/models/review.dart';
import 'package:ticket_app/screen/detail_movie_screen/bloc/get_review_movie_bloc.dart';
import 'package:ticket_app/screen/detail_movie_screen/bloc/get_review_movie_event.dart';
import 'package:ticket_app/screen/detail_movie_screen/bloc/get_review_movie_state.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/button_back_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/rating_widget.dart';

class AllReviewScreen extends StatefulWidget {
  const AllReviewScreen({super.key, required this.movie});

  final Movie movie;

  @override
  State<AllReviewScreen> createState() => _AllReviewScreenState();
}

class _AllReviewScreenState extends State<AllReviewScreen> with TickerProviderStateMixin {

  final GetReviewMovieBloc getReviewMovieBloc = GetReviewMovieBloc();
  List<Review> reviewsDisplay = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    reviewsDisplay = widget.movie.reviews != null ? widget.movie.reviews!.sublist(0) : [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: getReviewMovieBloc,
      listener: (context, state) {
        if(state is GetReviewMovieState){
          if(state.isLoading == true){
            DialogLoading.show(context);
          }
          if(state.reviews != null){
            Navigator.pop(context);
            setState(() {
              reviewsDisplay = state.reviews!.sublist(0);
            });
          }
        }
      },
      child: Scaffold(
        appBar: appBarWidget(title: "Đánh Giá"),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
    
                   SizedBox(height: 20.h,),
    
                  _buildTabBar(),
    
                  SizedBox(height: 20.h,),
    
                  const Divider(color: AppColors.grey,),
    
                  SizedBox(height: 20.h,),
    
                  _buildTabView()
    
                ],
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget _buildTabBar(){
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if(currentIndex != 0){
                getReviewMovieBloc.add(GetReviewMovieEvent(id: widget.movie.id, currentIndex: 0, rating: 0));
                setState(() {
                  currentIndex = 0;
                });
              }
            },
            child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: currentIndex == 0 ? AppColors.buttonColor : AppColors.darkBackground,
                  borderRadius: BorderRadius.circular(10.r)
                ),
                child: Row(
                  children: [
                    Text("Tất cả", style: AppStyle.subTitleStyle,),
                    SizedBox(width: 5.w,),
                    Text("(${widget.movie.totalReview})", style: AppStyle.defaultStyle,),
                  ],
                ),
              ),
              SizedBox(width: 12.w,)
            ]
            ),
          ),
          GestureDetector(
            onTap: () {
              if(currentIndex != 1){
                getReviewMovieBloc.add(GetReviewMovieEvent(id: widget.movie.id, currentIndex: 0, rating: -1));
                setState(() {
                  currentIndex = 1;
                });
              }
            },
            child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: currentIndex == 1 ? AppColors.buttonColor : AppColors.darkBackground,
                  borderRadius: BorderRadius.circular(10.r)
                ),
                child: Row(
                  children: [
                    Text("Có Hình Ảnh", style: AppStyle.subTitleStyle,),
                    SizedBox(width: 5.w,),
                    Text("(${widget.movie.totalRatingWithPicture})", style: AppStyle.defaultStyle,),
                  ],
                ),
              ),
              SizedBox(width: 12.w,)
            ]
            ),
          ),
          _itemTabBar(
            title: "5", 
            isSelected: currentIndex == 2, 
            total: widget.movie.totalFiveRating ?? 0,
            onTap: () {
              if(currentIndex != 2){
                getReviewMovieBloc.add(GetReviewMovieEvent(id: widget.movie.id, currentIndex: 0, rating: 5));
                setState(() {
                  currentIndex = 2;
                });
              }
            },
          ),
          _itemTabBar(
            title: "4", 
            isSelected: currentIndex == 3, 
            total: widget.movie.totalFourRating ?? 0,
            onTap: () {
              if(currentIndex != 3){
                getReviewMovieBloc.add(GetReviewMovieEvent(id: widget.movie.id, currentIndex: 0, rating: 4));
                setState(() {
                  currentIndex = 3;
                });
              }
            },
          ),
          _itemTabBar(
            title: "3", 
            isSelected: currentIndex == 4, 
            total: widget.movie.totalThreeRating ?? 0,
            onTap: () {
              if(currentIndex != 4){
                getReviewMovieBloc.add(GetReviewMovieEvent(id: widget.movie.id, currentIndex: 0, rating: 3));
                setState(() {
                  currentIndex = 4;
                });
              }
            },
          ),
          _itemTabBar(
            title: "2", 
            isSelected: currentIndex == 5,
            total: widget.movie.totalTwoRating ?? 0, 
            onTap: () {
              if(currentIndex != 5){
                getReviewMovieBloc.add(GetReviewMovieEvent(id: widget.movie.id, currentIndex: 0, rating: 2));
                setState(() {
                  currentIndex = 5;
                });
              }
            },
          ),
          _itemTabBar(
            title: "1", 
            isSelected: currentIndex == 6,
            total: widget.movie.totalOneRating ?? 0, 
            onTap: () {
              if(currentIndex != 6){
                getReviewMovieBloc.add(GetReviewMovieEvent(id: widget.movie.id, currentIndex: 0, rating: 1));
                setState(() {
                  currentIndex = 6;
                });
              }
            },
          )
        ],
      ),
    );
  }

  Widget _itemTabBar({required String title, required bool isSelected, required int total ,required Function() onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.buttonColor : AppColors.darkBackground,
              borderRadius: BorderRadius.circular(10.r)
            ),
            child: Row(
              children: [
                Text(title, style: AppStyle.subTitleStyle,),
                Icon(Icons.star, color: AppColors.rating, size: 15.h,),
                SizedBox(width: 5.w,),
                Text("($total)", style: AppStyle.defaultStyle,),
              ],
            ),
          ),
          SizedBox(width: 12.w,)
        ],
      ),
    );
  }

  Widget _buildTabView(){
    return ListView.builder(
      itemCount: widget.movie.reviews!.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return _buildItemReview(review: reviewsDisplay[index]);
      },
    );
  }

  Widget _buildItemReview({required Review review}){
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            review.userPhoto == null ? SizedBox(
              height: 40.h,
              width: 40.w,
              child: Image.asset(AppAssets.imgAvatarDefault)
            )
            : ImageNetworkWidget(
              url: review.userPhoto!, 
              height: 40.h, 
              width: 40.w,
              borderRadius: 30.r,
            ),
            SizedBox(width: 10.w,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.userName,
                  style: AppStyle.subTitleStyle,
                ),
                SizedBox(height: 5.h,),
                RatingWidget(rating: review.rating),
                SizedBox(height: 10.h,),
                Text(
                  review.content,
                  style: AppStyle.defaultStyle,
                ),
                review.photoReview != null ? ImageNetworkWidget(
                  url: review.photoReview!, 
                  height: 100.h, 
                  width: 70.w
                ) : Container()
              ],
            )
          ],
        ),
        SizedBox(height: 10.h,),
        const Divider(color: AppColors.grey,),
        SizedBox(height: 10.h,),

      ],
    );
  }
}