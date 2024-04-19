import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_page/search_page.dart';
import '../../../data/data_endpoint/boking.dart';
import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';
import '../../../routes/app_pages.dart';
import 'componen/card_booking.dart';

class BokingView extends StatefulWidget {
  const BokingView({super.key});
  @override
  State<BokingView> createState() => _BokingViewState();
}

class _BokingViewState extends State<BokingView> {
  late List<RefreshController> _refreshControllers;

  @override
  void initState() {
    _refreshControllers = List.generate(7, (index) => RefreshController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          const Text('Booking'),
            FutureBuilder<Profile>(
              future: API.profile,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
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
              future: API.bokingid(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData && snapshot.data != null) {
                  final data = snapshot.data!.dataBooking;

                  if (data != null && data.isNotEmpty) {
                    return InkWell(
                      onTap: () => showSearch(
                        context: context,
                        delegate: SearchPage<DataBooking>(
                          items: data,
                          searchLabel: 'Cari History Boking',
                          searchStyle: GoogleFonts.nunito(color: Colors.black),
                          showItemsOnEmpty: true,
                          failure: Center(
                            child: Text(
                              'Pasien Tidak Terdaftar :(',
                              style: GoogleFonts.nunito(),
                            ),
                          ),
                          filter: (boking) => [
                            boking.nama,
                            boking.noPolisi,
                            boking.status,
                            boking.namaMerk,
                            boking.namaTipe,
                          ],
                          builder: (items) => BokingList(items: items),
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
                    child: Text(
                      'Terjadi kesalahan saat mengambil data.',
                      style: GoogleFonts.nunito(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(width: 20)
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Diproses'),
              Tab(text: 'Dikerjakan'),
              Tab(text: 'Estimasi'),
              Tab(text: 'Selesai Dikerjakan'),
              Tab(text: 'Invoice'),
              Tab(text: 'Ditolak'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTabContent(null), // Semua
            _buildTabContent('diproses'), // Diproses
            _buildTabContent('dikerjakan'), // Dikerjakan
            _buildTabContent('estimasi'), // Estimasi
            _buildTabContent('selesai dikerjakan'), // Selesai Dikerjakan
            _buildTabContent('invoice'), // Invoice
            _buildTabContent('ditolak'), // Ditolak
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String? status) {
    return SmartRefresher(
      controller: _refreshControllers[_getStatusIndex(status)],
      enablePullDown: true,
      header: const WaterDropHeader(),
      onRefresh: () => _onRefresh(status),
      onLoading: () => _onLoading(status),
      child: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Boking>(
              future: API.bokingid(),
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
                  Boking getDataAcc = snapshot.data!;
                  if (getDataAcc.message == 'Invalid token: Expired') {
                    Get.offAllNamed(Routes.SIGNIN);
                    return const SizedBox.shrink();
                  }
                  List<DataBooking> filteredList = status != null
                      ? getDataAcc.dataBooking!
                      .where((item) => item.status!.toLowerCase() == status)
                      .toList()
                      : getDataAcc.dataBooking!;
                  if (filteredList.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada data'),
                    );
                  }
                  return Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 475),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: filteredList
                          .map((e) => BokingList(items: e))
                          .toList(),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text('No data'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onLoading(String? status) {
    // Perform your loading operations here
    // For now, just complete the load
    _refreshControllers[_getStatusIndex(status)].loadComplete();
  }

  void _onRefresh(String? status) {
    // Perform your refresh operations here
    // For now, just complete the refresh
    _refreshControllers[_getStatusIndex(status)].refreshCompleted();
  }

  int _getStatusIndex(String? status) {
    switch (status) {
      case 'diproses':
        return 1;
      case 'dikerjakan':
        return 2;
      case 'estimasi':
        return 3;
      case 'selesai dikerjakan':
        return 4;
      case 'invoice':
        return 5;
      case 'ditolak':
        return 6;
      default:
        return 0; // Semua
    }
  }
}
