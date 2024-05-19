import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/components/dialogs/dialog_error.dart';
import 'package:ticket_app/components/dialogs/dialog_loading.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/components/service/cache_service.dart';
import 'package:ticket_app/models/cinema_city.dart';
import 'package:ticket_app/models/data_app_provider.dart';
import 'package:ticket_app/models/cinema.dart';
import 'package:ticket_app/models/cities.dart';
import 'package:ticket_app/moduels/cinema/cinema_bloc.dart';
import 'package:ticket_app/moduels/cinema/cinema_event.dart';
import 'package:ticket_app/moduels/cinema/cinema_state.dart';
import 'package:ticket_app/moduels/exceptions/all_exception.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class CinemaScreen extends StatefulWidget {
  const CinemaScreen({super.key});

  @override
  State<CinemaScreen> createState() => _CinemaScreenState();
}

class _CinemaScreenState extends State<CinemaScreen> {
  String? _selectCity;
  DateTime dateTime = DateTime.now();
  final TextEditingController _searchCityTextController =
      TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CinemaBloc cinemaBloc = CinemaBloc();
  CinemaCity? _allReconmmedCinemas;
  List<Cinema>? _recomendCinemaSelect;
  int _currentIndexCinemaType = 0;

  @override
  void initState() {
    super.initState();
    _allReconmmedCinemas = context.read<DataAppProvider>().reconmmedCinemas;
    _selectCity = _allReconmmedCinemas?.name ?? cities.first;
    _recomendCinemaSelect = _allReconmmedCinemas?.all?.sublist(0);
    context
        .read<DataAppProvider>()
        .setCityNameCurrent(name: _allReconmmedCinemas?.name);
  }

