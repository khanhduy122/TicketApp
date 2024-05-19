import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/widgets/button_back_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';
import 'package:ticket_app/widgets/rating_widget.dart';
import 'package:tiengviet/tiengviet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Movie> listAllMovie = [];
  List<Movie> listMovieSearch = [];

  @override
  void initState() {
    listAllMovie =
        context.read<DataAppProvider>().homeData.nowShowing.sublist(0);
    listAllMovie.insertAll(listAllMovie.length,
        context.read<DataAppProvider>().homeData.comingSoon.sublist(0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            _buildHeader(),
            SizedBox(
              height: 20.h,
            ),
            _buildListMovieSearch()
          ],
        ),
      )),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const ButtonBackWidget(),
        SizedBox(
          width: 10.w,
        ),
        Expanded(
          child: Container(
              height: 40.h,
              padding: EdgeInsets.only(left: 20.w),
              decoration: BoxDecoration(
                  color: AppColors.darkBackground,
                  borderRadius: BorderRadius.circular(5.r)),
              child: Stack(
                children: [
                  TextField(
                    style: AppStyle.defaultStyle,
                    onChanged: (value) => _onSearch(value),
                    decoration: InputDecoration(
                      hintText: "Tìm Kiếm",
                      hintStyle: AppStyle.defaultStyle,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              )),
        )
      ],
    );
  }

  Widget _buildListMovieSearch() {
    return Expanded(
        child: ListView.builder(
      shrinkWrap: true,
      itemCount: listMovieSearch.length,
      itemBuilder: (context, index) {
        return _buildItemMovie(movie: listMovieSearch[index]);
      },
    ));
  }

  Widget _buildItemMovie({required Movie movie}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, RouteName.detailMovieScreen,
            arguments: movie);
      },
      child: Column(
        children: [
          SizedBox(
            height: 150.h,
            child: Row(
              children: [
                ImageNetworkWidget(
                  url: movie.thumbnail!,
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
                      movie.name!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.titleStyle,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      movie.getCaterogies(),
                      style: AppStyle.defaultStyle.copyWith(fontSize: 12.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    RatingWidget(rating: movie.rating ?? 0),
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
                          "${movie.duration} Phút",
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

  void _onSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        listMovieSearch.clear();
      });
    } else {
      listMovieSearch.clear();
      setState(() {
        for (var element in listAllMovie) {
          if (TiengViet.parse(element.name!)
              .toLowerCase()
              .contains(TiengViet.parse(value).toLowerCase())) {
            listMovieSearch.add(element);
          }
        }
        listMovieSearch;
      });
    }
  }
}
