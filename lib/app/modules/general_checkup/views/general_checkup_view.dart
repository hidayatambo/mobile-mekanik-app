import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/data_endpoint/mekanik.dart';
import '../../../data/data_endpoint/proses_promax.dart';
import '../../../data/endpoint.dart';
import '../componen/step_gc_test.dart';

class GeneralCheckupView extends StatefulWidget {
  const GeneralCheckupView({Key? key}) : super(key: key);

  @override
  _GeneralCheckupViewState createState() => _GeneralCheckupViewState();
}

class _GeneralCheckupViewState extends State<GeneralCheckupView> {
  Map<String, String?> status = {};
  String? selectedMechanic;
  String? selectedKodeJasa; // Menyimpan kode jasa terpilih
  String? selectedIdMekanik; // Menyimpan id mekanik terpilih
  bool showBody = false; // State to control visibility of body
  List<List<String>> dropdownOptionsList = [[]];
  List<String?> selectedValuesList = [null];
  bool _isSelected = false;
  DateTime? startTime;
  DateTime? stopTime;

  String? kodeBooking;
  String? nama;
  String? nama_jenissvc;
  String? kategoriKendaraanId;
  String? kendaraan;
  String? nama_tipe;

  void refreshMyStepperPage() {
    kodeBooking = kodeBooking;
    kategoriKendaraanId = kategoriKendaraanId;
    startTime = DateTime.now();
  }

