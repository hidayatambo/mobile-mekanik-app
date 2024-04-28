import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/data_endpoint/general_chackup.dart';
import '../../../data/data_endpoint/submit_gc.dart';
import '../../../data/endpoint.dart';
import '../../approve/controllers/approve_controller.dart';
import '../controllers/general_checkup_controller.dart';
import 'Visibility.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? dropdownValue;
  TextEditingController deskripsiController = TextEditingController();
  List<_GcuItemState> gcuItemStates = [];
  int _previousTabIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }
  void _handleBackButton() {
    // Animate to the next tab
    _tabController.animateTo(_previousTabIndex);
  }
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 0,
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            tabs: [
              Tab(text: 'Mesin'),
              Tab(text: 'Brake'),
              Tab(text: 'Accel'),
              Tab(text: 'Interior'),
              Tab(text: 'Exterior'),
              Tab(text: 'Bawah Kendaraan'),
              Tab(text: 'Stall Test'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              SingleChildScrollView(
                child:
                FutureBuilder(
                  future: API.GeneralID(),
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
                      final generalData = snapshot.data;
                      final getDataAcc = generalData?.data
                          ?.where((e) => e.subHeading == "Stall Test")
                          .toList();
            if (getDataAcc != null && getDataAcc.isNotEmpty) {
              return Column(
                children: [
                  ...getDataAcc
                      .expand((e) => e.gcus ?? [])
                      .map((gcus) {
                    var gcuItemState = _GcuItemState();
                    gcuItemStates.add(gcuItemState);
                    return GcuItem(
                      gcu: gcus,
                      onDropdownChanged: (value) {
                        setState(() {
                          dropdownValue = value;
                        });
                      },
                      onDescriptionChanged: (description) {
                        setState(() {
                          // Update description value
                          deskripsiController.text = description!;
                        });
                      },
                    );
                  }).toList(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 4.0,
                    ),
                    onPressed: () async {
                      QuickAlert.show(
                        barrierDismissible: false,
                        context: Get.context!,
                        type: QuickAlertType.warning,
                        headerBackgroundColor: Colors.yellow,
                        text: 'Periksa kembali General Checkup',
                        confirmBtnText: 'Submit',
                        confirmBtnColor: Colors.green,
                        onConfirmBtnTap: () async {
                          try {
                            // Ambil data general checkup
                            general_checkup generalData = await API.GeneralID();
                            List<Data>? dataList = generalData.data;
                            String descriptionText = deskripsiController.text;

                            // Cek jika ada data yang diterima
                            if (dataList != null && dataList.isNotEmpty) {
                              dropdownValue = dropdownValue ?? '';
                              List<Map<String, dynamic>> gcus = []; // Menyimpan data gcus untuk dikirim ke API
                              for (var data in dataList) {
                                if (data.subHeading != null && data.gcus != null) {
                                  for (var gcu in data.gcus!) {
                                    gcus.add({
                                      "booking_id": arguments!['booking_id'],
                                      "sub_heading_id": data.subHeadingId,
                                      "sub_heading": data.subHeading, // Menambahkan sub_heading ke data yang akan dikirim
                                      "gcu_id": gcu.gcuId.toString(),
                                    });
                                    print('gcu_id: ${gcu.gcuId.toString()}');
                                    print('sub_heading: ${data.subHeading}');
                                    print('booking_id: ${arguments!['booking_id']}');
                                    print('sub_heading_id: ${data.subHeadingId}');
                                  }
                                }
                              }

                              // Panggil metode submitGCID dengan data yang sudah disusun
                              SubmitGC submitResponse = await API.submitGCID(
                                generalCheckup: gcus,
                                status: dropdownValue ?? '', // Gunakan status dari dropdownValue
                                description: descriptionText, // Gunakan deskripsi yang telah disediakan
                              );

                              // Tampilkan notifikasi sedang melakukan submit
                              QuickAlert.show(
                                barrierDismissible: false,
                                context: Get.context!,
                                type: QuickAlertType.loading,
                                headerBackgroundColor: Colors.yellow,
                                text: 'Submit General Checkup...',
                              );

                              print('Response dari server: $submitResponse');
                              print('Message: ${submitResponse.message}');

                              // Periksa status response
                              if (submitResponse.status == true && submitResponse.message == 'Berhasil Menyimpan Data') {
                                // Jika berhasil, tampilkan notifikasi sukses
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: Get.context!,
                                  type: QuickAlertType.success,
                                  headerBackgroundColor: Colors.yellow,
                                  text: submitResponse.message,
                                  confirmBtnText: 'Kembali',
                                  cancelBtnText: 'Kembali',
                                  confirmBtnColor: Colors.green,
                                );

                                // Aktifkan tab berikutnya
                              } else {
                                QuickAlert.show(
                                  // barrierDismissible: false,
                                  context: Get.context!,
                                  type: QuickAlertType.error,
                                  headerBackgroundColor: Colors.red,
                                  text: 'Failed to submit General Checkup',
                                  confirmBtnText: 'Kembali',
                                  cancelBtnText: 'Kembali',
                                  confirmBtnColor: Colors.red,
                                );
                              }
                            } else {
                              return;
                            }
                          } catch (e) {
                            // Tangani error yytrang terjadi selama proses submit
                            Navigator.pop(Get.context!);
                            _tabController.animateTo(_tabController.index + 1);
                            // _previousTabIndex = _tabController.index;
                            QuickAlert.show(
                              // barrierDismissible: false,
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

                ],
              );
            } else {
              return Center(
                child: Text('No data available for'),
              );
            }
          } else {
            return Center(child: Text('No data available'));
          }
        },
        ),
      ),
              SingleChildScrollView(
                child:
                FutureBuilder(
                  future: API.GeneralID(),
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
                      final generalData = snapshot.data;
                      final getDataAcc = generalData?.data
                          ?.where((e) => e.subHeading == "Brake")
                          .toList();
                      if (getDataAcc != null && getDataAcc.isNotEmpty) {
                        return Column(
                          children: [
                            ...getDataAcc
                                .expand((e) => e.gcus ?? [])
                                .map((gcus) {
                              var gcuItemState = _GcuItemState();
                              gcuItemStates.add(gcuItemState);
                              return GcuItem(
                                gcu: gcus,
                                onDropdownChanged: (value) {
                                  setState(() {
                                    dropdownValue = value;
                                  });
                                },
                                onDescriptionChanged: (description) {
                                  setState(() {
                                    // Update description value
                                    deskripsiController.text = description!;
                                  });
                                },
                              );
                            }).toList(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4.0,
                              ),
                              onPressed: () async {
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: Get.context!,
                                  type: QuickAlertType.warning,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Periksa kembali General Checkup',
                                  confirmBtnText: 'Submit',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () async {
                                    try {
                                      // Ambil data general checkup
                                      general_checkup generalData = await API.GeneralID();
                                      List<Data>? dataList = generalData.data;
                                      String descriptionText = deskripsiController.text;

                                      // Cek jika ada data yang diterima
                                      if (dataList != null && dataList.isNotEmpty) {
                                        dropdownValue = dropdownValue ?? '';
                                        List<Map<String, dynamic>> gcus = []; // Menyimpan data gcus untuk dikirim ke API
                                        for (var data in dataList) {
                                          if (data.subHeading != null && data.gcus != null) {
                                            for (var gcu in data.gcus!) {
                                              gcus.add({
                                                "booking_id": arguments!['booking_id'],
                                                "sub_heading_id": data.subHeadingId,
                                                "sub_heading": data.subHeading, // Menambahkan sub_heading ke data yang akan dikirim
                                                "gcu_id": gcu.gcuId.toString(),
                                              });
                                              print('gcu_id: ${gcu.gcuId.toString()}');
                                              print('sub_heading: ${data.subHeading}');
                                              print('booking_id: ${arguments!['booking_id']}');
                                              print('sub_heading_id: ${data.subHeadingId}');
                                            }
                                          }
                                        }

                                        // Panggil metode submitGCID dengan data yang sudah disusun
                                        SubmitGC submitResponse = await API.submitGCID(
                                          generalCheckup: gcus,
                                          status: dropdownValue ?? '', // Gunakan status dari dropdownValue
                                          description: descriptionText, // Gunakan deskripsi yang telah disediakan
                                        );

                                        // Tampilkan notifikasi sedang melakukan submit
                                        QuickAlert.show(
                                          barrierDismissible: false,
                                          context: Get.context!,
                                          type: QuickAlertType.loading,
                                          headerBackgroundColor: Colors.yellow,
                                          text: 'Submit General Checkup...',
                                        );

                                        print('Response dari server: $submitResponse');
                                        print('Message: ${submitResponse.message}');

                                        // Periksa status response
                                        if (submitResponse.status == true && submitResponse.message == 'Berhasil Menyimpan Data') {
                                          // Jika berhasil, tampilkan notifikasi sukses
                                          QuickAlert.show(
                                            barrierDismissible: false,
                                            context: Get.context!,
                                            type: QuickAlertType.success,
                                            headerBackgroundColor: Colors.yellow,
                                            text: submitResponse.message,
                                            confirmBtnText: 'Kembali',
                                            cancelBtnText: 'Kembali',
                                            confirmBtnColor: Colors.green,
                                          );

                                          // Aktifkan tab berikutnya
                                        } else {
                                          // Jika gagal, tampilkan notifikasi error
                                          _tabController.animateTo(_tabController.index + 2);
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
                                      } else {
                                        return;
                                      }
                                    } catch (e) {
                                      // Tangani error yang terjadi selama proses submit
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

                          ],
                        );
                      } else {
                        return Center(
                          child: Text('No data available for'),
                        );
                      }
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              ), SingleChildScrollView(
                child:
                FutureBuilder(
                  future: API.GeneralID(),
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
                      final generalData = snapshot.data;
                      final getDataAcc = generalData?.data
                          ?.where((e) => e.subHeading == "Accel")
                          .toList();
                      if (getDataAcc != null && getDataAcc.isNotEmpty) {
                        return Column(
                          children: [
                            ...getDataAcc
                                .expand((e) => e.gcus ?? [])
                                .map((gcus) {
                              var gcuItemState = _GcuItemState();
                              gcuItemStates.add(gcuItemState);
                              return GcuItem(
                                gcu: gcus,
                                onDropdownChanged: (value) {
                                  setState(() {
                                    dropdownValue = value;
                                  });
                                },
                                onDescriptionChanged: (description) {
                                  setState(() {
                                    // Update description value
                                    deskripsiController.text = description!;
                                  });
                                },
                              );
                            }).toList(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4.0,
                              ),
                              onPressed: () async {
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: Get.context!,
                                  type: QuickAlertType.warning,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Periksa kembali General Checkup',
                                  confirmBtnText: 'Submit',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () async {
                                    try {
                                      // Ambil data general checkup
                                      general_checkup generalData = await API.GeneralID();
                                      List<Data>? dataList = generalData.data;
                                      String descriptionText = deskripsiController.text;

                                      // Cek jika ada data yang diterima
                                      if (dataList != null && dataList.isNotEmpty) {
                                        dropdownValue = dropdownValue ?? '';
                                        List<Map<String, dynamic>> gcus = []; // Menyimpan data gcus untuk dikirim ke API
                                        for (var data in dataList) {
                                          if (data.subHeading != null && data.gcus != null) {
                                            for (var gcu in data.gcus!) {
                                              gcus.add({
                                                "booking_id": arguments!['booking_id'],
                                                "sub_heading_id": data.subHeadingId,
                                                "sub_heading": data.subHeading, // Menambahkan sub_heading ke data yang akan dikirim
                                                "gcu_id": gcu.gcuId.toString(),
                                              });
                                              print('gcu_id: ${gcu.gcuId.toString()}');
                                              print('sub_heading: ${data.subHeading}');
                                              print('booking_id: ${arguments!['booking_id']}');
                                              print('sub_heading_id: ${data.subHeadingId}');
                                            }
                                          }
                                        }

                                        // Panggil metode submitGCID dengan data yang sudah disusun
                                        SubmitGC submitResponse = await API.submitGCID(
                                          generalCheckup: gcus,
                                          status: dropdownValue ?? '', // Gunakan status dari dropdownValue
                                          description: descriptionText, // Gunakan deskripsi yang telah disediakan
                                        );

                                        // Tampilkan notifikasi sedang melakukan submit
                                        QuickAlert.show(
                                          barrierDismissible: false,
                                          context: Get.context!,
                                          type: QuickAlertType.loading,
                                          headerBackgroundColor: Colors.yellow,
                                          text: 'Submit General Checkup...',
                                        );

                                        print('Response dari server: $submitResponse');
                                        print('Message: ${submitResponse.message}');

                                        // Periksa status response
                                        if (submitResponse.status == true && submitResponse.message == 'Berhasil Menyimpan Data') {
                                          // Jika berhasil, tampilkan notifikasi sukses
                                          QuickAlert.show(
                                            barrierDismissible: false,
                                            context: Get.context!,
                                            type: QuickAlertType.success,
                                            headerBackgroundColor: Colors.yellow,
                                            text: submitResponse.message,
                                            confirmBtnText: 'Kembali',
                                            cancelBtnText: 'Kembali',
                                            confirmBtnColor: Colors.green,
                                          );

                                          // Aktifkan tab berikutnya
                                        } else {
                                          // Jika gagal, tampilkan notifikasi error
                                          _tabController.animateTo(_tabController.index + 3);
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
                                      } else {
                                        return;
                                      }
                                    } catch (e) {
                                      // Tangani error yang terjadi selama proses submit
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

                          ],
                        );
                      } else {
                        return Center(
                          child: Text('No data available for'),
                        );
                      }
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              ), SingleChildScrollView(
                child:
                FutureBuilder(
                  future: API.GeneralID(),
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
                      final generalData = snapshot.data;
                      final getDataAcc = generalData?.data
                          ?.where((e) => e.subHeading == "Interior")
                          .toList();
                      if (getDataAcc != null && getDataAcc.isNotEmpty) {
                        return Column(
                          children: [
                            ...getDataAcc
                                .expand((e) => e.gcus ?? [])
                                .map((gcus) {
                              var gcuItemState = _GcuItemState();
                              gcuItemStates.add(gcuItemState);
                              return GcuItem(
                                gcu: gcus,
                                onDropdownChanged: (value) {
                                  setState(() {
                                    dropdownValue = value;
                                  });
                                },
                                onDescriptionChanged: (description) {
                                  setState(() {
                                    // Update description value
                                    deskripsiController.text = description!;
                                  });
                                },
                              );
                            }).toList(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4.0,
                              ),
                              onPressed: () async {
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: Get.context!,
                                  type: QuickAlertType.warning,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Periksa kembali General Checkup',
                                  confirmBtnText: 'Submit',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () async {
                                    try {
                                      // Ambil data general checkup
                                      general_checkup generalData = await API.GeneralID();
                                      List<Data>? dataList = generalData.data;
                                      String descriptionText = deskripsiController.text;

                                      // Cek jika ada data yang diterima
                                      if (dataList != null && dataList.isNotEmpty) {
                                        dropdownValue = dropdownValue ?? '';
                                        List<Map<String, dynamic>> gcus = []; // Menyimpan data gcus untuk dikirim ke API
                                        for (var data in dataList) {
                                          if (data.subHeading != null && data.gcus != null) {
                                            for (var gcu in data.gcus!) {
                                              gcus.add({
                                                "booking_id": arguments!['booking_id'],
                                                "sub_heading_id": data.subHeadingId,
                                                "sub_heading": data.subHeading, // Menambahkan sub_heading ke data yang akan dikirim
                                                "gcu_id": gcu.gcuId.toString(),
                                              });
                                              print('gcu_id: ${gcu.gcuId.toString()}');
                                              print('sub_heading: ${data.subHeading}');
                                              print('booking_id: ${arguments!['booking_id']}');
                                              print('sub_heading_id: ${data.subHeadingId}');
                                            }
                                          }
                                        }

                                        // Panggil metode submitGCID dengan data yang sudah disusun
                                        SubmitGC submitResponse = await API.submitGCID(
                                          generalCheckup: gcus,
                                          status: dropdownValue ?? '', // Gunakan status dari dropdownValue
                                          description: descriptionText, // Gunakan deskripsi yang telah disediakan
                                        );

                                        // Tampilkan notifikasi sedang melakukan submit
                                        QuickAlert.show(
                                          barrierDismissible: false,
                                          context: Get.context!,
                                          type: QuickAlertType.loading,
                                          headerBackgroundColor: Colors.yellow,
                                          text: 'Submit General Checkup...',
                                        );

                                        print('Response dari server: $submitResponse');
                                        print('Message: ${submitResponse.message}');

                                        // Periksa status response
                                        if (submitResponse.status == true && submitResponse.message == 'Berhasil Menyimpan Data') {
                                          // Jika berhasil, tampilkan notifikasi sukses
                                          QuickAlert.show(
                                            barrierDismissible: false,
                                            context: Get.context!,
                                            type: QuickAlertType.success,
                                            headerBackgroundColor: Colors.yellow,
                                            text: submitResponse.message,
                                            confirmBtnText: 'Kembali',
                                            cancelBtnText: 'Kembali',
                                            confirmBtnColor: Colors.green,
                                          );

                                          // Aktifkan tab berikutnya
                                        } else {
                                          // Jika gagal, tampilkan notifikasi error
                                          _tabController.animateTo(_tabController.index + 4);
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
                                      } else {
                                        return;
                                      }
                                    } catch (e) {
                                      // Tangani error yang terjadi selama proses submit
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

                          ],
                        );
                      } else {
                        return Center(
                          child: Text('No data available for'),
                        );
                      }
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              ), SingleChildScrollView(
                child:
                FutureBuilder(
                  future: API.GeneralID(),
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
                      final generalData = snapshot.data;
                      final getDataAcc = generalData?.data
                          ?.where((e) => e.subHeading == "Exterior")
                          .toList();
                      if (getDataAcc != null && getDataAcc.isNotEmpty) {
                        return Column(
                          children: [
                            ...getDataAcc
                                .expand((e) => e.gcus ?? [])
                                .map((gcus) {
                              var gcuItemState = _GcuItemState();
                              gcuItemStates.add(gcuItemState);
                              return GcuItem(
                                gcu: gcus,
                                onDropdownChanged: (value) {
                                  setState(() {
                                    dropdownValue = value;
                                  });
                                },
                                onDescriptionChanged: (description) {
                                  setState(() {
                                    // Update description value
                                    deskripsiController.text = description!;
                                  });
                                },
                              );
                            }).toList(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4.0,
                              ),
                              onPressed: () async {
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: Get.context!,
                                  type: QuickAlertType.warning,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Periksa kembali General Checkup',
                                  confirmBtnText: 'Submit',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () async {
                                    try {
                                      // Ambil data general checkup
                                      general_checkup generalData = await API.GeneralID();
                                      List<Data>? dataList = generalData.data;
                                      String descriptionText = deskripsiController.text;

                                      // Cek jika ada data yang diterima
                                      if (dataList != null && dataList.isNotEmpty) {
                                        dropdownValue = dropdownValue ?? '';
                                        List<Map<String, dynamic>> gcus = []; // Menyimpan data gcus untuk dikirim ke API
                                        for (var data in dataList) {
                                          if (data.subHeading != null && data.gcus != null) {
                                            for (var gcu in data.gcus!) {
                                              gcus.add({
                                                "booking_id": arguments!['booking_id'],
                                                "sub_heading_id": data.subHeadingId,
                                                "sub_heading": data.subHeading, // Menambahkan sub_heading ke data yang akan dikirim
                                                "gcu_id": gcu.gcuId.toString(),
                                              });
                                              print('gcu_id: ${gcu.gcuId.toString()}');
                                              print('sub_heading: ${data.subHeading}');
                                              print('booking_id: ${arguments!['booking_id']}');
                                              print('sub_heading_id: ${data.subHeadingId}');
                                            }
                                          }
                                        }

                                        // Panggil metode submitGCID dengan data yang sudah disusun
                                        SubmitGC submitResponse = await API.submitGCID(
                                          generalCheckup: gcus,
                                          status: dropdownValue ?? '', // Gunakan status dari dropdownValue
                                          description: descriptionText, // Gunakan deskripsi yang telah disediakan
                                        );

                                        // Tampilkan notifikasi sedang melakukan submit
                                        QuickAlert.show(
                                          barrierDismissible: false,
                                          context: Get.context!,
                                          type: QuickAlertType.loading,
                                          headerBackgroundColor: Colors.yellow,
                                          text: 'Submit General Checkup...',
                                        );

                                        print('Response dari server: $submitResponse');
                                        print('Message: ${submitResponse.message}');

                                        // Periksa status response
                                        if (submitResponse.status == true && submitResponse.message == 'Berhasil Menyimpan Data') {
                                          // Jika berhasil, tampilkan notifikasi sukses
                                          QuickAlert.show(
                                            barrierDismissible: false,
                                            context: Get.context!,
                                            type: QuickAlertType.success,
                                            headerBackgroundColor: Colors.yellow,
                                            text: submitResponse.message,
                                            confirmBtnText: 'Kembali',
                                            cancelBtnText: 'Kembali',
                                            confirmBtnColor: Colors.green,
                                          );

                                          // Aktifkan tab berikutnya
                                        } else {
                                          // Jika gagal, tampilkan notifikasi error
                                          _tabController.animateTo(_tabController.index + 5);
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
                                      } else {
                                        return;
                                      }
                                    } catch (e) {
                                      // Tangani error yang terjadi selama proses submit
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

                          ],
                        );
                      } else {
                        return Center(
                          child: Text('No data available for'),
                        );
                      }
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              ), SingleChildScrollView(
                child:
                FutureBuilder(
                  future: API.GeneralID(),
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
                      final generalData = snapshot.data;
                      final getDataAcc = generalData?.data
                          ?.where((e) => e.subHeading == "Bawah Kendaraan")
                          .toList();
                      if (getDataAcc != null && getDataAcc.isNotEmpty) {
                        return Column(
                          children: [
                            ...getDataAcc
                                .expand((e) => e.gcus ?? [])
                                .map((gcus) {
                              var gcuItemState = _GcuItemState();
                              gcuItemStates.add(gcuItemState);
                              return GcuItem(
                                gcu: gcus,
                                onDropdownChanged: (value) {
                                  setState(() {
                                    dropdownValue = value;
                                  });
                                },
                                onDescriptionChanged: (description) {
                                  setState(() {
                                    // Update description value
                                    deskripsiController.text = description!;
                                  });
                                },
                              );
                            }).toList(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4.0,
                              ),
                              onPressed: () async {
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: Get.context!,
                                  type: QuickAlertType.warning,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Periksa kembali General Checkup',
                                  confirmBtnText: 'Submit',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () async {
                                    try {
                                      // Ambil data general checkup
                                      general_checkup generalData = await API.GeneralID();
                                      List<Data>? dataList = generalData.data;
                                      String descriptionText = deskripsiController.text;

                                      // Cek jika ada data yang diterima
                                      if (dataList != null && dataList.isNotEmpty) {
                                        dropdownValue = dropdownValue ?? '';
                                        List<Map<String, dynamic>> gcus = []; // Menyimpan data gcus untuk dikirim ke API
                                        for (var data in dataList) {
                                          if (data.subHeading != null && data.gcus != null) {
                                            for (var gcu in data.gcus!) {
                                              gcus.add({
                                                "booking_id": arguments!['booking_id'],
                                                "sub_heading_id": data.subHeadingId,
                                                "sub_heading": data.subHeading, // Menambahkan sub_heading ke data yang akan dikirim
                                                "gcu_id": gcu.gcuId.toString(),
                                              });
                                              print('gcu_id: ${gcu.gcuId.toString()}');
                                              print('sub_heading: ${data.subHeading}');
                                              print('booking_id: ${arguments!['booking_id']}');
                                              print('sub_heading_id: ${data.subHeadingId}');
                                            }
                                          }
                                        }

                                        // Panggil metode submitGCID dengan data yang sudah disusun
                                        SubmitGC submitResponse = await API.submitGCID(
                                          generalCheckup: gcus,
                                          status: dropdownValue ?? '', // Gunakan status dari dropdownValue
                                          description: descriptionText, // Gunakan deskripsi yang telah disediakan
                                        );

                                        // Tampilkan notifikasi sedang melakukan submit
                                        QuickAlert.show(
                                          barrierDismissible: false,
                                          context: Get.context!,
                                          type: QuickAlertType.loading,
                                          headerBackgroundColor: Colors.yellow,
                                          text: 'Submit General Checkup...',
                                        );

                                        print('Response dari server: $submitResponse');
                                        print('Message: ${submitResponse.message}');

                                        // Periksa status response
                                        if (submitResponse.status == true && submitResponse.message == 'Berhasil Menyimpan Data') {
                                          // Jika berhasil, tampilkan notifikasi sukses
                                          QuickAlert.show(
                                            barrierDismissible: false,
                                            context: Get.context!,
                                            type: QuickAlertType.success,
                                            headerBackgroundColor: Colors.yellow,
                                            text: submitResponse.message,
                                            confirmBtnText: 'Kembali',
                                            cancelBtnText: 'Kembali',
                                            confirmBtnColor: Colors.green,
                                          );

                                          // Aktifkan tab berikutnya
                                        } else {
                                          // Jika gagal, tampilkan notifikasi error
                                          _tabController.animateTo(_tabController.index + 6);
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
                                      } else {
                                        return;
                                      }
                                    } catch (e) {
                                      // Tangani error yang terjadi selama proses submit
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

                          ],
                        );
                      } else {
                        return Center(
                          child: Text('No data available for'),
                        );
                      }
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              ), SingleChildScrollView(
                child:
                FutureBuilder(
                  future: API.GeneralID(),
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
                      final generalData = snapshot.data;
                      final getDataAcc = generalData?.data
                          ?.where((e) => e.subHeading == "Stall Test")
                          .toList();
                      if (getDataAcc != null && getDataAcc.isNotEmpty) {
                        return Column(
                          children: [
                            ...getDataAcc
                                .expand((e) => e.gcus ?? [])
                                .map((gcus) {
                              var gcuItemState = _GcuItemState();
                              gcuItemStates.add(gcuItemState);
                              return GcuItem(
                                gcu: gcus,
                                onDropdownChanged: (value) {
                                  setState(() {
                                    dropdownValue = value;
                                  });
                                },
                                onDescriptionChanged: (description) {
                                  setState(() {
                                    // Update description value
                                    deskripsiController.text = description!;
                                  });
                                },
                              );
                            }).toList(),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 4.0,
                              ),
                              onPressed: () async {
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: Get.context!,
                                  type: QuickAlertType.warning,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Periksa kembali General Checkup',
                                  confirmBtnText: 'Submit',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () async {
                                    try {
                                      // Ambil data general checkup
                                      general_checkup generalData = await API.GeneralID();
                                      List<Data>? dataList = generalData.data;
                                      String descriptionText = deskripsiController.text;

                                      // Cek jika ada data yang diterima
                                      if (dataList != null && dataList.isNotEmpty) {
                                        dropdownValue = dropdownValue ?? '';
                                        List<Map<String, dynamic>> gcus = []; // Menyimpan data gcus untuk dikirim ke API
                                        for (var data in dataList) {
                                          if (data.subHeading != null && data.gcus != null) {
                                            for (var gcu in data.gcus!) {
                                              gcus.add({
                                                "booking_id": arguments!['booking_id'],
                                                "sub_heading_id": data.subHeadingId,
                                                "sub_heading": data.subHeading, // Menambahkan sub_heading ke data yang akan dikirim
                                                "gcu_id": gcu.gcuId.toString(),
                                              });
                                              print('gcu_id: ${gcu.gcuId.toString()}');
                                              print('sub_heading: ${data.subHeading}');
                                              print('booking_id: ${arguments!['booking_id']}');
                                              print('sub_heading_id: ${data.subHeadingId}');
                                            }
                                          }
                                        }

                                        // Panggil metode submitGCID dengan data yang sudah disusun
                                        SubmitGC submitResponse = await API.submitGCID(
                                          generalCheckup: gcus,
                                          status: dropdownValue ?? '', // Gunakan status dari dropdownValue
                                          description: descriptionText, // Gunakan deskripsi yang telah disediakan
                                        );

                                        // Tampilkan notifikasi sedang melakukan submit
                                        QuickAlert.show(
                                          barrierDismissible: false,
                                          context: Get.context!,
                                          type: QuickAlertType.loading,
                                          headerBackgroundColor: Colors.yellow,
                                          text: 'Submit General Checkup...',
                                        );

                                        print('Response dari server: $submitResponse');
                                        print('Message: ${submitResponse.message}');

                                        // Periksa status response
                                        if (submitResponse.status == true && submitResponse.message == 'Berhasil Menyimpan Data') {
                                          // Jika berhasil, tampilkan notifikasi sukses
                                          QuickAlert.show(
                                            barrierDismissible: false,
                                            context: Get.context!,
                                            type: QuickAlertType.success,
                                            headerBackgroundColor: Colors.yellow,
                                            text: submitResponse.message,
                                            confirmBtnText: 'Kembali',
                                            cancelBtnText: 'Kembali',
                                            confirmBtnColor: Colors.green,
                                          );

                                          // Aktifkan tab berikutnya
                                        } else {
                                          // Jika gagal, tampilkan notifikasi error
                                          _tabController.animateTo(_tabController.index + 7);
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
                                      } else {
                                        return;
                                      }
                                    } catch (e) {
                                      // Tangani error yang terjadi selama proses submit
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

                          ],
                        );
                      } else {
                        return Center(
                          child: Text('No data available for'),
                        );
                      }
                    } else {
                      return Center(child: Text('No data available'));
                    }
                  },
                ),
              ),
            ]
        )
      )
    );
  }
}

class GcuItem extends StatefulWidget {
  final Gcus gcu;
  final ValueChanged<String?> onDropdownChanged;
  final ValueChanged<String?> onDescriptionChanged;

  const GcuItem({
    Key? key,
    required this.gcu,
    required this.onDropdownChanged,
    required this.onDescriptionChanged,
  }) : super(key: key);

  @override
  _GcuItemState createState() => _GcuItemState();
}

class _GcuItemState extends State<GcuItem> {
  String? dropdownValue;
  String? description;
  String? _previousDropdownValue; // Tambahkan variabel _previousDropdownValue

  @override
  void initState() {
    super.initState();
    dropdownValue = ''; // Inisialisasi nilai dropdownValue di initState
    description = ''; // Inisialisasi nilai description di initState
    _previousDropdownValue = ''; // Inisialisasi nilai _previousDropdownValue di initState
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                child: Text(
                  widget.gcu.gcu ?? '',
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                flex: 1,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  hint: Text('Pilih'),
                  onChanged: (String? value) {
                    if (value != _previousDropdownValue) { // Periksa jika nilai yang baru tidak sama dengan nilai sebelumnya
                      setState(() {
                        dropdownValue = value; // Perbarui nilai dropdownValue untuk item ini
                      });
                      _previousDropdownValue = value; // Perbarui nilai _previousDropdownValue
                    }
                  },
                  items: <String>['', 'Oke', 'Not Oke'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          if (dropdownValue == 'Not Oke')
            TextField(
              onChanged: (text) {
                setState(() {
                  // Perbarui nilai description saat perubahan pada TextField
                  description = text;
                });
              },
              decoration: InputDecoration(
                hintText: 'Keterangan',
              ),
            ),
        ],
      ),
    );
  }
}
