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
import '../componen/step_gc.dart';

class GeneralCheckupView extends StatefulWidget {
  const GeneralCheckupView({Key? key}) : super(key: key);

  @override
  _GeneralCheckupViewState createState() => _GeneralCheckupViewState();
}

class _GeneralCheckupViewState extends State<GeneralCheckupView> {
  Map<String, String?> status = {};
  String? selectedMechanic;
  bool _isJasaSelected = false;
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
  bool _isRunning = false;

  String selectedItem = '';
  bool showDetails = false; // Variabel untuk kontrol visibilitas layout
  TextEditingController textFieldController = TextEditingController();
  List<String> selectedItems = [];
  Map<String, bool> isStartedMap = {}; // Tracks the start/stop status for each item
  Map<String, TextEditingController> additionalInputControllers = {};
  Future<void> _startStopButtonPressed(
      int dropdownIndex,
      List<String>? dropdownOptions,
      String? selectedValue,
      Function(String?)? onChanged,
      List<String> idMekanikList,
      Map<String, String> mekanikMap,
      String kodeJasa,
      int index,
      ) async {
    final selectedKodeJasa = kodeJasa;

    setState(() {
      _isRunning = !_isRunning;
    });

    if (_isRunning) {
      try {
        print('kodeBooking: $kodeBooking');
        final selectedIdMekanik =
        idMekanikList[dropdownOptionsList[index].indexOf(selectedValue!)];
        print('ID Mekanik: $selectedIdMekanik');
        print('Kode Jasa: $selectedKodeJasa');
        var response = await API.promekID(
          role: 'start',
          kodebooking: kodeBooking ?? '',
          kodejasa: selectedKodeJasa!,
          idmekanik: selectedIdMekanik,
        );
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
    } else {
      try {
        print('Kode Jasa: $selectedKodeJasa');
        print('kodeBooking: $kodeBooking');
        final selectedIdMekanik =
        idMekanikList[dropdownOptionsList[index].indexOf(selectedValue!)];
        print('ID Mekanik: $selectedIdMekanik');
        var response = await API.promekID(
          role: 'stop',
          kodebooking: kodeBooking ?? '',
          kodejasa: selectedKodeJasa!,
          idmekanik: selectedIdMekanik,
        );
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
    }
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
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        confirmBtnColor: Colors.green,
                      );
                      return false;
                    },
                    child: _buildBottomSheet()),
              ]),
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
          surfaceTintColor: Colors.transparent,
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
                const SizedBox(
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
                        enableDrag: false,
                        backgroundColor: Colors.white,
                        isScrollControlled:
                        true, // Membuat bottom sheet fullscreen
                        useRootNavigator: true, // Menggunakan navigator root
                        builder: (BuildContext context) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            height: 700,
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                      children: <Widget>[_buildBottomSheet()]),
                                )),
                          );
                        },
                      );
                    },
                    child: const Text('Mekanik'),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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
        body: const MyStepperPage(),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          color: Colors.white,
          height: Get.height * 0.9,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RadioListTile<bool>(
                title: const Text('General check / P2H'),
                controlAffinity: ListTileControlAffinity.trailing,
                value: true,
                groupValue: showDetails ? true : null,
                onChanged: (bool? value) {
                  setState(() {
                    showDetails = true; // Setelah memilih Jasa, atur menjadi true untuk menampilkan layout
                  });
                },
              ),
              if (showDetails) // Kontrol visibilitas layout dengan variabel showDetails
                FutureBuilder<Mekanik>(
                  future: API.MekanikID(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.data != null) {
                      final mechanics = snapshot.data!.dataMekanik ?? [];
                      final dataJasa = snapshot.data!.dataJasa ?? [];

                      // Create lists of mechanic names and service codes
                      List<String?> kodeJasaList = dataJasa.map((jasa) => jasa.kodeJasa).toList();

                      // Initial selection if not already set
                      if (selectedItem.isEmpty && mechanics.isNotEmpty) {
                        selectedItem = mechanics.first.nama ?? '';
                        selectedIdMekanik = mechanics.first.idMekanik.toString();
                        selectedKodeJasa = kodeJasaList.isNotEmpty ? kodeJasaList.first : null;
                      }

                      return DropdownButton<String>(
                        value: selectedItem,
                        onChanged: (String? newValue) {
                          var newMechanic = mechanics;
                          var newKodeJasa = kodeJasaList;

                          setState(() {
                            selectedItem = newValue??"";
                            textFieldController.text = newValue??'';  // Update the text field controller
                            selectedIdMekanik = newMechanic.toString();
                            selectedKodeJasa = newKodeJasa.toString();
                          });
                        },
                        items: mechanics.map<DropdownMenuItem<String>>((mechanic) {
                          return DropdownMenuItem<String>(
                            value: mechanic.nama ?? '',
                            child: Text(mechanic.nama ?? ''),
                          );
                        }).toList(),
                      );
                    } else {
                      return Text("No data available");
                    }
                  },
                ),

              if (showDetails) // Kontrol visibilitas layout dengan variabel showDetails
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedItems.add(selectedItem);
                      isStartedMap[selectedItem] = false; // Initialize start status as false
                      additionalInputControllers[selectedItem] = TextEditingController(); // Initialize a new TextEditingController for additional inputs
                    });
                  },
                  child: Text('Tambah'),
                ),
              if (showDetails) // Kontrol visibilitas layout dengan variabel showDetails
                SizedBox(height: 20),
              if (showDetails) // Kontrol visibilitas layout dengan variabel showDetails
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedItems.length,
                    itemBuilder: (context, index) {
                      return buildTextFieldAndStartButton(selectedItems[index]);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
  Widget buildTextFieldAndStartButton(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Selected Item',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: item),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                // Cek apakah sudah start dan TextField terisi sebelum mengizinkan untuk stop
                if (isStartedMap[item] ?? false) {
                  if (additionalInputControllers[item]?.text.isNotEmpty ?? false) {
                    setState(() async {
                      isStartedMap[item] = false;  // Hanya berhenti jika TextField terisi
                    });
                    var response = await API.promekID(
                      role: 'stop',
                      kodebooking: kodeBooking??'',
                      kodejasa: selectedKodeJasa??'',
                      idmekanik: selectedIdMekanik??'',
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Error"),
                        content: Text("Please enter additional details before stopping."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                } else {
                  setState(() async {
                    isStartedMap[item] = true;  // Mulai jika belum start
                  });
                  var response = await API.promekID(
                    role: 'start',
                    kodebooking: kodeBooking??'',
                    kodejasa: selectedKodeJasa??'',
                    idmekanik: selectedIdMekanik??'',
                  );
                }
              },
              child: Text(isStartedMap[item] ?? false ? 'Stop' : 'Start'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isStartedMap[item] ?? false ? Colors.red : Colors.green,
              ),
            ),
            if (isStartedMap[item] ?? false)
              SizedBox(height: 10),
            if (isStartedMap[item] ?? false)
              TextField(
                controller: additionalInputControllers[item],
                decoration: InputDecoration(
                  labelText: 'Enter additional details',
                  border: OutlineInputBorder(),
                ),
              ),
            FutureBuilder<PromekProses>(
              future: (() async {
                return await API.PromekProsesID(
                  kodebooking: kodeBooking ?? '',
                  kodejasa: selectedKodeJasa??'',
                  idmekanik: selectedIdMekanik??'',
                );
              })(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data != null &&
                      snapshot.data!.dataPromek != null) {
                    final List<DataPromek> dataList = snapshot.data!.dataPromek!;
                    if (dataList.isNotEmpty) {
                      final DataPromek firstData = dataList[0];
                      if (firstData.startPromek != null) {
                        final startPromek = firstData.startPromek;
                        return Text(
                          'Waktu Mulai: ${startPromek} - prosess',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
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
            FutureBuilder<PromekProses>(
              future: (() async {
                return await API.PromekProsesID(
                  kodebooking: kodeBooking ?? '',
                  kodejasa: selectedKodeJasa??'',
                  idmekanik: selectedIdMekanik??'',
                );
              })(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data != null &&
                      snapshot.data!.dataPromek != null) {
                    final List<DataPromek> dataList = snapshot.data!.dataPromek!;
                    if (dataList.isNotEmpty) {
                      final DataPromek firstData = dataList[0];
                      if (firstData.stopPromek != null) {
                        final stopPromek = firstData.stopPromek;
                        return Text(
                          'Waktu Selesai: ${stopPromek}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        );
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
          ],
        ),
      ),
    );
  }
}

class DropdownItem {
  String selectedValue;
  List<String> options;

  DropdownItem(this.selectedValue, this.options);
}