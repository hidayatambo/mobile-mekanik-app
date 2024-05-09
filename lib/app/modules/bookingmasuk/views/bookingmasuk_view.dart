import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:mekanik/app/componen/color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../data/data_endpoint/boking.dart';
import '../../../data/endpoint.dart';
import '../componen/card_bookingmasuk.dart';

class BookingmasukView extends StatefulWidget {
  const BookingmasukView({super.key});

  @override
  State<BookingmasukView> createState() => _BookingmasukViewState();
}

class _BookingmasukViewState extends State<BookingmasukView> {
  late RefreshController _refreshController; // the refresh controller
  @override
  void initState() {
    _refreshController =
        RefreshController(); // we have to use initState because this part of the app have to restart
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
        ),
        title: Text('Booking masuk',style: TextStyle(color: MyColors.appPrimaryColor, fontWeight: FontWeight.bold), ),
        centerTitle: false,
      ),
      body: SmartRefresher(
    controller: _refreshController,
    enablePullDown: true,
    header: const WaterDropHeader(),
    onLoading: _onLoading,
    onRefresh: _onRefresh,
    child: SingleChildScrollView(
        child: FutureBuilder(
          future: API.bokingid(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState !=
                    ConnectionState.waiting &&
                snapshot.data != null) {
              Boking getDataAcc = snapshot.data ?? Boking();
              List<DataBooking> bookingStatusBookings = getDataAcc.dataBooking!
                  .where((booking) => booking.bookingStatus == 'Booking')
                  .toList();

              // Menampilkan widget Container jika daftar booking kosong
              if (bookingStatusBookings.isEmpty) {
                return Container(
                  height: 500,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/bookingorder.png',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 10,),
                      Text(
                        'Belum ada Booking Masuk hari ini',
                        style: TextStyle(color: MyColors.appPrimaryColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                );
              }

              // Menampilkan daftar booking jika tidak kosong
              return Column(
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 475),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: bookingStatusBookings
                      .map((e) {
                    return BokingListMasuk(
                      items: e,
                      onTap: () {
                        // Handler untuk ketika item diklik.
                      },
                    );
                  })
                      .toList(),
                ),
              );
            } else {
              // Menampilkan indikator loading atau pesan kesalahan jika terjadi
              return SizedBox(
                height: Get.height - 250,
                child: SingleChildScrollView(
                  child: Column(
                    children: [],
                  ),
                ),
              );
            }
          },
        ),

    ),
      ),
    );
  }
  _onLoading() {
    _refreshController
        .loadComplete(); // after data returned,set the //footer state to idle
  }

  _onRefresh() {
    HapticFeedback.lightImpact();
    setState(() {
// so whatever you want to refresh it must be inside the setState
      const BookingmasukView(); // if you only want to refresh the list you can place this, so the two can be inside setState
      _refreshController
          .refreshCompleted(); // request complete,the header will enter complete state,
// resetFooterState : it will set the footer state from noData to idle
    });
  }
}