  @override
  void dispose() {
    super.dispose();
    _searchCityTextController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: cinemaBloc,
      listener: (_, state) {
        _listener(state);
      },
      child: Scaffold(
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              _searchCity(),
              SizedBox(
                height: 20.h,
              ),
              _selectCinemaType(),
              SizedBox(
                height: 20.h,
              ),
              _recomendCinema(),
            ],
          ),
        )),
      ),
    );
  }

  Widget _searchCity() {
    return Container(
        height: 50.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.h),
            color: AppColors.darkBackground),
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
              context.read<DataAppProvider>().setCityNameCurrent(name: value!);
              if (value == "----Chọn tĩnh / thành phố----") {
                return;
              }
              _selectCity = value!;
              CacheService.saveData("cityName", value);
              cinemaBloc
                  .add(GetCinemaCityEvent(cityName: value, context: context));
            },
            buttonStyleData: ButtonStyleData(
              height: 40,
              overlayColor:
                  MaterialStateProperty.all<Color>(Colors.transparent),
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

  Widget _selectCinemaType() {
    return SizedBox(
      height: 80.h,
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
                          color: _currentIndexCinemaType == 0
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
          _itemCinemaType(
            title: "CGV",
            isACtive: _currentIndexCinemaType == 1,
            img: AppAssets.imgCGV,
            onTap: () {
              onSelectCinemaType(1);
            },
          ),
          SizedBox(
            width: 20.w,
          ),
          _itemCinemaType(
            title: "Lotte",
            isACtive: _currentIndexCinemaType == 2,
            img: AppAssets.imgLotte,
            onTap: () {
              onSelectCinemaType(2);
            },
          ),
          SizedBox(
            width: 20.w,
          ),
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

  void onSelectCinemaType(int index) {
    if (_selectCity == cities.first) {
      setState(() {
        _currentIndexCinemaType = index;
      });
      return;
    }
    if (index == 0) {
      _currentIndexCinemaType = 0;
      _recomendCinemaSelect!.clear();
      _recomendCinemaSelect = _allReconmmedCinemas!.all!.sublist(0);
      setState(() {});
      if (_recomendCinemaSelect!.isNotEmpty && _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }

    if (index == 1) {
      _currentIndexCinemaType = 1;
      _recomendCinemaSelect!.clear();
      _recomendCinemaSelect = _allReconmmedCinemas!.cgv!.sublist(0);
      setState(() {});
      if (_recomendCinemaSelect!.isNotEmpty && _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }

    if (index == 2) {
      _currentIndexCinemaType = 2;
      _recomendCinemaSelect!.clear();
      _recomendCinemaSelect = _allReconmmedCinemas!.lotte!.sublist(0);
      setState(() {});
      if (_recomendCinemaSelect!.isNotEmpty && _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
    if (index == 3) {
      _currentIndexCinemaType = 3;
      _recomendCinemaSelect!.clear();
      _recomendCinemaSelect = _allReconmmedCinemas!.galaxy!.sublist(0);
      setState(() {});
      if (_recomendCinemaSelect!.isNotEmpty && _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
  }

  Widget _itemCinemaType(
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

  Widget _recomendCinema() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rạp Đề Xuất",
                style: AppStyle.titleStyle,
              ),
              (context.read<DataAppProvider>().locationPermisstion !=
                          PermissionStatus.granted ||
                      context.read<DataAppProvider>().serviceEnable == false)
                  ? GestureDetector(
                      onTap: () {
                        DialogError.show(
                          context: context,
                          title: "Thông Báo",
                          message:
                              "Cho phép truy cập vào vị trí mở mục cài đặt của điện thoại để MovieTicket có thể gợi ý cho bạn rạp phim gần nhất",
                          // onTap: () {},
                        );
                      },
                      child: Icon(
                        Icons.error,
                        color: AppColors.white,
                        size: 25.h,
                      ),
                    )
                  : Container(),
            ],
          ),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: _recomendCinemaSelect == null
                ? Center(
                    child: Column(
                      children: [
                        Image.asset(AppAssets.imgEmpty),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Cho phép truy cập vào vị trí mở mục cài đặt của điện thoại để MovieTicket có thể gợi ý cho bạn rạp phim gần nhất",
                          style: AppStyle.defaultStyle,
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  )
                : _recomendCinemaSelect!.isNotEmpty
                    ? ListView.builder(
                        controller: _scrollController,
                        itemCount: _recomendCinemaSelect!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              _itemCinema(_recomendCinemaSelect![index]),
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

  Widget _itemCinema(Cinema cinema) {
    return GestureDetector(
      onTap: () {
        DateTime now = DateTime.now();
        String day =
            now.day.toString().length == 1 ? "0${now.day}" : now.day.toString();
        String month = now.month.toString().length == 1
            ? "0${now.month}"
            : now.month.toString();
        String currentDate = "$day-$month-${now.year}";
        cinemaBloc.add(GetAllMovieReleasedCinemaEvent(
            cinema: cinema, date: currentDate, context: context));
      },
      child: Row(
        children: [
          ImageNetworkWidget(
            url: cinema.thumbnail,
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
                  cinema.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyle.titleStyle.copyWith(fontSize: 14.sp),
                ),
                Text(
                  cinema.address,
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
                    style: AppStyle.defaultStyle.copyWith(
                        color: AppColors.buttonColor, fontSize: 10.sp),
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
    );
  }

  void _listener(Object? state) {
    if (state is GetCinemasCityState) {
      if (state.isLoading == true) {
        DialogLoading.show(context);
      }

      if (state.cinemaCity != null) {
        Navigator.pop(context);
        setState(() {
          _allReconmmedCinemas = state.cinemaCity;
          _recomendCinemaSelect = _allReconmmedCinemas!.all!.sublist(0);
        });
      }

      if (state.error != null) {
        Navigator.pop(context);
        if (state.error is NoInternetException) {
          DialogError.show(
              context: context,
              message:
                  "Không có kết nối internet, vui lòng kiểm tra lại đường truyền");
        } else {
          DialogError.show(
              context: context,
              message: "Đã có lỗi xảy ra vui lòng thử lại sao");
        }
      }
    }

    if (state is GetAllMovieReleasedCinemaState) {
      if (state.isLoading == true) {
        DialogLoading.show(context);
      }

      if (state.cinema != null) {
        Navigator.pop(context);
        Navigator.pushNamed(context, RouteName.selectMovieScreen,
            arguments: state.cinema);
      }

      if (state.error != null) {
        Navigator.pop(context);
        if (state.error is NoInternetException) {
          DialogError.show(
              context: context,
              message:
                  "Không có kết nối internet, vui lòng kiểm tra lại đường truyền");
        } else {
          DialogError.show(
              context: context,
              message: "Đã có lỗi xảy ra vui lòng thử lại sao");
        }
      }
    }
  }
}
