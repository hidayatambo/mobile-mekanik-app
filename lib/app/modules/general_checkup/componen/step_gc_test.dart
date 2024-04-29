import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../componen/color.dart';
import '../../../data/data_endpoint/general_chackup.dart';
import '../../../data/data_endpoint/submit_gc.dart';
import '../../../data/endpoint.dart';

class MyStepperPage extends StatefulWidget {
  const MyStepperPage({super.key});

  @override
  _MyStepperPageState createState() => _MyStepperPageState();
}

class _MyStepperPageState extends State<MyStepperPage> with TickerProviderStateMixin {
  late TextEditingController deskripsiController;
  late TabController _tabController;
  int currentStep = 0;
  bool isSubmitting = false;
  String? dropdownValue;
  bool isDataSent = false;

  final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
  final List<String> stepTitles = [
    'Mesin',
    'Brake',
    'Accel',
    'Interior',
    'Exterior',
    'Bawah Kendaraan',
    'Stall Test',
  ];
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
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
    final String kodeBooking = arguments?['kode_booking'] ?? '';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
        ).copyWith(
          background: Colors.white,
          onBackground: Colors.white,
          primary: MyColors.appPrimaryColor,
          onPrimary: Colors.white,
        ),
      ),
      home :
      Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          automaticallyImplyLeading: false,
        ),
        body: Stepper(
          currentStep: currentStep,
          physics: const ScrollPhysics(),
          onStepContinue: () {
            if (currentStep < 6) {
              setState(() {
                currentStep += 1;
              });
            } else {
              submitForm(context);
            }
          },
          steps: [
            Step(
              title: const Text('Mesin'),
              content: SingleChildScrollView(
                child: buildStepContent("Mesin"),
              ),
              isActive: currentStep >= 0,
            ),
            Step(
              title: const Text('Brake'),
              content: SingleChildScrollView(
                child: buildStepContent("Brake"),
              ),
              isActive: currentStep >= 1,
            ),
            Step(
              title: const Text('Accel'),
              content: SingleChildScrollView(
                child: buildStepContent("Accel"),
              ),
              isActive: currentStep >= 2,
            ),
            Step(
              title: const Text('Interior'),
              content: SingleChildScrollView(
                child: buildStepContent("Interior"),
              ),
              isActive: currentStep >= 3,
            ),
            Step(
              title: const Text('Exterior'),
              content: SingleChildScrollView(
                child: buildStepContent("Exterior"),
              ),
              isActive: currentStep >= 4,
            ),
            Step(
              title: const Text('Bawah Kendaraan'),
              content: SingleChildScrollView(
                child: buildStepContent("Bawah Kendaraan"),
              ),
              isActive: currentStep >= 5,
            ),
            Step(
              title: const Text('Stall Test'),
              content: SingleChildScrollView(
                child: buildStepContent("Stall Test"),
              ),
              isActive: currentStep >= 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStepContent(String title) {
    return Column(children: [
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
            final getDataAcc = generalData?.data?.where((e) => e.subHeading == title).toList();
            if (getDataAcc != null && getDataAcc.isNotEmpty) {
              return
                Column(
                  children: [
                    ...getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                      return GcuItem(
                        gcu: gcus,
                        dropdownValue: dropdownValue,
                        deskripsiController: deskripsiController,
                        onDropdownChanged: (value) {
                          setState(() {
                            dropdownValue = value;
                          });
                        },
                        onDescriptionChanged: (description) {
                          setState(() {
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
            return const Center(child: Text('No data available'));
          }
        },
      ),
    ],);
  }

  void submitForm(BuildContext context) async {
    setState(() {
      isSubmitting = true;
    });

    try {
      general_checkup generalData = await API.GeneralID();
      List<Data>? dataList = generalData.data;

      List<Map<String, dynamic>> generalCheckupList = [];
      for (var i = 0; i <= currentStep; i++) {
        final title = stepTitles[i]; // assuming you have stepTitles defined
        final getDataAcc = dataList?.where((e) => e.subHeading == title).toList();
        if (getDataAcc != null && getDataAcc.isNotEmpty) {
          for (var data in getDataAcc) {
            if (data.gcus != null && data.gcus!.isNotEmpty) {
              List<Map<String, dynamic>> gcusList = [];
              for (var gcu in data.gcus!) {
                gcusList.add({
                  "gcu_id": gcu.gcuId,
                  "status": dropdownValue ?? "",
                  "description": deskripsiController.text ?? "",
                });
              }
              Map<String, dynamic> generalCheckupObj = {
                "sub_heading_id": data.subHeadingId,
                "gcus": gcusList,
              };
              print(gcusList);
              generalCheckupList.add(generalCheckupObj);
            }
          }
        }
      }

      if (generalCheckupList.isNotEmpty) {
        var kodeBooking = arguments?["booking_id"];
        var combinedData = {
          "booking_id": kodeBooking,
          "general_checkup": generalCheckupList,
        };

        QuickAlert.show(
          barrierDismissible: false,
          context: Get.context!,
          type: QuickAlertType.loading,
          headerBackgroundColor: Colors.yellow,
          text: 'Submit General Checkup...',
          confirmBtnText: 'konfirmasi',
          onConfirmBtnTap: () async {
            Navigator.pop(Get.context!); // Tutup dialog loading

            try {
              SubmitGC submitResponse = await API.submitGCID(
                generalCheckup: combinedData,
                kodeBooking: kodeBooking,
              );

              if (submitResponse.status == true &&
                  submitResponse.message == 'Berhasil Menyimpan Data') {
                isSubmitting = true;
              } else {
                isSubmitting = false;
              }
              Navigator.pop(Get.context!);
            } catch (submitError) {
              print('Submit Error: $submitError');
              Navigator.pop(Get.context!);
              QuickAlert.show(
                barrierDismissible: false,
                context: Get.context!,
                type: QuickAlertType.error,
                headerBackgroundColor: Colors.yellow,
                text: "Error submitting General Checkup: $submitError",
                confirmBtnText: 'Kembali',
                cancelBtnText: 'Kembali',
                confirmBtnColor: Colors.green,
              );
            }
          },
        );
        Navigator.pop(Get.context!);
      } else {
        QuickAlert.show(
          barrierDismissible: false,
          context: Get.context!,
          type: QuickAlertType.info,
          headerBackgroundColor: Colors.yellow,
          text: 'Tidak ada data General Checkup yang ditemukan',
          confirmBtnText: 'Kembali',
          cancelBtnText: 'Kembali',
          confirmBtnColor: Colors.green,
        );
      }
    } catch (fetchError) {
      print('Fetch Error: $fetchError');
      Navigator.pop(Get.context!);
      QuickAlert.show(
        barrierDismissible: false,
        context: Get.context!,
        type: QuickAlertType.error,
        headerBackgroundColor: Colors.yellow,
        text: "Error fetching General Checkup: $fetchError",
        confirmBtnText: 'Kembali',
        cancelBtnText: 'Kembali',
        confirmBtnColor: Colors.green,
      );
    }
  }
}

class GcuItem extends StatefulWidget {
  final Gcus gcu;
  final String? dropdownValue;
  final TextEditingController deskripsiController;
  final ValueChanged<String?> onDropdownChanged;
  final ValueChanged<String?> onDescriptionChanged;

  const GcuItem({
    Key? key,
    required this.gcu,
    required this.dropdownValue,
    required this.deskripsiController,
    required this.onDropdownChanged,
    required this.onDescriptionChanged,
  }) : super(key: key);

  @override
  _GcuItemState createState() => _GcuItemState();
}
class _GcuItemState extends State<GcuItem> {
  String? dropdownValue;
  String? description;

  @override
  void initState() {
    super.initState();
    dropdownValue = ''; // Inisialisasi nilai dropdownValue di initState
    description = ''; // Inisialisasi nilai description di initState
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
            const SizedBox(width: 8),
            Flexible(
              child: DropdownButton<String>(
                value: dropdownValue,
                hint: dropdownValue == '' ? const Text('Pilih') : null,
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value;
                  });
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
            decoration: const InputDecoration(
              hintText: 'Keterangan',
            ),
          ),
      ],
    );
  }
}


