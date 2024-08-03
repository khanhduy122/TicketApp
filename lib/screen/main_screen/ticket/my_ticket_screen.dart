import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/core/const/app_assets.dart';
import 'package:ticket_app/core/const/app_colors.dart';
import 'package:ticket_app/core/const/app_styles.dart';
import 'package:ticket_app/core/routes/route_name.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/screen/main_screen/ticket/my_ticket_controller.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class MyTicketScreen extends GetView<MyTicketController> {
  const MyTicketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              TabBar(
                controller: controller.tabController,
                dividerColor: Colors.transparent,
                labelColor: AppColors.buttonColor,
                indicatorColor: AppColors.buttonColor,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(
                    text: "Vé Đang Chờ",
                  ),
                  Tab(
                    text: "Vé Đã Xem",
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TabBarView(
                      controller: controller.tabController,
                      children: [
                        tabViewNewTicket(),
                        tabViewExpiredTicket(),
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget tabViewNewTicket() {
    return Obx(
      () => controller.isLoading.value
          ? _buildLoading()
          : controller.isLoadFaild.value
              ? _buildLoadFaild()
              : _buildListTicket(controller.ticketsNew, false),
    );
  }

  Widget tabViewExpiredTicket() {
    return Obx(
      () => controller.isLoading.value
          ? _buildLoading()
          : controller.isLoadFaild.value
              ? _buildLoadFaild()
              : _buildListTicket(controller.ticketsExpired, true),
    );
  }

  Widget _buildLoadFaild() {
    return SizedBox.expand(
      child: Center(
        child: IconButton(
            onPressed: () => controller.getListTicket(),
            icon: const Icon(Icons.refresh)),
      ),
    );
  }

  Widget _buildLoading() {
    return const SizedBox.expand(
      child: Center(
          child: CircularProgressIndicator(
        color: AppColors.buttonColor,
      )),
    );
  }

  Widget _buildListTicket(List<Ticket> tickets, bool isExpired) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.imgEmpty),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Bạn chưa có vé nào",
              style: AppStyle.titleStyle,
            ),
          ],
        ),
      );
    }
    return SizedBox.expand(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildItemMyTicket(tickets[index], isExpired),
              SizedBox(
                height: 20.h,
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildItemMyTicket(Ticket ticket, bool isExpired) {
    return GestureDetector(
      onTap: () {
        if (isExpired) {
          Get.toNamed(RouteName.detailTicketExpiredScreen, arguments: ticket);
        } else {
          Get.toNamed(RouteName.detailMyTicketScreen, arguments: ticket);
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageNetworkWidget(
            url: ticket.movie!.thumbnail!,
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
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticket.movie!.name!,
                  maxLines: 3,
                  style: AppStyle.subTitleStyle,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  ticket.cinema!.name,
                  style: AppStyle.defaultStyle,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    SizedBox(
                        height: 16.h,
                        width: 16.w,
                        child: Image.asset(AppAssets.icClock)),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "${ticket.movie!.duration} phút",
                      style: AppStyle.defaultStyle,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "${ticket.showtimes!.time}, ${DateFormat("dd-MM-yyyy").format(DateTime.now()).toString()}",
                  style: AppStyle.defaultStyle,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Ghế: ${ticket.getSeatString()}",
                  style: AppStyle.defaultStyle,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
