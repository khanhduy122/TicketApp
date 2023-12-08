import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class SelectFilterMovieSscreen extends StatefulWidget {
  const SelectFilterMovieSscreen({super.key, required this.moviename});

  final String moviename;

  @override
  State<SelectFilterMovieSscreen> createState() => _SelectFilterMovieSscreenState();
}

class _SelectFilterMovieSscreenState extends State<SelectFilterMovieSscreen> {

  String? _selectCity;
  int currentSelectedDateIndex = 0;
  int currentSelectedMovieTimeIndex = 0;
  int currentSelctCinemaTypeIndex = 0;
  final List<String> days = [];
  final List<String> movieTime = ["Tất cả", "00:00 - 03:00", "03:00 - 06-00", "06:00 - 09:00", "09:00 - 12:00", "12:00 - 15:00", "15:00 - 18:00", "18:00 - 21:00", "21:00 - 24:00"];
  final TextEditingController _searchCityTextController =
      TextEditingController();
  final DateTime currentDate = DateTime.now();
  CinemaCity? _reconmmedCinemas;
  List<Cinema>? _recomendCinemaSelect;

  @override
  void initState() {
    super.initState();
    _reconmmedCinemas = context.read<DataAppProvider>().reconmmedCinemas;
    _recomendCinemaSelect = _reconmmedCinemas!.all!.sublist(0);
    _selectCity = context.read<DataAppProvider>().cityNameCurrent;
    _initDays();
  }

