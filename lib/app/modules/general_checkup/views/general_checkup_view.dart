import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  late DateTime? startTime;
  DateTime? stopTime;

  void startTimer() {
    setState(() {
      startTime = DateTime.now();
    });
  }

  void stopTimer() {
    setState(() {
      stopTime = DateTime.now();
    });
  }

  String getStartTime() {
    if (startTime != null) {
      return DateFormat('HH:mm').format(startTime!);
    } else {
      return 'Start';
    }
  }

  String getStopTime() {
    if (stopTime != null) {
      return DateFormat('HH:mm').format(stopTime!);
    } else {
      return 'Stop';
    }
  }
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
            Container(
              width: double.infinity,
              child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.blue, // foreground
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      useSafeArea: true,
                      backgroundColor: Colors.white,
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      showDragHandle: true,
                      enableDrag: true,
                      builder: (BuildContext context) {
                        return Container( // Use Container to fill the entire screen
                          height: MediaQuery.of(context).size.height, // Adjust height to fit entire screen
                          child: _buildBottomSheet(), // Your bottom sheet content
                        );
                      },
                    );

                  },
                  child: Text('Mekanik'),
                ),),
                // FutureBuilder<Mekanik>(
                //   future: API.MekanikID(),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return CircularProgressIndicator();
                //     } else if (snapshot.hasError) {
                //       return Text('Error: ${snapshot.error}');
                //     } else {
                //       if (snapshot.hasData &&
                //           snapshot.data!.dataMekanik != null &&
                //           snapshot.data!.dataMekanik!.isNotEmpty) {
                //         final List<DataMekanik> _list =
                //         snapshot.data!.dataMekanik!;
                //         final List<String> namaMekanikList = _list
                //             .map((mekanik) => mekanik.nama!)
                //             .where((nama) => nama != null)
                //             .toList();
                //         return Container(
                //           width: double.infinity,
                //           child:
                //           Column(
                //           children: [
                //             DropdownButton<String>(
                //               hint: Text('Pilih mekanik'),
                //               value: selectedMechanic,
                //               onChanged: (newValue) {
                //                 setState(() {
                //                   selectedMechanic = newValue;
                //                   showBody = true; // Show body when mechanic is selected
                //                   log('Mengubah nilai menjadi: $newValue');
                //                 });
                //               },
                //               items: namaMekanikList.map<DropdownMenuItem<String>>((String value) {
                //                 return DropdownMenuItem<String>(
                //                   value: value,
                //                   child: Text(value),
                //                 );
                //               }).toList(),
                //             ),
                //           ],
                //         ),);
                //       } else {
                //         // Menampilkan pesan jika tidak ada data Mekanik
                //         return Center(child: Text('Mekanik tidak ada'));
                //       }
                //     }
                //   },
                // ),
                SizedBox(height: 10,),
                // showBody ? Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         foregroundColor: Colors.white, backgroundColor: Colors.green, // foreground
                //       ),
                //       onPressed: startTimer,
                //       child: Text('Start'),
                //     ),
                //     ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         foregroundColor: Colors.white, backgroundColor: Colors.red, // foreground
                //       ),
                //       onPressed: stopTimer,
                //       child: Text('Stop'),
                //     ),
                //   ],
                // )
                // : Container()
              ],
            ),
          ),
          toolbarHeight: 170,
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
        body: showBody ?
                MyStepperPage() : Container(), // Show body only if showBody is true
      ),
    );
  }

  Widget _buildBottomSheet() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        bool showDropdown = false; // State variable to track whether dropdown is shown or not

        return Container(
          color: Colors.white,
          height: Get.height * 0.9,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          showDropdown = true; // Set showDropdown to true when "Tambah mekanik" button is pressed
                        });
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add),
                          Text('Tambah mekanik'),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Get.back(); // Close the bottom sheet when the close button is pressed
                      },
                    ),
                  ],
                ),
              ),
              if (showDropdown) // Show dropdown only if showDropdown is true
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
                        final List<DataMekanik> _list = snapshot.data!.dataMekanik!;
                        final List<String> namaMekanikList = _list
                            .map((mekanik) => mekanik.nama!)
                            .where((nama) => nama != null)
                            .toList();
                        return DropdownButton<String>(
                          hint: Text('Pilih mekanik'),
                          value: selectedMechanic,
                          onChanged: (newValue) {
                            setState(() {
                              selectedMechanic = newValue;
                              log('Mengubah nilai menjadi: $newValue');
                            });
                          },
                          items: namaMekanikList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        );
                      } else {
                        return Center(child: Text('Mekanik tidak ada'));
                      }
                    }
                  },
                ),
            ],
          ),
        );
      },
    );
  }


}