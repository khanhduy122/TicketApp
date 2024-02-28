import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ticket_app/components/app_assets.dart';
import 'package:ticket_app/components/app_styles.dart';
import 'package:ticket_app/components/routes/route_name.dart';
import 'package:ticket_app/models/ticket.dart';
import 'package:ticket_app/moduels/ticket/ticket_repo.dart';
import 'package:ticket_app/widgets/image_network_widget.dart';

class MyTicketScreen extends StatefulWidget {
  const MyTicketScreen({super.key});

  @override
  State<MyTicketScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<MyTicketScreen> with TickerProviderStateMixin {

  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 10.h,),
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Vé Đang Chờ",),
                  Tab(text: "Vé Đã Xem",),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      tabViewNewTicket(),
                      tabViewExpiredTicket(),
                    ]
                  ),
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }

  Widget tabViewNewTicket() {
    return StreamBuilder(
      stream: TicketRepo.getNewTickets(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.connectionState == ConnectionState.active){
          return Column(
            children: [
              SizedBox(height: 40.h,),
              _buildListMyTicket(snapshot.data?? []),
            ],
          );
        }
        return Container();
      }
    );
  }

  Widget tabViewExpiredTicket() {
    return StreamBuilder(
      stream: TicketRepo.getExpiredTickets(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator(),);
        }
        if(snapshot.connectionState == ConnectionState.active){
          return Column(
            children: [
              SizedBox(height: 40.h,),
              _buildListMyTicket(snapshot.data ?? []),
            ],
          );
        }
        return Container();
      }
    );
  }

  Widget _buildListMyTicket(List<Ticket> tickets){
    if(tickets.isEmpty){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AppAssets.imgEmpty),
            SizedBox(height: 20.h,),
            Text(
              "Bạn chưa có vé nào",
              style: AppStyle.titleStyle,
            ),
          ],
        ),
      );
    }
    return Expanded(
      child: ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              _buildItemMyTicket(tickets[index]),
              SizedBox(height: 20.h,)
            ],
          );
        },
      )
    );
  }

  Widget _buildItemMyTicket(Ticket ticket){
    return GestureDetector(
      onTap: () {
        if(ticket.isExpired == 0){
          Navigator.pushNamed(context, RouteName.detailMyTicketScreen, arguments: ticket);
        }
        else {
          Navigator.pushNamed(context, RouteName.detailTicketExpiredScreen, arguments: ticket);
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
                      child: Image.asset(AppAssets.icClock)
                    ),
                    SizedBox(width: 10.w,),
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
                  "${ticket.showtimes!}, ${DateFormat("dd-MM-yyyy").format(DateTime.now()).toString()}",
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