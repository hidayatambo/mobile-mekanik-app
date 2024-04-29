import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../componen/color.dart';
import '../../../data/data_endpoint/general_chackup.dart';
import '../../../data/endpoint.dart';

class MyStepperPage extends StatefulWidget {
  const MyStepperPage({Key? key}) : super(key: key);

  @override
  _MyStepperPageState createState() => _MyStepperPageState();
}

class _MyStepperPageState extends State<MyStepperPage>
    with TickerProviderStateMixin {
  late TextEditingController deskripsiController;
  late TabController _tabController;
  int currentStep = 0;
  bool isSubmitting = false;
  String? dropdownValue;
  bool isDataSent = false;
  late String kodeBooking;
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
    final Map<String, dynamic>? arguments =
    Get.arguments as Map<String, dynamic>?;
    kodeBooking = arguments?['booking_id'] ?? '';
    print('Kode Booking: $kodeBooking');
  }

  @override
  void dispose() {
    _tabController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: Colors.white,
          onBackground: Colors.white,
          primary: MyColors.appPrimaryColor,
          onPrimary: Colors.white,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          automaticallyImplyLeading: false,
        ),
        body: Stepper(
          currentStep: currentStep,
          physics: const ScrollPhysics(),
          onStepContinue: () {
            submitForm(context);
            if (currentStep < 6) {
              setState(() {
                currentStep += 1;
                isSubmitting = true;
              });
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
    return Column(
      children: [
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
              final getDataAcc = generalData?.data?.where((e) =>
              e.subHeading == title).toList();
              if (getDataAcc != null && getDataAcc.isNotEmpty) {
                return Column(
                  children: [
                    ...getDataAcc
                        .expand((e) => e.gcus ?? [])
                        .map(
                          (gcus) =>
                          GcuItem(
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
                          ),
                    )
                        .toList(),
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
      ],
    );
  }

  void submitForm(BuildContext context) async {
    setState(() {
      isSubmitting = true;
    });

    try {
      final generalData = await API.GeneralID();

      if (generalData != null && generalData.data != null) {
        final dataList = generalData.data!;
        List<Map<String, dynamic>> generalCheckupList = [];
        final title = stepTitles[currentStep];
        final getDataAcc = dataList.firstWhere((e) => e.subHeading == title,
            orElse: () => null as Data);

        if (getDataAcc != null && getDataAcc.gcus != null &&
            getDataAcc.gcus!.isNotEmpty) {
          final gcusList = getDataAcc.gcus!.map<Map<String, dynamic>>((gcu) =>
          {
            "gcu_id": gcu.gcuId,
            "status": "", // Set nilai default untuk status
            "description": "", // Set nilai default untuk deskripsi
          }
          ).toList();

          final generalCheckupObj = {
            "sub_heading_id": getDataAcc.subHeadingId,
            "gcus": gcusList, // Menyimpan list gcus sebagai gcus
          };

          generalCheckupList.add(generalCheckupObj);
          final kodeBooking = this.kodeBooking ?? '';

          if (kodeBooking.isNotEmpty) {
            final combinedData = {
              "booking_id": kodeBooking,
              "general_checkup": [
                {
                  "sub_heading_id": getDataAcc.subHeadingId,
                  "gcus": gcusList,
                }
              ],
            };

            print('Data yang disubmit: $combinedData');

            final submitResponse = await API.submitGCID(
              generalCheckup: combinedData,
            );

            print('Response dari server: $submitResponse');

            if (submitResponse != null) {
              setState(() {
                isSubmitting = false;
              });
            } else {
              setState(() {
                isSubmitting = false;
              });
            }
          } else {
            // Tangani kasus ketika kodeBooking kosong
            setState(() {
              isSubmitting = false;
            });
            QuickAlert.show(
              barrierDismissible: false,
              context: Get.context!,
              type: QuickAlertType.info,
              headerBackgroundColor: Colors.yellow,
              text: 'Kode Booking tidak boleh kosong',
              confirmBtnText: 'Kembali',
              cancelBtnText: 'Kembali',
              confirmBtnColor: Colors.green,
            );
          }
        } else {
          // Tangani kasus ketika getDataAcc null atau gcus kosong
          setState(() {
            isSubmitting = false;
          });
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
      } else {
        // Tangani kasus ketika generalData null
        setState(() {
          isSubmitting = false;
        });
        QuickAlert.show(
          barrierDismissible: false,
          context: Get.context!,
          type: QuickAlertType.error,
          headerBackgroundColor: Colors.red,
          text: 'Gagal mengambil data General Checkup',
          confirmBtnText: 'Kembali',
          cancelBtnText: 'Kembali',
          confirmBtnColor: Colors.green,
        );
      }
    } catch (fetchError) {
      // Tangani kesalahan saat mengambil data
      print('Fetch Error: $fetchError');
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
                value: widget.dropdownValue,
                hint: widget.dropdownValue == '' ? const Text('Pilih') : null,
                onChanged: (String? value) {
                  setState(() {
                    widget.onDropdownChanged(value);
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
        if (widget.dropdownValue == 'Not Oke')
          TextField(
            onChanged: (text) {
              setState(() {
                widget.onDescriptionChanged(text);
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



