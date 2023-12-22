import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/logger.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/movie.dart';
import 'package:ticket_app/moduels/get_cinema_in_city/get_cinema_in_city_bloc.dart';
import 'package:ticket_app/moduels/get_cinema_in_city/get_cinema_in_city_event.dart';
import 'package:ticket_app/moduels/get_cinema_in_city/get_cinema_in_city_state.dart';
import 'package:ticket_app/screen/auth_screen/blocs/auth_exception.dart';
import 'package:ticket_app/screen/select_filter_movie/widget/item_day_widget.dart';
import 'package:ticket_app/screen/select_filter_movie/widget/item_time_widget.dart';
import 'package:ticket_app/widgets/appbar_widget.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class SelectCinemaScreen extends StatefulWidget {
  const SelectCinemaScreen({super.key, required this.movie, required this.cinemaCity,});

  final Movie movie;
  final CinemaCity cinemaCity;

  @override
  State<SelectCinemaScreen> createState() => _SelectCinemaScreenState();
}

class _SelectCinemaScreenState extends State<SelectCinemaScreen> {

  String? _selectCity;
  int currentSelectedDateIndex = 0;
  int currentSelectedMovieTimeIndex = 0;
  int currentSelctCinemaTypeIndex = 0;
  final List<DateTime> listDateTime = [];
  final TextEditingController _searchCityTextController = TextEditingController();
  final DateTime currentDate = DateTime.now();
  CinemaCity? _allReconmmedCinemas;
  List<Cinema> _recomendCinemaSelect = [];
  final GetCinemasBloc getCinemasBloc = GetCinemasBloc();

  @override
  void initState() {
    super.initState();
    initListCinem();
  }

