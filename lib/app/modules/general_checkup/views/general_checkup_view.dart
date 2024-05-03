import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/data_endpoint/mekanik.dart';
import '../../../data/endpoint.dart';
import '../../repair_maintenen/componen/card_consument.dart';
import '../componen/step_gc_test.dart';

class GeneralCheckupView extends StatefulWidget {
  const GeneralCheckupView({Key? key}) : super(key: key);

  @override
  _GeneralCheckupViewState createState() => _GeneralCheckupViewState();
}

class _GeneralCheckupViewState extends State<GeneralCheckupView> {
  Map<String, String?> status = {};
  String? selectedMechanic;
  bool showBody = false; // State to control visibility of body

  void updateStatus(String key, String? value) {
    setState(() {
      status[key] = value;
    });
  }

  void handleSubmit() {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              for (String checkupItem in status.keys)
                ListTile(
                  title: Text(checkupItem),
                  subtitle: Text(status[checkupItem] ?? ''),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map args = Get.arguments;
    final String? bookingId = args['kode_booking'];
    final String nama = args['nama'] ?? '';
    final String nama_jenissvc = args['nama_jenissvc'] ?? '';
    final String nama_tipe = args['nama_tipe'] ?? '';

    return WillPopScope(
      onWillPop: () async {
        QuickAlert.show(
          barrierDismissible: false,
          context: Get.context!,
          type: QuickAlertType.confirm,
          headerBackgroundColor: Colors.yellow,
          text:
          'Anda Harus Selesaikan dahulu General Check Up untuk keluar dari Edit General Check Up',
          confirmBtnText: 'Kembali',
          title: 'Penting !!',
          cancelBtnText: 'Keluar',
          onCancelBtnTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
          confirmBtnColor: Colors.green,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
          ),
          title: Container(
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Edit General Check UP/P2H',
                      style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Nama :',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            '$nama',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Kendaraan :',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            '$nama_tipe',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Jenis Service :',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            '$nama_jenissvc',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Kode Boking :',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            '$bookingId',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder<Mekanik>(
                  future: API.MekanikID(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      if (snapshot.hasData &&
                          snapshot.data!.dataMekanik != null &&
                          snapshot.data!.dataMekanik!.isNotEmpty) {
                        final List<DataMekanik> _list =
                        snapshot.data!.dataMekanik!;
                        final List<String> namaMekanikList = _list
                            .map((mekanik) => mekanik.nama!)
                            .where((nama) => nama != null)
                            .toList();
                        return Column(
                          children: [
                            DropdownButton<String>(
                              hint: Text('Pilih mekanik'),
                              value: selectedMechanic,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedMechanic = newValue;
                                  showBody = true; // Show body when mechanic is selected
                                  log('Mengubah nilai menjadi: $newValue');
                                });
                              },
                              items: namaMekanikList.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      } else {
                        // Menampilkan pesan jika tidak ada data Mekanik
                        return Center(child: Text('Mekanik tidak ada'));
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          toolbarHeight: 180,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              QuickAlert.show(
                barrierDismissible: false,
                context: Get.context!,
                type: QuickAlertType.confirm,
                headerBackgroundColor: Colors.yellow,
                text:
                'Anda Harus Selesaikan dahulu General Check Up untuk keluar dari Edit General Check Up',
                confirmBtnText: 'Kembali',
                title: 'Penting !!',
                cancelBtnText: 'Keluar',
                onCancelBtnTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                confirmBtnColor: Colors.green,
              );
            },
          ),
          centerTitle: false,
          actions: const [],
        ),
        body: showBody ? MyStepperPage() : Container(), // Show body only if showBody is true
      ),
    );
  }

  Widget _buildBottomSheet() {
    final Map<String, dynamic>? arguments =
    Get.arguments as Map<String, dynamic>?;
    final Map args = Get.arguments;
    return Container(
      color: Colors.white,
      height: Get.height * 0.9,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Bottom Sheet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Get.back(); // Menutup bottom sheet saat tombol close ditekan
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: const Center(
                child: Cardmaintenent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}