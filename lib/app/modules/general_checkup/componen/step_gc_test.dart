import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/data_endpoint/general_chackup.dart';
import '../../../data/endpoint.dart';
import '../../approve/controllers/approve_controller.dart';
import '../controllers/general_checkup_controller.dart';
import 'Visibility.dart';
class MyHomePage extends GetView<GeneralCheckupController> {
   MyHomePage({super.key});

  late TabController _tabController;
  List<GcuItemState> gcuItemStates = [];
  String? dropdownValue;


  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
    final String bookingid = arguments?['booking_id'] ?? '';
    final String subheadingid = arguments?['sub_heading_id'] ?? '';
    final String gcus = arguments?['gcus'] ?? '';
    final String gcuid = arguments?['gcu_id'] ?? '';
    Map<String, ValueNotifier<String>> dropdownValueNotifiers = {};
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
            // controller: _tabController,
          ),
        ),
        body: TabBarView(
          // controller: _tabController,
          children: List.generate(7, (index) {
            return PageStorage(
              bucket: PageStorageBucket(),
              key: PageStorageKey<String>('tab_$index'), // Unique key for each tab
              child: SingleChildScrollView(child:
              FutureBuilder(
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
                            dropdownValue: dropdownValue, // Pass the same dropdown value to each GcuItem
                            onDropdownChanged: (value) {
                              // setState(() {
                              //   dropdownValue = value; // Update the dropdown value
                              // });
                            },
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
                  try {
                    // Panggil fungsi GeneralID untuk mendapatkan data general_checkup
                    if (kDebugMode) print('booking_id: $bookingid');
                    for (var gcuItemState in gcuItemStates) {
                      print('Status: ${gcuItemState.dropdownValue}');
                      print('gcu_id: $gcuItemState');
                      if (gcuItemState.dropdownValue == 'Not Oke') {
                        print('Description: ${controller.deskripsi.text}');
                      }
                    }

                    // Mendapatkan data general checkup dari API
                    general_checkup generalData = await API.GeneralID();

                    // Ambil sub_heading_id
                    String subheadingid = generalData.data![0].subHeadingId.toString();

                    // Ambil gcu_id dan status dari setiap gcu
                    List<Map<String, dynamic>> gcus = [];
                    List<Data>? dataList = generalData.data;
                    if (dataList != null && dataList.isNotEmpty) {
                      for (var data in dataList) {
                        if (data.gcus != null) {
                          for (var gcu in data.gcus!) {
                            gcus.add({
                              "gcu_id": gcu.gcuId.toString(),
                              "status": dropdownValue ?? '',
                              "description": controller.deskripsi.text,
                            });
                            print('gcu_id: ${gcu.gcuId.toString()}');
                            print('status: ${dropdownValue ?? ''}');
                            print('description: ${controller.deskripsi.text}');
                          }
                        }
                      }
                    }

                    // Tampilkan indikator loading
                    QuickAlert.show(
                      barrierDismissible: false,
                      context: Get.context!,
                      type: QuickAlertType.loading,
                      headerBackgroundColor: Colors.yellow,
                      text: 'Submit General Checkup...',
                    );

                    // Panggil API submitGCID dengan data yang diperoleh
                    var submitResponse = await API.submitGCID(
                      bookingid: bookingid,
                      subheadingid: subheadingid,
                      gcuid: gcuid,
                      status: dropdownValue ?? '',
                      description: controller.deskripsi.text,
                    );
                    print('Submit Response: $submitResponse');

                    // Jika berhasil, tampilkan pesan sukses
                    QuickAlert.show(
                      barrierDismissible: false,
                      context: Get.context!,
                      type: QuickAlertType.success,
                      headerBackgroundColor: Colors.yellow,
                      text: 'Booking has been General Checkup',
                      confirmBtnText: 'Kembali',
                      cancelBtnText: 'Kembali',
                      confirmBtnColor: Colors.green,
                    );
                  } catch (e) {
                    // Jika terjadi kesalahan, tampilkan pesan error
                    Navigator.pop(Get.context!);
                    QuickAlert.show(
                      barrierDismissible: false,
                      context: Get.context!,
                      type: QuickAlertType.error,
                      headerBackgroundColor: Colors.red,
                      text: 'Failed to submit General Checkup',
                      confirmBtnText: 'Kembali',
                      cancelBtnText: 'Kembali',
                      confirmBtnColor: Colors.red,
                    );
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // IconButton(
              //   icon: Icon(Icons.arrow_forward),
              //   onPressed: _nextTab,
              // ),
            ],
          ),
        ),
      ),
    );
  }

}
