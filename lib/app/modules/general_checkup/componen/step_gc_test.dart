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
            general_checkup generalData = await API.GeneralID();
            List<Data>? dataList = generalData.data;
            String descriptionText = deskripsiController.text;

            if (dataList != null && dataList.isNotEmpty) {
              List<Map<String, dynamic>> gcus = [];
              for (var data in dataList) {
                if (data.gcus != null && data.gcus!.isNotEmpty) {
                  List<Map<String, dynamic>> gcuList = [];
                  for (var gcu in data.gcus!) {
                    gcuList.add({
                      "gcu_id": gcu.gcuId,
                      "status": dropdownValue,
                      "description": deskripsiController.text,
                    });
                    print('gcu_id: ${gcu.gcuId}');
                    print('status: ${dropdownValue}');
                    print('description: ${deskripsiController.text}');

                  }
                  gcus.add({
                    "sub_heading_id": data.subHeadingId,
                    "gcus": gcuList,
                  });
                  print('sub_heading_id: ${data.subHeadingId}');
                  print('gcus: ${gcuList}');
                }
              }

              gcus.forEach((item) {
                item["booking_id"] = arguments?['booking_id'];
              });
              print('booking_id: ${arguments?['booking_id']}');
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
            Navigator.pop(Get.context!);
            QuickAlert.show(
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
            general_checkup generalData = await API.GeneralID();
            List<Data>? dataList = generalData.data;
            String descriptionText = deskripsiController.text;

            if (dataList != null && dataList.isNotEmpty) {
              List<Map<String, dynamic>> gcus = [];
              for (var data in dataList) {
                if (data.gcus != null && data.gcus!.isNotEmpty) {
                  List<Map<String, dynamic>> gcuList = [];
                  for (var gcu in data.gcus!) {
                    gcuList.add({
                      "gcu_id": gcu.gcuId,
                      "status": dropdownValue, // Menggunakan status dari objek gcu
                      "description": descriptionText, // Menggunakan deskripsi dari objek gcu
                    });
                    print('gcu_id: ${gcu.gcuId.toString()}');
                  }
                  gcus.add({
                    "sub_heading_id": data.subHeadingId,
                    "gcus": gcuList,
                  });
                  print('sub_heading_id: ${data.subHeadingId}');
                }
              }
              gcus.forEach((item) {
                item["booking_id"] = arguments!['booking_id']; // Menggunakan booking_id yang diberikan (77)
              });
              print('booking_id: ${arguments!['booking_id']}');
              SubmitGC submitResponse = await API.submitGCID(
                generalCheckup: gcus,
              );

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
            Navigator.pop(Get.context!);
            Navigator.of(context).popUntil((route) => route.isFirst);
            QuickAlert.show(
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
                  hint: Text('Pilih'),
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
