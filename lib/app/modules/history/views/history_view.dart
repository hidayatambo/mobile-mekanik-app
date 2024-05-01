import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mekanik/app/data/data_endpoint/history.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_page/search_page.dart';
import '../../../componen/loading_cabang_shimmer.dart';
import '../../../componen/loading_search_shimmer.dart';
import '../../../data/data_endpoint/history.dart';
import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';
import '../componen/card_history.dart';
import '../controllers/history_controller.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String selectedStatus = 'Semua';
  late RefreshController _refreshController; // the refresh controller
  final _scaffoldKey =
  GlobalKey<ScaffoldState>(); // this is our key to the scaffold widget
  @override
  void initState() {
    _refreshController =
        RefreshController(); // we have to use initState because this part of the app have to restart
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('History'),
              FutureBuilder<Profile>(
                future: API.profileiD(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const loadcabang();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.data != null) {
                      final cabang = snapshot.data!.data?.cabang ?? "";
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cabang,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Text('Tidak ada data');
                    }
                  }
                },
              ),
            ],),
          actions: [
            FutureBuilder(
              future: API.Historyid(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: loadsearch(),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  final data = snapshot.data!.dataHistory;

                  if (data != null && data.isNotEmpty) {
                    return InkWell(
                      onTap: () => showSearch(
                        context: context,
                        delegate: SearchPage<DataHistory>(
                          items: data,
                          searchLabel: 'Cari History Booking',
                          searchStyle: GoogleFonts.nunito(color: Colors.black),
                          showItemsOnEmpty: true,
                          failure: Center(
                            child: Text(
                              'History Tidak Dtemukan :(',
                              style: GoogleFonts.nunito(),
                            ),
                          ),
                          filter: (booking) => [
                            booking.nama,
                            booking.noPolisi,
                            booking.status,
                            booking.createdByPkb,
                            booking.createdBy,
                            booking.tglEstimasi,
                            booking.tipeSvc,
                          ],
                          builder: (items) => HistoryList(items: items, onTap: () {  },),
                        ),
                      ),
                      child: const Icon(Icons.search_rounded),
                    );
                  } else {
                    return Center(
                      child: Text(
                        'Pencarian',
                        style: GoogleFonts.nunito(fontSize: 16),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: loadsearch(),
                  );
                }
              },
            ),
            const SizedBox(width: 20),
            DropdownButton<String>(
              value: selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
              items: <String>['Semua', 'ESTIMASI', 'PKB', 'PKB TUTUP', 'INVOICE']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
        body:  SmartRefresher(
        controller: _refreshController,
    enablePullDown: true,
    header: const WaterDropHeader(),
    onLoading: _onLoading,
    onRefresh: _onRefresh,
    child:
        SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: API.Historyid(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!.dataHistory ?? [];
                    List<DataHistory> filteredData = [];
                    if (selectedStatus == 'Semua') {
                      filteredData = data;
                    } else {
                      filteredData = data.where((item) => item.status == selectedStatus).toList();
                    }
                    return filteredData.isEmpty
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tidak ada antrian
                      ],
                    )
                        : Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 475),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: filteredData
                            .map(
                              (e) => HistoryList(
                            items: e,
                            onTap: () {
                              // Apa yang ingin Anda lakukan ketika item history ditekan?
                            },
                          ),
                        )
                            .toList(),
                      ),
                    );
                  } else {
                    return const SingleChildScrollView(
                      child: Column(
                        children: [],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
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
    setState(() {
// so whatever you want to refresh it must be inside the setState
      const HistoryView(); // if you only want to refresh the list you can place this, so the two can be inside setState
      _refreshController
          .refreshCompleted(); // request complete,the header will enter complete state,
// resetFooterState : it will set the footer state from noData to idle
    });
}}