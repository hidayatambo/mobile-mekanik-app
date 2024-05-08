import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_page/search_page.dart';

import '../../../componen/loading_cabang_shimmer.dart';
import '../../../componen/loading_search_shimmer.dart';
import '../../../componen/loading_shammer_history.dart';
import '../../../data/data_endpoint/history.dart';
import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';
import '../../../routes/app_pages.dart';
import '../componen/card_history.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {

  void clearCachedBoking() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return HistoryView2(
      clearCachedBoking: clearCachedBoking,
    );
  }
}

class HistoryView2 extends StatefulWidget {
  final VoidCallback clearCachedBoking;
  const HistoryView2({Key? key, required this.clearCachedBoking}) : super(key: key);

  @override
  _HistoryView2State createState() => _HistoryView2State();
}

class _HistoryView2State extends State<HistoryView2> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedStatus = 'Semua';
  late String? selectedService;
  late List<RefreshController> _refreshControllers;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    selectedService = 'Repair & Maintenance'; // Set to 'Repair & Maintenance' as default value
    _refreshControllers = List.generate(2, (index) => RefreshController()); // Adjust the number of RefreshControllers according to the number of tabs
    super.initState();
  }

  String? _getTabService(int index) {
    switch (index) {
      case 0:
        return 'Repair & Maintenance';
      case 1:
        return 'General Check UP/P2H';
      default:
        return null;
    }
  }

  void _handleTabSelection() {
    setState(() {
      // When tab is selected, set selectedService according to the active tab
      selectedService = _getTabService(_tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
            ],
          ),
          actions: [
            FutureBuilder(
              future: API.HistoryID(),
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
                          builder: (items) => HistoryList(items: items, onTap: () {}),
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
          ],
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.blue, // Change label color as needed
            unselectedLabelColor: Colors.grey, // Change unselected label color as needed
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white, // Change indicator color as needed
            ),
            tabs: const [
              Tab(
                text: 'Repair & Maintenance',
              ),
              Tab(
                text: 'General Check UP/P2H',
              )
            ],
          ),
          // Include other actions as needed
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildTabContent('Repair & Maintenance'),
            _buildTabContent('General Check UP/P2H'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(String tabService) {
    return SmartRefresher(
      controller: _refreshControllers[_getTabIndex(tabService)], // Use _getTabIndex to get the appropriate RefreshController index
      enablePullDown: true,
      header: const WaterDropHeader(),
      onRefresh: () => _onRefresh(tabService),
      onLoading: () => _onLoading(tabService),
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              CustomDropdown<String>(
                hintText: 'Pilih Berdasarkan Status',
                items: const <String>[
                  'Semua',
                  'ESTIMASI',
                  'PKB',
                  'PKB TUTUP',
                  'INVOICE'
                ],
                onChanged: (selectedValues) {
                  setState(() {
                    // Filtered status options based on the selected service
                    if (tabService == 'Repair & Maintenance') {
                      selectedStatus = selectedValues!;
                    } else if (tabService == 'General Check UP/P2H' && (selectedValues == 'Semua' || selectedValues == 'INVOICE'|| selectedValues == 'ESTIMASI'|| selectedValues == 'PKB'|| selectedValues == 'PKB TUTUP')) {
                      // Only allow 'Semua' and 'INVOICE' options for General Check UP/P2H
                      selectedStatus = selectedValues!;
                    } else {
                      // For other services, default to 'Semua'
                      selectedStatus = 'Semua';
                    }
                  });
                },
              ),

              FutureBuilder(
                future: API.HistoryID(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const LoadingshammerHistory();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!.dataHistory ?? [];
                    List<DataHistory> filteredData = [];
                    if (selectedStatus == 'Semua') {
                      filteredData = data.where((item) => item.tipeSvc == tabService).toList();
                    } else {
                      filteredData =
                          data.where((item) => item.status == selectedStatus && item.tipeSvc == tabService).toList();
                    }
                    return filteredData.isEmpty
                        ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // No queues
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
                              Get.toNamed(
                                Routes.DETAILHISTORY,
                                arguments: {
                                  'kode_svc': e.kodeSvc ?? '',
                                 }
                                );
                            },
                          ),
                        )
                            .toList(),
                      ),
                    );
                  } else {
                    return const Column(
                      children: [],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLoading(String status) {
    _refreshControllers[_getTabIndex(status)].loadComplete(); // Stop loading animation on the corresponding RefreshController for the active tab
  }

  void _onRefresh(String status) {
    API.HistoryID();
    if (status == 'Repair & Maintenance') {
      API.HistoryID();
      widget.clearCachedBoking();
    } else if (status == 'General Check UP/P2H') {
      API.HistoryID();
      widget.clearCachedBoking();
    }
    _refreshControllers[_getTabIndex(status)].refreshCompleted(); // Notify the RefreshController that refreshing is completed
  }

  int _getTabIndex(String tabService) {
    switch (tabService) {
      case 'Repair & Maintenance':
        return 0;
      case 'General Check UP/P2H':
        return 1;
      default:
        return 0; // Default to the first tab if the tab is not recognized
    }
  }
}
