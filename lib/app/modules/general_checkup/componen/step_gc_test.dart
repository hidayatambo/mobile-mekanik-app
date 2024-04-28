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

class MyStepperPage extends StatefulWidget {
  const MyStepperPage({Key? key}) : super(key: key);

  @override
  _MyStepperPageState createState() => _MyStepperPageState();
}

class _MyStepperPageState extends State<MyStepperPage> with TickerProviderStateMixin {
  late TextEditingController deskripsiController;
  late TabController _tabController;
  int currentStep = 0;
  bool isSubmitting = false;
  String? dropdownValue;

  final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;

  @override
  void initState() {
    super.initState();
    deskripsiController = TextEditingController();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stepper(
        currentStep: currentStep,
        physics: ScrollPhysics(),
        onStepContinue: () {

          submitForm(context);
          if (currentStep < 6) {

            setState(() {
              currentStep += 1;

            });
          }
        },
        steps: [
          Step(
            title: Text('Mesin'),
            content: SingleChildScrollView(
              child: buildStepContent("Mesin"),
            ),
            isActive: currentStep >= 0,
          ),
          Step(
            title: Text('Brake'),
            content: SingleChildScrollView(
              child: buildStepContent("Brake"),
            ),
            isActive: currentStep >= 1,
          ),
          Step(
            title: Text('Accel'),
            content: SingleChildScrollView(
              child: buildStepContent("Accel"),
            ),
            isActive: currentStep >= 2,
          ),
          Step(
            title: Text('Interior'),
            content: SingleChildScrollView(
              child: buildStepContent("Interior"),
            ),
            isActive: currentStep >= 3,
          ),
          Step(
            title: Text('Exterior'),
            content: SingleChildScrollView(
              child: buildStepContent("Exterior"),
            ),
            isActive: currentStep >= 4,
          ),
          Step(
            title: Text('Bawah Kendaraan'),
            content: SingleChildScrollView(
              child: buildStepContent("Bawah Kendaraan"),
            ),
            isActive: currentStep >= 5,
          ),
          Step(
            title: Text('Stall Test'),
            content: SingleChildScrollView(
              child: buildStepContent("Stall Test"),
            ),
            isActive: currentStep >= 6,
          ),
        ],
      ),
    );
  }

  Widget buildStepContent(String title) {
    return FutureBuilder(
      future: API.GeneralID(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final generalData = snapshot.data;
          final getDataAcc = generalData?.data?.where((e) => e.subHeading == title).toList();
          if (getDataAcc != null && getDataAcc.isNotEmpty) {
            return
              Column(
                children: [
                  ...getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
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
                ],
              );
          } else {
            return Center(
              child: Text('No data available for $title'),
            );
          }
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  void submitForm(BuildContext context) async {
    setState(() {
      isSubmitting = true;
    });
    // Submit form logic goes here

    if (currentStep < 6) {
      // Show the dialog first
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
            // Mendapatkan data general checkup dari API
            general_checkup generalData = await API.GeneralID();
            List<Data>? dataList = generalData.data;

            // Memastikan data tidak kosong
            if (dataList != null && dataList.isNotEmpty) {
              // Persiapkan list untuk menyimpan data general checkup
              List<Map<String, dynamic>> gcus = [];

              for (var data in dataList) {
                if (data.gcus != null && data.gcus!.isNotEmpty) {
                  List<Map<String, dynamic>> gcuList = [];
                  for (var gcu in data.gcus!) {
                    gcuList.add({
                      "gcu_id": gcu.gcuId,
                      "status": dropdownValue != null ? dropdownValue : "null",
                      "description": deskripsiController.text != null ? deskripsiController.text : "",
                    });
                  }
                  // Menambahkan data general checkup ke dalam gcus sebagai objek
                  Map<String, dynamic> generalCheckupObj = {
                    "sub_heading_id": data.subHeadingId,
                    "gcus": gcuList,
                  };

                  gcus.add({
                    "booking_id": arguments?["booking_id"],
                    "general_checkup": [generalCheckupObj],
                  });
                  print('booking_id: ${arguments?["booking_id"]}');
                  print('general_checkup: ${gcus}');
                }
              }
// Mengirim data general checkup ke API
              SubmitGC submitResponse = await API.submitGCID(
                generalCheckup: gcus,
              );


              // Tampilkan pesan loading saat menunggu respons dari server
              QuickAlert.show(
                barrierDismissible: false,
                context: Get.context!,
                type: QuickAlertType.loading,
                headerBackgroundColor: Colors.yellow,
                text: 'Submit General Checkup...',
              );

              // Tampilkan pesan berdasarkan respons dari server
              if (submitResponse.status == true && submitResponse.message == 'Berhasil Menyimpan Data') {
                QuickAlert.show(
                  barrierDismissible: false,
                  context: Get.context!,
                  type: QuickAlertType.success,
                  headerBackgroundColor: Colors.yellow,
                  text: "Success to submit General Checkup",
                  confirmBtnText: 'Kembali',
                  cancelBtnText: 'Kembali',
                  confirmBtnColor: Colors.green,
                );
              } else {
                QuickAlert.show(
                  barrierDismissible: false,
                  context: Get.context!,
                  type: QuickAlertType.success,
                  headerBackgroundColor: Colors.yellow,
                  text: "Success to submit General Checkup",
                  confirmBtnText: 'Kembali',
                  cancelBtnText: 'Kembali',
                  confirmBtnColor: Colors.green,
                );
              }
            } else {
              // Tidak ada data general checkup yang ditemukan
              return;
            }
          } catch (e) {
            // Tangkap dan tampilkan error jika terjadi
            Navigator.pop(Get.context!);
            QuickAlert.show(
              barrierDismissible: false,
              context: Get.context!,
              type: QuickAlertType.success,
              headerBackgroundColor: Colors.yellow,
              text: "Success to submit General Checkup",
              confirmBtnText: 'Kembali',
              cancelBtnText: 'Kembali',
              confirmBtnColor: Colors.green,
            );
          }
        },
      );

    } else {
      // If already at the last step, show a dialog
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
            // Mendapatkan data general checkup dari API
            general_checkup generalData = await API.GeneralID();
            List<Data>? dataList = generalData.data;

            // Memastikan data tidak kosong
            if (dataList != null && dataList.isNotEmpty) {
              // Persiapkan list untuk menyimpan data general checkup
              List<Map<String, dynamic>> gcus = [];

              for (var data in dataList) {
                if (data.gcus != null && data.gcus!.isNotEmpty) {
                  List<Map<String, dynamic>> gcuList = [];
                  List<Map<String, dynamic>> gcuList2 = [];
                  for (var gcu in data.gcus!) {
                    gcuList.add({
                      "gcu_id": gcu.gcuId,
                      "status": dropdownValue,
                      "description": deskripsiController.text,
                    });
                    gcuList2.add({
                      "sub_heading_id": data.subHeadingId,
                      "gcus": gcuList,
                    });
                  }
                  gcus.add({
                    "booking_id": arguments?["booking_id"],
                    "general_checkup": gcuList2,
                  });
                  print('booking_id: ${arguments?["booking_id"]}');
                  print('sub_heading_id: ${gcuList2}');
                }
              }

              SubmitGC submitResponse = await API.submitGCID(
                generalCheckup: gcus,
              );

              print('Response dari server: $submitResponse');
              QuickAlert.show(
                barrierDismissible: false,
                context: Get.context!,
                type: QuickAlertType.loading,
                headerBackgroundColor: Colors.yellow,
                text: 'Submit General Checkup...',
              );

              print('Response dari server: $submitResponse');

              if (submitResponse.status == true && submitResponse.message == 'Berhasil Menyimpan Data') {
                QuickAlert.show(
                  barrierDismissible: false,
                  context: Get.context!,
                  type: QuickAlertType.success,
                  headerBackgroundColor: Colors.yellow,
                  text: "submitResponse.....",
                  confirmBtnText: 'Kembali',
                  cancelBtnText: 'Kembali',
                  confirmBtnColor: Colors.green,
                );
              } else {
                QuickAlert.show(
                  barrierDismissible: false,
                  context: Get.context!,
                  type: QuickAlertType.success,
                  headerBackgroundColor: Colors.yellow,
                  text: "Success to submit General Checkup",
                  confirmBtnText: 'Kembali',
                  cancelBtnText: 'Kembali',
                  confirmBtnColor: Colors.green,
                );
              }
            } else {
              return;
            }
          } catch (e) {
            Navigator.pop(Get.context!);
            Navigator.of(context).popUntil((route) => route.isFirst);
            QuickAlert.show(
              barrierDismissible: false,
              context: Get.context!,
              type: QuickAlertType.success,
              headerBackgroundColor: Colors.yellow,
              text: "Success to submit General Checkup",
              confirmBtnText: 'Kembali',
              cancelBtnText: 'Kembali',
              confirmBtnColor: Colors.green,
            );
          }
        },
      );

    }
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
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  widget.gcu.gcu ?? '',
                  textAlign: TextAlign.start,
                  softWrap: true,
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  hint: dropdownValue == '' ? Text('Pilih') : null,
                  onChanged: (String? value) {
                    if (value != _previousDropdownValue) {
                      setState(() {
                        dropdownValue = value;
                      });
                      _previousDropdownValue = value;
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
                    description = text;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Keterangan',
                ),
              ),
        ],
      );
  }
}
