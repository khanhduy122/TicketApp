import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ticket_app/components/const/app_assets.dart';
import 'package:ticket_app/components/const/app_colors.dart';
import 'package:ticket_app/components/const/app_styles.dart';
import 'package:ticket_app/screen/main_screen/choose_cinema/choose_cinema_screen.dart';
import 'package:ticket_app/screen/main_screen/my_ticket_screen.dart';
import 'package:ticket_app/screen/main_screen/choose_movie_screen.dart';
import 'package:ticket_app/screen/main_screen/profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // SetDataFirebaseInDay.initData(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ChooseMovieScreen(),
          ChooseCinemaScreen(),
          MyTicketScreen(),
          ProfileScreen()
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          canvasColor: AppColors.background,
        ),
        child: BottomNavigationBar(
            elevation: 1,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            onTap: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            currentIndex: _currentIndex,
            backgroundColor: AppColors.background,
            selectedLabelStyle: AppStyle.titleStyle.copyWith(fontSize: 12),
            unselectedLabelStyle: AppStyle.titleStyle.copyWith(fontSize: 12),
            items: [
              BottomNavigationBarItem(
                  label: "Chọn Phim",
                  icon: SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: Image.asset(
                      _currentIndex == 0
                          ? AppAssets.icMovieActive
                          : AppAssets.icMovieUnActive,
                      fit: BoxFit.contain,
                      color: _currentIndex == 0 ? AppColors.buttonColor : null,
                    ),
                  )),
              BottomNavigationBarItem(
                  label: "Chọn Rạp",
                  icon: SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: Image.asset(
                      _currentIndex == 1
                          ? AppAssets.icCinemaActive
                          : AppAssets.icCinemaUnActive,
                      fit: BoxFit.contain,
                      color: _currentIndex == 1 ? AppColors.buttonColor : null,
                    ),
                  )),
              BottomNavigationBarItem(
                  label: "Vé Của Tôi",
                  icon: SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: Image.asset(
                      _currentIndex == 2
                          ? AppAssets.icTicketActive
                          : AppAssets.icTicketUnActive,
                      fit: BoxFit.contain,
                      color: _currentIndex == 2 ? AppColors.buttonColor : null,
                    ),
                  )),
              BottomNavigationBarItem(
                  label: "Tôi",
                  icon: SizedBox(
                    height: 24.h,
                    width: 24.w,
                    child: Image.asset(
                      _currentIndex == 3
                          ? AppAssets.icUserActive
                          : AppAssets.icUserUnActive,
                      fit: BoxFit.contain,
                      color: _currentIndex == 3 ? AppColors.buttonColor : null,
                    ),
                  ))
            ]),
      ),
    );
  }
}
