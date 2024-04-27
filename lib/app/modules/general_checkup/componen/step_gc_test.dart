import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/data_endpoint/general_chackup.dart';
import '../../../data/endpoint.dart';
import '../controllers/general_checkup_controller.dart';
import 'Visibility.dart';

class MyHomePage extends StatefulWidget {
  late final GcuItemState state;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TextEditingController textEditingController;
  List<GcuItemState> gcuItemStates = [];
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    textEditingController = TextEditingController();
    widget.state = GcuItemState(); // Initialize the state here
    widget.state.dropdownValue = dropdownValue ?? '';
    widget.state.textEditingController = textEditingController;
  }

  @override
  void dispose() {
    _tabController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  void _nextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
    final String bookingid = arguments?['booking_id'] ?? '';
    final String subheadingid = arguments?['sub_heading_id'] ?? '';
    final String gcus = arguments?['gcus'] ?? '';
    final String gcuid = arguments?['gcu_id'] ?? '';
    final String status = arguments?['status'] ?? '';
    final String description = arguments?['status'] ?? '';
    Map<String, ValueNotifier<String>> dropdownValueNotifiers = {};
    final controller = Get.put(GeneralCheckupController());

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Mesin'),
              Tab(text: 'Brake'),
              Tab(text: 'Accel'),
              Tab(text: 'Interior'),
              Tab(text: 'Exterior'),
              Tab(text: 'Bawah Kendaraan'),
              Tab(text: 'Stall Test'),
            ],
            controller: _tabController,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: List.generate(7, (index) {
            return PageStorage(
              bucket: PageStorageBucket(),
              key: PageStorageKey<String>('tab_$index'), // Unique key for each tab
              child: FutureBuilder(
                future: API.GeneralID(), // Panggil fungsi untuk mendapatkan data dari API
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final generalData = snapshot.data;
                    final subHeadings = [
                      "Mesin",
                      "Brake",
                      "Accel",
                      "Interior",
                      "Exterior",
                      "Bawah Kendaraan",
                      "Stall Test"
                    ];
                    final getDataAcc = generalData?.data
                        ?.where((e) => e.subHeading == subHeadings[index])
                        .toList();
                    if (getDataAcc != null && getDataAcc.isNotEmpty) {
                      return Column(
                        children: getDataAcc
                            .expand((e) => e.gcus ?? [])
                            .map((gcus) {
                          var gcuItemState = GcuItemState();
                          gcuItemStates.add(gcuItemState);
                          return GcuItem(
                            gcu: gcus,
                            state: gcuItemState,
                          );
                        }).toList(),
                      );
                    } else {
                      return Center(child: Text('No data available for ${subHeadings[index]}'));
                    }
                  } else {
                    return Center(child: Text('No data available'));
                  }
                },
              ),
            );
          }),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  if (_tabController.index > 0) {
                    _tabController.animateTo(_tabController.index - 1);
                  }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4.0,
                ),
                onPressed: () async {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    headerBackgroundColor: Colors.yellow,
                    text: 'Pastikan Kembali data Booking sudah sesuai ',
                    confirmBtnText: 'Submit',
                    cancelBtnText: 'Kembali',
                    confirmBtnColor: Colors.green,
                    onConfirmBtnTap: () async {
                      Navigator.pop(Get.context!);
                      try {
                        if (kDebugMode) print('booking_id: $bookingid');
                        if (kDebugMode) print('sub_heading_id: $subheadingid');
                        if (kDebugMode) print('gcus: $gcus');
                        if (kDebugMode) print('gcu_id: $gcuid');
                        if (kDebugMode) print('status: $gcuid');
                        if (kDebugMode) print('description: $gcuid');

                        // Tampilkan indikator loading
                        QuickAlert.show(
                          barrierDismissible: false,
                          context: Get.context!,
                          type: QuickAlertType.loading,
                          headerBackgroundColor: Colors.yellow,
                          text: 'Submit General Chechup...',
                        );
                        collectAndPrintResults();
                        // Panggil API untuk menyetujui booking
                        await API.submitGCID(
                          bookingid: bookingid,
                          subheadingid: subheadingid,
                          gcus: gcus,
                          gcuid: gcuid,
                          status: dropdownValue ?? '',
                          description: textEditingController.text,
                        );
                      } catch (e) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        QuickAlert.show(
                          barrierDismissible: false,
                          context: Get.context!,
                          type: QuickAlertType.success,
                          headerBackgroundColor: Colors.yellow,
                          text: 'Booking has been General Chechup',
                          confirmBtnText: 'Kembali',
                          cancelBtnText: 'Kembali',
                          confirmBtnColor: Colors.green,
                        );
                      }
                    },
                  );
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: _nextTab,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void collectAndPrintResults() {
    for (var gcuItemState in gcuItemStates) {
      print('Status: ${gcuItemState.dropdownValue}');
      if (gcuItemState.dropdownValue == 'Not Oke') {
        print('Description: ${gcuItemState.textEditingController.text}');
      }
    }
  }
}