  @override
  void dispose() {
    super.dispose();
    _searchCityTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener(
      bloc: getCinemasBloc,
      listener: (context, state) {
        if(state is GetCinemasForMovieState){
          if(state.isLoading = true){
            DialogLoading.show(context);
          }

          if(state.cinemaCity != null){
            Navigator.of(context).pop();
            setState(() {
               _allReconmmedCinemas = state.cinemaCity;
               currentSelctCinemaTypeIndex = 0;
               _recomendCinemaSelect = _allReconmmedCinemas!.all!.sublist(0);
            });
          }

          if(state.error != null){
            if(state.error is TimeOutException){
              DialogError.show(context, "Đã có lỗi xẩy ra, vui lòng kiểm tra lại đường truyền");
            }else{
              DialogError.show(context, "Đã có lỗi xảy ra vui lòng thử lại sao");
            }
          }
        }
      },
      child: Scaffold(
        appBar: appBarWidget(title: widget.movie.name),
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
                _builSelectCinemaType(),
                SizedBox(height: 20.h,),
                _buildRecomendCinema()
              ],
            ),
          )
        ),
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
              _selectCity = value!;
              DateTime dateTime = listDateTime[currentSelectedDateIndex];
              String dateSelected = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
              getCinemasBloc.add(GetCinemasForMovieEvent(cityName: _selectCity!, movieID: widget.movie.id!, date: dateSelected));
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
          return ItemDayWidget(
            day: listDateTime[index].day, 
            isActive: index == currentSelectedDateIndex, 
            onTap: () {
              currentSelectedDateIndex = index;
              DateTime dateTime = listDateTime[index];
              String dateSelected = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
              getCinemasBloc.add(GetCinemasForMovieEvent(cityName: _selectCity!, movieID: widget.movie.id!, date: dateSelected));
            },
          );
        },
      ),
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
              onTapCinemaType(0);
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
              onTapCinemaType(1);
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
              onTapCinemaType(2);
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
              onTapCinemaType(3);
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
            child: _recomendCinemaSelect.isNotEmpty
                ? ListView.builder(
                    itemCount: _recomendCinemaSelect.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          _buildItemShowTimesCinema(cinema: _recomendCinemaSelect[index],),
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

  Widget _buildItemShowTimesCinema({required Cinema cinema}){
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
                  isShowMore ? 
                  Container(
                    width: 80.w,
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.keyboard_arrow_down, color: AppColors.white, size: 30.h,)
                  )
                  : SizedBox(
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
                    )
                  ),
                ],
              ),
              SizedBox(height: 10.h,),
              Visibility(
                visible: isShowMore,
                child: Column(
                  children: [
                    (cinema.movies![0].subtitle == null || cinema.movies![0].subtitle!.isEmpty) ? Container() : 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("2D Phụ Đề", style: AppStyle.titleStyle,),
                        SizedBox(height: 10.h,),
                        SizedBox(
                          height: cinema.movies![0].subtitle!.length % 3 == 0 ? cinema.movies![0].subtitle!.length / 3 * 50.h : (cinema.movies![0].subtitle!.length / 3 + 1) * 50.h,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(  
                                crossAxisCount: 3, 
                                mainAxisSpacing: 10.h, 
                                mainAxisExtent: 40.h
                            ), 
                            itemCount: cinema.movies![0].subtitle!.length,
                            itemBuilder: (context, index) {
                              return ItemTimeWidget(
                                time: cinema.movies![0].subtitle![index], 
                                isActive: false, 
                                onTap: () {
                                  
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 10.h,),
                      ],
                    ),
                    (cinema.movies![0].voice == null || cinema.movies![0].voice!.isEmpty) ? Container() :
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("2D Lòng Tiếng", style: AppStyle.titleStyle,),
                        SizedBox(height: 10.h,),
                        SizedBox(
                          height: cinema.movies![0].voice!.length /3 * 50.h,
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(  
                                crossAxisCount: 3, 
                                mainAxisSpacing: 10.h, 
                                mainAxisExtent: 40.h
                            ), 
                            itemCount: cinema.movies![0].voice!.length,
                            itemBuilder: (context, index) {
                              return ItemTimeWidget(
                                time: cinema.movies![0].voice![index], 
                                isActive: false, 
                                onTap: () {
                                  
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h,),
                  ],
                ) ,
              ),
            ],
          ),
        );
      },
    );
  }

  void _initDays(){
    DateTime now = DateTime.now();
    int currentDay = now.day;
    int currentMonth = now.month;
    int currentYear = now.year;
    listDateTime.add(DateTime(currentYear, currentMonth, currentDay));
    for(int i = 0; i < 14; i++){
      currentDay++;
      if(currentMonth == 4 || currentMonth == 6 || currentMonth == 9 || currentMonth == 11){
        if(currentDay > 30){
          currentDay = 1;
          currentMonth++;
        }
      }
      if(currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12){
        if(currentDay > 31){
          currentDay = 1;
          currentMonth++;
          if(currentDay > 12){
            currentMonth = 1;
            currentYear++;
          }
        }
      }
      listDateTime.add(DateTime(currentYear, currentMonth, currentDay));
    }
    
  }

  void initListCinem(){
    _allReconmmedCinemas = widget.cinemaCity;
    _recomendCinemaSelect = _allReconmmedCinemas!.all!.sublist(0);
    _selectCity = context.read<DataAppProvider>().cityNameCurrent;
    _initDays();
  }

  void onTapCinemaType(int index){
    setState(() {
      currentSelctCinemaTypeIndex = index;
      switch(index){
        case 0 : _recomendCinemaSelect = _allReconmmedCinemas!.all!.sublist(0);
          break;
        case 1 : _recomendCinemaSelect = _allReconmmedCinemas!.cgv!.sublist(0);
          break;
        case 2 : _recomendCinemaSelect = _allReconmmedCinemas!.lotte!.sublist(0);
          break;
        case 3 : _recomendCinemaSelect = _allReconmmedCinemas!.galaxy!.sublist(0);
          break;
      }
    });
    
  }

}