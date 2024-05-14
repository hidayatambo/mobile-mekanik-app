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
  String? selectedKodeJasa;
  String? selectedIdMekanik;
  bool showBody = false;
  List<List<String>> dropdownOptionsList = [[]];
  List<String?> selectedValuesList = [null];
  DateTime? startTime;
  DateTime? stopTime;
  Map<String, String> startPromekMap = {};
  Map<String, String> stopPromekMap = {};
  String? kodeBooking;
  String? nama;
  String? nama_jenissvc;
  String? kategoriKendaraanId;
  String? kendaraan;
  String? nama_tipe;
  String selectedItem = '';

  bool showDetails = false;
  TextEditingController textFieldController = TextEditingController();
  List<String> selectedItems = [];
  Map<String, bool> isStartedMap = {};
  Map<String, TextEditingController> additionalInputControllers = {};

  void updateSelectedIdMekanik(String item) {
    selectedIdMekanik = itemToIdMekanikMap[item] ?? '';
  }

  Map<String, String> itemToIdMekanikMap = {};

  Future<void> fetchAndCombineData() async {
    try {
      final promekResponse = await API.PromekProsesID(
        kodebooking: kodeBooking ?? '',
        kodejasa: selectedKodeJasa ?? '',
        idmekanik: selectedIdMekanik ?? '',
      );

      final mekanikResponse = await API.MekanikID();

      final List<DataPromek> dataPromek = promekResponse?.dataPromek ?? [];
      final List<DataMekanik> dataMekanik = mekanikResponse?.dataMekanik ?? [];

      for (var mekanik in dataMekanik) {
        for (var promek in dataPromek) {
          if (promek.idMekanik == mekanik.idMekanik) {
            itemToIdMekanikMap[mekanik.nama ?? ''] = mekanik.idMekanik.toString();
          }
        }
      }

      if (dataMekanik.isNotEmpty && selectedItem == '') {
        setState(() {
          selectedItem = dataMekanik.first.nama ?? '';
          selectedIdMekanik = dataMekanik.first.idMekanik.toString();
        });
      }
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAndCombineData();
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
                        true,
                        useRootNavigator: true,
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
                    showDetails = value ?? false;
                  });
                },
              ),
              if (showDetails)
                FutureBuilder<Mekanik>(
                  future: API.MekanikID(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final mechanics = snapshot.data?.dataMekanik ?? [];
                      final services = snapshot.data?.dataJasa ?? [];

                      print("Mechanics: ${mechanics.map((m) => m.toJson()).toList()}");
                      print("Services: ${services.map((s) => s.toJson()).toList()}");

                      if (mechanics.isNotEmpty && selectedItem == '' && services.isNotEmpty) {
                        selectedItem = mechanics.first.nama ?? '';
                        selectedIdMekanik = mechanics.first.idMekanik.toString();
                        selectedKodeJasa = services.first.kodeJasa ?? '';
                        print("First Mechanic ID: ${mechanics.first.idMekanik}, First Service Code: ${services.first.kodeJasa}");
                      }

                      return DropdownButton<String>(
                        value: selectedItem,
                        onChanged: (String? newValue) {
                          final selectedMechanic = mechanics.firstWhere(
                                (mechanic) => mechanic.nama == newValue,
                            orElse: () => DataMekanik(),
                          );

                          var matchingService = services.isNotEmpty ? services.first : DataJasa();

                          setState(() {
                            selectedItem = newValue ?? '';
                            selectedIdMekanik = selectedMechanic.idMekanik.toString();
                            selectedKodeJasa = matchingService.kodeJasa ?? '';
                          });
                        },
                        items: mechanics.map<DropdownMenuItem<String>>((mechanic) {
                          return DropdownMenuItem<String>(
                            value: mechanic.nama,
                            child: Text(mechanic.nama ?? ''),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              if (showDetails)
                ElevatedButton(
                  onPressed: () async {
                    print('$kodeBooking, $selectedKodeJasa, $selectedIdMekanik');
                    final promekResponse = await API.PromekProsesID(
                      kodebooking: kodeBooking ?? '',
                      kodejasa: selectedKodeJasa ?? '',
                      idmekanik: selectedIdMekanik ?? '',
                    );
                    if (promekResponse != null && promekResponse.dataPromek != null && promekResponse.dataPromek!.isNotEmpty) {
                      final firstData = promekResponse.dataPromek!.first;
                      if (firstData.startPromek != null) {
                        startPromekMap[selectedItem] = firstData.startPromek!;
                      } else {
                        startPromekMap[selectedItem] = 'Waktu start tidak tersedia';
                      }
                    } else {
                      startPromekMap[selectedItem] = 'Tidak ada data';
                    }
                    if (promekResponse != null && promekResponse.dataPromek != null && promekResponse.dataPromek!.isNotEmpty) {
                      final firstData = promekResponse.dataPromek!.first;
                      if (firstData.stopPromek != null) {
                        stopPromekMap[selectedItem] = firstData.stopPromek!;
                      } else {
                        stopPromekMap[selectedItem] = 'Waktu start tidak tersedia';
                      }
                    } else {
                      stopPromekMap[selectedItem] = 'Tidak ada data';
                    }
                    setState(() {
                      selectedItems.add(selectedItem);
                      isStartedMap[selectedItem] = false; // Initialize start status as false
                      additionalInputControllers[selectedItem] = TextEditingController(); // Initialize a new TextEditingController for additional inputs
                    });
                  },
                  child: const Text('Tambah'),
                ),
              if (showDetails)
                const SizedBox(height: 20),
              if (showDetails)
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
    String startPromekText = startPromekMap[item] ?? 'Tidak ada data';
    TextEditingController controllerstart = TextEditingController(text: '$startPromekText');
    String stopPromekText = stopPromekMap[item] ?? 'Tidak ada data';
    TextEditingController controllerstop = TextEditingController(text: '$stopPromekText');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child:Column(children: [
          TextField(
            readOnly: true,
            decoration: const InputDecoration(
              labelText: 'Mekanik yang Dipilih',
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
              border: const OutlineInputBorder(),
            ),
            controller: TextEditingController(text: item),
          ),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(17)
              ),
            ),
            controller: controllerstart,
          ),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(17)
              ),
            ),
            controller: controllerstop,
          ),

          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              print('kodeBooking : $kodeBooking, selectedKodeJasa : $selectedKodeJasa, selectedIdMekanik : $selectedIdMekanik');
              if (isStartedMap[item] ?? false) {
                if (additionalInputControllers[item]?.text.isNotEmpty ?? false) {
                  setState(() {
                    isStartedMap[item] = false;
                  });
                  var response = await API.promekID(
                    role: 'stop',
                    kodebooking: kodeBooking ?? '',
                    kodejasa: selectedKodeJasa ?? '',
                    idmekanik: selectedIdMekanik ?? '',
                  );
                  var response3 = await API.updateketeranganID(
                    promekid: '',
                    keteranganpromek: additionalInputControllers[item]?.text ?? '',
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Error"),
                      content: const Text("Please enter additional details before stopping."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              } else {
                setState(() {
                  isStartedMap[item] = true;
                });
                var response = await API.promekID(
                  role: 'start',
                  kodebooking: kodeBooking ?? '',
                  kodejasa: selectedKodeJasa ?? '',
                  idmekanik: selectedIdMekanik ?? '',
                );
              }
            },
            child: Text(isStartedMap[item] ?? false ? 'Stop' : 'Start'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isStartedMap[item] ?? false ? Colors.red : Colors.green,
            ),
          ),

          if (isStartedMap[item] ?? false)
            const SizedBox(height: 10),
          if (isStartedMap[item] ?? false)
            TextField(
              controller: additionalInputControllers[item],
              decoration: const InputDecoration(
                labelText: 'Enter additional details',
                border: OutlineInputBorder(),
              ),
            ),
              ],),),
        ],
      ),
    );
  }
}

class DropdownItem {
  String selectedIdMekanik;
  List<String> options;

  DropdownItem(this.selectedIdMekanik, this.options);
}