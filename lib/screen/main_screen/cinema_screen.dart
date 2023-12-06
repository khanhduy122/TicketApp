import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_colors.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/moduels/get_cinema_by_city/get_cinema_by_city_event.dart';
import 'package:ticket_app/moduels/get_cinema_by_city/get_cinema_city_bloc.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class CinemaScreen extends StatefulWidget {
  const CinemaScreen({super.key});

  @override
  State<CinemaScreen> createState() => _CinemaScreenState();
}

class _CinemaScreenState extends State<CinemaScreen> {

  String? _selectCity = "Sóc Trăng";
  final TextEditingController _searchCityTextController = TextEditingController();
  final GetCinemasBloc _getCinemasBloc = GetCinemasBloc();
  CinemaCity? _reconmmedCinemas;
  List<Cinema>? _recomendCinemaSelect;
  int _currentIndexCinemaType = 0;

  @override
  void initState() {
    super.initState();
    _reconmmedCinemas = context.read<DataAppProvider>().reconmmedCinemas;
    _recomendCinemaSelect = _reconmmedCinemas!.all!.sublist(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GetCinemasBloc, GetCinemasState>(
      bloc: _getCinemasBloc,
      listener: (context, state) {
        if(state.isLoading == true){
          DialogLoading.show(context);
        }

        if(state.cinemaCity != null){
          Navigator.pop(context);
          setState(() {
            _reconmmedCinemas = state.cinemaCity;
            _recomendCinemaSelect = _reconmmedCinemas!.all!.sublist(0);
          });
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
    
              children: [
                SizedBox(height: 20.h,),
    
                _searchCity(),
    
                SizedBox(height: 20.h,),
    
                _selectCinemaType(),
    
                SizedBox(height: 20.h,),
    
                _recomendCinema(_recomendCinemaSelect ?? []),
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
        color: AppColors.darkBackground
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          value: _selectCity,
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
            _getCinemasBloc.add(GetCinemasByCityEvent(cityName: value));
          },
          buttonStyleData: const ButtonStyleData(
            height: 40,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: MediaQuery.of(context).size.height / 2,
            decoration: const BoxDecoration(
              color: AppColors.darkBackground
            )
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 40,
            overlayColor: MaterialStateProperty.all<Color>(AppColors.buttonPressColor)
          ),
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
                expands: true,
                maxLines: null,
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
                    borderSide: const BorderSide(
                      color: AppColors.white
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.white
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
            },
          ),
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              _searchCityTextController.clear();
            }
          },
        ),
      )
    );
  }

  Widget _selectCinemaType() {
    return SizedBox(
      height: 70.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          GestureDetector(
            onTap: () {
              onSelectCinemaType(0);
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
                      color: _currentIndexCinemaType == 0 ? AppColors.buttonColor : AppColors.grey,
                      width: 2.h
                    )
                  ),
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
                          fit: BoxFit.scaleDown
                        )
                      ),
                    ),
                    Center(
                      child: Text("Tất Cả", style: AppStyle.defaultStyle,),
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 20.w,),
          _itemCinemaType(
            title: "CGV", 
            isACtive: _currentIndexCinemaType == 1,
            img: AppAssets.imgCGV, 
            onTap: () {
              onSelectCinemaType(1);
            },
          ),
          SizedBox(width: 20.w,),
          _itemCinemaType(
            title: "Lotte",
            isACtive: _currentIndexCinemaType == 2, 
            img: AppAssets.imgLotte, 
            onTap: () {
              onSelectCinemaType(2);
            },
          ),
          SizedBox(width: 20.w,),
          _itemCinemaType(
            title: "Galaxy", 
            isACtive: _currentIndexCinemaType == 3,
            img: AppAssets.imgGalaxy, 
            onTap: () {
              onSelectCinemaType(3);
            },
          ),
        ],
      ),
    );
  }

  void onSelectCinemaType(int index){
    if(index == 0){
      _currentIndexCinemaType = 0;
      _recomendCinemaSelect!.clear();
      _recomendCinemaSelect = _reconmmedCinemas!.all!.sublist(0);
      setState(() {
      });
    }

    if(index == 1){
      _currentIndexCinemaType = 1;
      _recomendCinemaSelect!.clear();
      _recomendCinemaSelect = _reconmmedCinemas!.cgv!.sublist(0);
      setState(() {
      });
    }

    if(index == 2){
      _currentIndexCinemaType = 2;
      _recomendCinemaSelect!.clear();
      _recomendCinemaSelect = _reconmmedCinemas!.lotte!.sublist(0);
      setState(() {
      });
    }
    if(index == 3){
      _currentIndexCinemaType = 3;
      _recomendCinemaSelect!.clear();
      _recomendCinemaSelect = _reconmmedCinemas!.galaxy!.sublist(0);
      setState(() {
      });
    }
  }

  Widget _itemCinemaType({required String title, required String img, required bool isACtive, required Function() onTap}) {
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
                    width: 2.h
                  ),
                  image: DecorationImage(
                    image: AssetImage(img),
                    fit: BoxFit.cover
                  )
                ),
              ),
              Center(
                child: Text(title, style: AppStyle.defaultStyle,),
              )
            ],
          ),
    );
  }

  Widget _recomendCinema(List<Cinema> reconmmedCinemas){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rạp Đề Xuất", style: AppStyle.titleStyle,),
          SizedBox(height: 20.h,),
          Expanded(
            child: ListView.builder(
              itemCount: reconmmedCinemas.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _itemCinema(reconmmedCinemas[index]),
                    SizedBox(height: 20.h,)
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _itemCinema(Cinema cinema){
    return Row(
      children: [
        ImageNetworkWidget(
          url: cinema.thumbnail!, 
          height: 30.h, 
          width: 30.w,
          borderRadius: 5.h,
        ),
        SizedBox(width: 10.w,),
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
              Text(cinema.getDistanceFormat(), style: AppStyle.defaultStyle.copyWith(color: AppColors.buttonColor, fontSize: 10.sp),),
              Icon(Icons.arrow_forward_ios, color: AppColors.buttonColor, size: 20.h,)
            ],
          )
        ),
      ],
    );
  }

}