  @override
  void dispose() {
    super.dispose();
    _searchCityTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    debugLog(DateTime.now().weekday.toString());

    return Scaffold(
      appBar: appBarWidget(title: widget.moviename),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 20.h,),
              _searchCity(),
              SizedBox(height: 20.h,),
              _buildSelectDate(),
              SizedBox(height: 20.h,),
              _buildSelectTimeCGVCinema(),
              SizedBox(height: 20.h,),
              _builSelectCinemaType(),
              SizedBox(height: 20.h,),
              _buildRecomendCinema()
            ],
          ),
        )
      ),
    );
  }

  Widget _searchCity() {
    return Container(
        height: 50.h,
        width: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.h),
            color: AppColors.darkBackground),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            value: _selectCity,
            hint: Text("-- Tìm Kiếm Tĩnh Thành Phố --", style: AppStyle.defaultStyle,),
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
              setState(() {
                _selectCity = value!;
              });
            },
            buttonStyleData: const ButtonStyleData(
              height: 40,
            ),
            dropdownStyleData: DropdownStyleData(
                maxHeight: MediaQuery.of(context).size.height / 2,
                decoration:
                    const BoxDecoration(color: AppColors.darkBackground)),
            menuItemStyleData: MenuItemStyleData(
                height: 40,
                overlayColor: MaterialStateProperty.all<Color>(
                    AppColors.buttonPressColor)),
            dropdownSearchData: DropdownSearchData(
              searchController: _searchCityTextController,
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
                  controller: _searchCityTextController,
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
                _searchCityTextController.clear();
              }
            },
          ),
        ));
  }

  Widget _buildSelectDate(){
    return SizedBox(
      height: 60.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        itemBuilder: (context, index) {
          return _buildItemSelectDate(
            day: days[index], 
            isActive: index == currentSelectedDateIndex, 
            onTap: () {
              setState(() {
                currentSelectedDateIndex = index;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildSelectTimeCGVCinema(){
    return SizedBox(
      height: 40.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildItemSelectTime(
            time: movieTime[index], 
            isActive: currentSelectedMovieTimeIndex == index, 
            onTap: () {
              setState(() {
                  currentSelectedMovieTimeIndex = index;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildItemSelectDate({required String day, required bool isActive, required Function() onTap}){
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 60.h,
            width: 50.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? AppColors.buttonColor : AppColors.darkBackground,
              borderRadius: BorderRadius.circular(10.r)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Ngày", style: AppStyle.defaultStyle.copyWith(fontWeight: FontWeight.w500, fontSize: 12.sp),),
                SizedBox(height: 5.h,),
                Text(day, style: AppStyle.titleStyle.copyWith(fontWeight: FontWeight.w400),)
              ],
            ),
          ),
        ),
        SizedBox(width: 10.w,)
      ],
    );
  }

  Widget _buildItemSelectTime({required String time, required bool isActive, required Function() onTap}){
    return Row(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 40.h,
            width: 90.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isActive ? AppColors.buttonColor : AppColors.darkBackground,
              borderRadius: BorderRadius.circular(10.r)
            ),
            child: Text(time, style: AppStyle.defaultStyle.copyWith(fontSize: 12.sp),),
          ),
        ),
        SizedBox(width: 10.w,)
      ],
    );
  }

  Widget _builSelectCinemaType(){
    return SizedBox(
      height: 70.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () {
              
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
                          color: currentSelctCinemaTypeIndex == 0
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
            isACtive: currentSelctCinemaTypeIndex == 1,
            img: AppAssets.imgCGV,
            onTap: () {
              
            },
          ),
          SizedBox(
            width: 20.w,
          ),
          _buildItemCinemaType(
            title: "Lotte",
            isACtive: currentSelctCinemaTypeIndex == 2,
            img: AppAssets.imgLotte,
            onTap: () {
              
            },
          ),
          SizedBox(
            width: 20.w,
          ),
          _buildItemCinemaType(
            title: "Galaxy",
            isACtive: currentSelctCinemaTypeIndex == 3,
            img: AppAssets.imgGalaxy,
            onTap: () {
              
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemCinemaType(
      {required String title,
      required String img,
      required bool isACtive,
      required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 50.h,
            width: 50.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.h),
                border: Border.all(
                    color: isACtive ? AppColors.buttonColor : AppColors.grey,
                    width: 2.h),
                image:
                    DecorationImage(image: AssetImage(img), fit: BoxFit.cover)),
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
          Text(
            "Rạp Đề Xuất",
            style: AppStyle.titleStyle,
          ),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: _recomendCinemaSelect!.isNotEmpty
                ? ListView.builder(
                    itemCount: _recomendCinemaSelect!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          _buildItemCinema(cinema: _recomendCinemaSelect![index]),
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
                          style: AppStyle.titleStyle,
                        )
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }

  Widget _buildItemCinema({required Cinema cinema}){
    bool isShowMore = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return GestureDetector(
          onTap: () {
            setState((){
              isShowMore = !isShowMore;
            });
          },
          child: Column(
            children: [
              Row(
                children: [
                  ImageNetworkWidget(
                    url: cinema.thumbnail!,
                    height: 30.h,
                    width: 30.w,
                    borderRadius: 5.h,
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
                          cinema.name!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyle.titleStyle.copyWith(fontSize: 14.sp),
                        ),
                        Text(
                          cinema.address!,
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
                            style: AppStyle.defaultStyle
                                .copyWith(color: AppColors.buttonColor, fontSize: 10.sp),
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
              SizedBox(height: 10.h,),
              Visibility(
                visible: isShowMore,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("2D Phụ Đề", style: AppStyle.titleStyle,),
                    SizedBox(height: 10.h,),
                    SizedBox(
                      height: 40.h,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(  
                            crossAxisCount: 3,  
                            mainAxisExtent: 40.h
                        ), 
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return _buildItemSelectTime(
                            time: movieTime[index], 
                            isActive: false, 
                            onTap: () {
                              
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Text("2D Lòng Tiếng", style: AppStyle.titleStyle,),
                    SizedBox(height: 10.h,),
                    SizedBox(
                      height: 40.h,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(  
                            crossAxisCount: 3,  
                            mainAxisExtent: 40.h
                        ), 
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return _buildItemSelectTime(
                            time: movieTime[index], 
                            isActive: false, 
                            onTap: () {
                              
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h,),
            ],
          ),
        );
      },
    );
    
  }

  void _initDays(){
    int currentDay = currentDate.day;
    currentDay --;
    for(int i = 0; i < 14; i++){
      currentDay++;
      if(currentDay > 311){
        currentDay = 1;
      }
      days.add(currentDay.toString());
    }
    
  }

}