  @override
  void initState() {
    super.initState();
    final Map? args = Get.arguments;
    kodeBooking = args?['kode_booking'];
    nama = args?['nama'];
    kategoriKendaraanId = args?['kategori_kendaraan_id'] ?? '';
    kendaraan = args?['kategori_kendaraan'];
    nama_jenissvc = args?['nama_jenissvc'];
    nama_tipe = args?['nama_tipe'];
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true, // Membuat bottom sheet fullscreen
        useRootNavigator: true, // Menggunakan navigator root
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    WillPopScope(
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
                        child:
                        _buildBottomSheet()),
                  ]
              ),
            ),
          );
        },
      );

    });
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
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
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
                            nama ?? '',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Kendaraan :',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            nama_tipe ?? '',
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
                            nama_jenissvc ?? '',
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Kode Boking :',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            kodeBooking ?? '',
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
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue, // foreground
                    ),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        showDragHandle: true,
                        context: context,
                        backgroundColor: Colors.white,
                        isScrollControlled: true, // Membuat bottom sheet fullscreen
                        useRootNavigator: true, // Menggunakan navigator root
                        builder: (BuildContext context) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            height: 700,
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: SingleChildScrollView(child:
                                Column(
                                    children: <Widget>[
                                      _buildBottomSheet()
                                    ]
                                ),
                                )

                            ),
                          );
                        },
                      );
                    },
                    child: Text('Mekanik'),
                  ),
                ),
                SizedBox(height: 10,),
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
        body: MyStepperPage(),
      ),
    );
  }

  // Fungsi untuk membangun bottom sheet
  Widget _buildBottomSheet() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          color: Colors.white,
          height: Get.height * 0.9,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Text('Produktivitas Mekanik Booking', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 30,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pilih Jasa', style: TextStyle(fontWeight: FontWeight.bold),),
                  RadioListTile(
                    title: Text('General check / P2H'),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: true,
                    groupValue: _isSelected,
                    onChanged: (value) {
                      setState(() {
                        _isSelected = value!;
                      });
                    },
                  ),
                ],
              ),
              Divider(color: Colors.grey,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pilih Mekanik', style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
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
                          dropdownOptionsList.add([]);
                          selectedValuesList.add(null);
                        });
                      },
                      child: Row(
                        children: [
                          Text('Tambah Mekanik'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Expanded(
                child: ListView.builder(
                  itemCount: dropdownOptionsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FutureBuilder<Mekanik>(
                      future: API.MekanikID(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final dataMekanik = snapshot.data?.dataMekanik;
                          final dataJasa = snapshot.data?.dataJasa;

                          if (dataMekanik != null && dataMekanik.isNotEmpty && dataJasa != null && dataJasa.isNotEmpty) {
                            List<String> namaMekanikList = dataMekanik.map((mekanik) => mekanik.nama!).toList();
                            List<String> idMekanikList = dataMekanik.map((mekanik) => mekanik.idMekanik.toString()).toList();
                            List<String> kodeJasaList = dataJasa.map((jasa) => jasa.kodeJasa.toString()).toList();

                            // Membuat map dari id mekanik dan nama mekanik
                            Map<String, String> mekanikMap = Map.fromIterables(idMekanikList, namaMekanikList);
                            dropdownOptionsList[index] = namaMekanikList;
                            if (selectedValuesList[index] == null && namaMekanikList.isNotEmpty) {
                              selectedValuesList[index] = namaMekanikList.first;
                            }

                            return  _buildDropdown(
                              index + 1,
                              dropdownOptionsList[index],
                              selectedValuesList[index],
                                  (String? newValue) {
                                setState(() {
                                  selectedValuesList[index] = newValue;
                                });
                              },
                              idMekanikList, // Daftar ID mekanik
                              mekanikMap, // Daftar nama mekanik dalam bentuk map
                              kodeJasaList[index], // Menambahkan kode jasa dari kodeJasaList
                              index,
                            );
                          } else {
                            return Center(child: Text('Mekanik atau jasa tidak ada'));
                          }
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDropdown(
      int dropdownIndex,
      List<String>? dropdownOptions,
      String? selectedValue,
      Function(String?)? onChanged,
      List<String> idMekanikList,
      Map<String, String> mekanikMap,
      String kodeJasa, // Mengubah kodeJasaList menjadi kodeJasa
      int index,
      ) {
    final List<String> namaMekanikList = mekanikMap.keys.toList();
    final selectedIdMekanik = idMekanikList[index]; // Menggunakan index untuk mengakses ID mekanik
    final selectedKodeJasa = kodeJasa; // Menggunakan kode jasa dari argumen kodeJasa
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mekanik $dropdownIndex'),
        if (dropdownOptions != null && dropdownOptions.isNotEmpty)
          DropdownButton<String>(
            value: selectedValue ?? dropdownOptions.first,
            onChanged: onChanged,
            items: List.generate(dropdownOptions.length, (index) {
              return DropdownMenuItem<String>(
                value: dropdownOptions[index],
                child: Row(
                  children: [
                    Text(dropdownOptions[index]),
                  ],
                ),
              );
            }),
          ),
        if (startTime == null)
          ElevatedButton(
            onPressed: () async {
              try {
                print('kodeBooking: $kodeBooking');
                final selectedIdMekanik = idMekanikList[dropdownOptionsList[index].indexOf(selectedValue!)];
                print('ID Mekanik: $selectedIdMekanik');
                print('Kode Jasa: $selectedKodeJasa');
                var response = await API.promekID(
                  role: 'start',
                  kodebooking: kodeBooking ?? '',
                  kodejasa: selectedKodeJasa!,
                  idmekanik: selectedIdMekanik,
                );
                // Mengatur status tampilan dan waktu mulai
                showBody = true;
                kodeBooking = kodeBooking;
                kategoriKendaraanId = kategoriKendaraanId;
                setState(() {});
                print('Response: ${response.toString()}');
              } catch (e) {
                print('Error: $e');
              }
              showBody = true;
              kodeBooking = kodeBooking;
              kategoriKendaraanId = kategoriKendaraanId;
              startTime = DateTime.now();
              Navigator.pop(context);
              setState(() {});
            },
            child: Text('Start'),
          ),
        if (startTime != null)
          ElevatedButton(
            onPressed: () async {
              try {
                print('Kode Jasa: $selectedKodeJasa');
                print('kodeBooking: $kodeBooking');
                // Dapatkan nilai terpilih dari dropdown
                final selectedIdMekanik = idMekanikList[dropdownOptionsList[index].indexOf(selectedValue!)];
                print('ID Mekanik: $selectedIdMekanik');
                var response = await API.promekID(
                  role: 'stop',
                  kodebooking: kodeBooking ?? '',
                  kodejasa: selectedKodeJasa,
                  idmekanik: selectedIdMekanik,
                );
                // Mengatur status tampilan dan waktu mulai
                showBody = true;
                kodeBooking = kodeBooking;
                kategoriKendaraanId = kategoriKendaraanId;
                setState(() {});
                print('Response: ${response.toString()}');
              } catch (e) {
                print('Error: $e');
              }
              showBody = true;
              kodeBooking = kodeBooking;
              kategoriKendaraanId = kategoriKendaraanId;
              startTime = DateTime.now();
              Navigator.pop(context);
              setState(() {});
            },
            child: Text('Stop'),
          ),
        if (stopTime != null)
          ElevatedButton(
            onPressed: () async {
              try {
                print('Kode Jasa: $selectedKodeJasa');
                print('kodeBooking: $kodeBooking');
                // Dapatkan nilai terpilih dari dropdown
                final selectedIdMekanik = idMekanikList[dropdownOptionsList[index].indexOf(selectedValue!)];
                print('ID Mekanik: $selectedIdMekanik');
                var response = await API.promekID(
                  role: 'start',
                  kodebooking: kodeBooking ?? '',
                  kodejasa: selectedKodeJasa,
                  idmekanik: selectedIdMekanik,
                );
                // Mengatur status tampilan dan waktu mulai
                showBody = true;
                kodeBooking = kodeBooking;
                kategoriKendaraanId = kategoriKendaraanId;
                setState(() {});
                print('Response: ${response.toString()}');
              } catch (e) {
                print('Error: $e');
              }
              showBody = true;
              kodeBooking = kodeBooking;
              kategoriKendaraanId = kategoriKendaraanId;
              startTime = DateTime.now();
              Navigator.pop(context);
              setState(() {});
            },
            child: Text('start'),
          ),
        Divider(color: Colors.grey,),
        const Text('History', style: TextStyle(fontWeight: FontWeight.bold), ),
        SizedBox(height: 20,),

        if (startTime != null)
          FutureBuilder<PromekProses>(
            future: (() async {
              final selectedIdMekanik = idMekanikList[dropdownOptionsList[index].indexOf(selectedValue!)];
              print('ID Mekanik: $selectedIdMekanik');
              print('kodeBooking: $kodeBooking');
              return await API.PromekProsesID(
                kodebooking: kodeBooking ?? '',
                kodejasa: selectedKodeJasa,
                idmekanik: selectedIdMekanik,
              );
            })(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data != null && snapshot.data!.dataPromek != null) {
                  final List<DataPromek> dataList = snapshot.data!.dataPromek!;
                  if (dataList.isNotEmpty) {
                    final DataPromek firstData = dataList[0];
                    if (firstData.startPromek != null) {
                      final startPromek = firstData.startPromek;
                      return Text('Waktu Mulai: ${startPromek}',style: TextStyle(fontWeight: FontWeight.bold),);
                    } else {
                      return const Text('Waktu start tidak tersedia');
                    }
                  } else {
                    return const Text('Tidak ada data');
                  }
                } else {
                  return const Text('Tidak ada data');
                }
              }
            },
          ),

        if (startTime != null)
          FutureBuilder<PromekProses>(
            future: (() async {
              final selectedIdMekanik = idMekanikList[dropdownOptionsList[index].indexOf(selectedValue!)];
              print('ID Mekanik: $selectedIdMekanik');
              print('kodeBooking: $kodeBooking');
              return await API.PromekProsesID(
                kodebooking: kodeBooking ?? '',
                kodejasa: selectedKodeJasa,
                idmekanik: selectedIdMekanik,
              );
            })(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                if (snapshot.data != null && snapshot.data!.dataPromek != null) {
                  final List<DataPromek> dataList = snapshot.data!.dataPromek!;
                  if (dataList.isNotEmpty) {
                    final DataPromek firstData = dataList[0];
                    if (firstData.stopPromek != null) {
                      final stopPromek = firstData.stopPromek;
                      return Text('Waktu selesai: ${stopPromek}',style: TextStyle(fontWeight: FontWeight.bold),);
                    } else {
                      return const Text('Waktu stop tidak tersedia');
                    }
                  } else {
                    return const Text('Tidak ada data');
                  }
                } else {
                  return const Text('Tidak ada data');
                }
              }
            },
          ),
        // Text('Waktu Selesai: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(
        //     stopTime!)}'),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Keterangan',
          ),
        ),
      ],
    );
  }


}

// Definisikan model untuk item dropdown
class DropdownItem {
  String selectedValue;
  List<String> options;

  DropdownItem(this.selectedValue, this.options);
}