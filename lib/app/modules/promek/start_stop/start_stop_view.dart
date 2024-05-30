import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/data_endpoint/mekanik.dart';
import '../../../data/data_endpoint/mekanik_pkb.dart';
import '../../../data/endpoint.dart';
import '../controllers/promek_controller.dart';

class StartStopView extends StatefulWidget {
  const StartStopView({super.key});

  @override
  State<StartStopView> createState() => _StartStopViewState();
}

class _StartStopViewState extends State<StartStopView> {
  String? selectedItemJasa;
  Mekanikpkb? selectedMechanic;
  bool showDetails = false;
  TextEditingController textFieldController = TextEditingController();
  List<String> selectedItems = [];
  Map<String, bool> isStartedMap = {};
  Map<String, TextEditingController> additionalInputControllers = {};
  final PromekController controller = Get.put(PromekController());

  @override
  void initState() {
    super.initState();
    final Map args = Get.arguments;
    controller.setInitialValues(args);

  }

  @override
  Widget build(BuildContext context) {
    final Map args = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mekanik',
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
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
              child: FutureBuilder<MekanikPKB>(
                future: API.MeknaikPKBID(kodesvc: args['kode_svc'] ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final jasaList = snapshot.data?.dataJasaMekanik?.jasa ?? [];
                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), // Ensures no scroll within a scroll
                          itemCount: jasaList.length,
                          itemBuilder: (context, index) {
                            final jasa = jasaList[index];
                            return RadioListTile<String>(
                              title: Text(jasa.namaJasa ?? ''),
                              controlAffinity: ListTileControlAffinity.trailing,
                              value: jasa.namaJasa!,
                              groupValue: selectedItemJasa,
                              onChanged: (String? value) {
                                setState(() {
                                  selectedItemJasa = value;
                                  showDetails = true;
                                });
                              },
                            );
                          },
                        ),
                        if (showDetails)
                          FutureBuilder<MekanikPKB>(
                            future: API.MeknaikPKBID(kodesvc: args['kode_svc'] ?? ''),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              } else {
                                final mechanics = snapshot.data?.dataJasaMekanik?.mekanik ?? [];
                                if (mechanics.isNotEmpty && selectedMechanic == null) {
                                  selectedMechanic = mechanics.first;
                                }
                                return DropdownButton<String>(
                                  value: selectedMechanic?.nama,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedMechanic = mechanics.firstWhere((mechanic) => mechanic.nama == newValue);
                                      textFieldController.text = newValue ?? '';
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
                            onPressed: () {
                              setState(() {
                                if (selectedMechanic != null) {
                                  selectedItems.add(selectedMechanic!.nama ?? '');
                                  isStartedMap[selectedMechanic!.nama ?? ''] = false;
                                  additionalInputControllers[selectedMechanic!.nama ?? ''] = TextEditingController();
                                }
                              });
                            },
                            child: Text('Tambah'),
                          ),
                        if (showDetails) SizedBox(height: 20),
                        ...selectedItems.map((item) => buildTextFieldAndStartButton(item)).toList(),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextFieldAndStartButton(String item) {
    final Map args = Get.arguments;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
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
              if (selectedMechanic == null) {
                QuickAlert.show(
                  barrierDismissible: false,
                  context: Get.context!,
                  type: QuickAlertType.warning,
                  headerBackgroundColor: Colors.yellow,
                  text: 'Pilih mekanik terlebih dahulu',
                  confirmBtnText: 'Oke',
                  title: 'Penting !!',
                  confirmBtnColor: Colors.green,
                );
                return;
              }

              bool isStarted = isStartedMap[item] == true;
              String role = isStarted ? 'stop' : 'start';
              String kodejasa = selectedItemJasa ?? '';
              String idmekanik = selectedMechanic?.id.toString() ?? '';
              String kodesvc = Get.arguments['kode_svc'] ?? '';

              try {
                var response = await API.InsertPromexoPKBID(
                  role: role,
                  kodejasa: kodejasa,
                  idmekanik: idmekanik,
                  kodesvc: kodesvc,
                );

                if (response.status == 200) {
                  setState(() {
                    if (isStarted) {
                      if (additionalInputControllers[item]?.text.isNotEmpty ?? false) {
                        isStartedMap[item] = false;  // Hanya berhenti jika TextField terisi
                      } else {
                        QuickAlert.show(
                          barrierDismissible: false,
                          context: Get.context!,
                          type: QuickAlertType.warning,
                          headerBackgroundColor: Colors.yellow,
                          text: 'Anda harus isi keterangan dahulu sebelum berhenti',
                          confirmBtnText: 'Oke',
                          title: 'Penting !!',
                          confirmBtnColor: Colors.green,
                        );
                      }
                    } else {
                      isStartedMap[item] = true;
                      _refreshData();
                    }
                  });
                } else {
                  QuickAlert.show(
                    barrierDismissible: false,
                    context: Get.context!,
                    type: QuickAlertType.error,
                    headerBackgroundColor: Colors.red,
                    text: 'Gagal memperbarui status. Silakan coba lagi.',
                    confirmBtnText: 'Oke',
                    title: 'Error !!',
                    confirmBtnColor: Colors.red,
                  );
                }
              } catch (e) {
                print('Exception caught: $e');
                if (e is! TypeError) {
                  QuickAlert.show(
                    barrierDismissible: false,
                    context: Get.context!,
                    type: QuickAlertType.error,
                    headerBackgroundColor: Colors.red,
                    text: 'Terjadi kesalahan: $e',
                    confirmBtnText: 'Oke',
                    title: 'Error !!',
                    confirmBtnColor: Colors.red,
                  );
                }
              }
            },
            child: Text(isStartedMap[item] == true ? 'Stop' : 'Start'),
            style: ElevatedButton.styleFrom(
              backgroundColor: isStartedMap[item] == true ? Colors.red : Colors.green,
            ),
          ),
          if (isStartedMap[item] == true) SizedBox(height: 10),
          if (isStartedMap[item] == true)
            TextField(
              controller: additionalInputControllers[item],
              decoration: InputDecoration(
                labelText: 'Masukkan keterangan tambahan',
                border: OutlineInputBorder(),
              ),
            ),
        ],
      ),
    );
  }

  void _refreshData() async {
    final Map args = Get.arguments;
    final updatedData = await API.MeknaikPKBID(kodesvc: args['kode_svc'] ?? '');
    setState(() {
      // Update state with the new data
      // Example: update the jasaList or other relevant state variables
    });
  }
  Widget _buildBottomSheet() {
    final Map args = Get.arguments;
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
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
          child: FutureBuilder<MekanikPKB>(
            future: API.MeknaikPKBID(kodesvc: args['kode_svc'] ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final jasaList = snapshot.data?.dataJasaMekanik?.jasa ?? [];
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // Ensures no scroll within a scroll
                      itemCount: jasaList.length,
                      itemBuilder: (context, index) {
                        final jasa = jasaList[index];
                        return RadioListTile<String>(
                          title: Text(jasa.namaJasa ?? ''),
                          controlAffinity: ListTileControlAffinity.trailing,
                          value: jasa.namaJasa!,
                          groupValue: selectedItemJasa,
                          onChanged: (String? value) {
                            setState(() {
                              selectedItemJasa = value;
                              showDetails = true;
                            });
                          },
                        );
                      },
                    ),
                    if (showDetails)
                      FutureBuilder<MekanikPKB>(
                        future: API.MeknaikPKBID(kodesvc: args['kode_svc'] ?? ''),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else {
                            final mechanics = snapshot.data?.dataJasaMekanik?.mekanik ?? [];
                            if (mechanics.isNotEmpty && selectedMechanic == null) {
                              selectedMechanic = mechanics.first;
                            }
                            return DropdownButton<String>(
                              value: selectedMechanic?.nama,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedMechanic = mechanics.firstWhere((mechanic) => mechanic.nama == newValue);
                                  textFieldController.text = newValue ?? '';
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
                        onPressed: () {
                          setState(() {
                            if (selectedMechanic != null) {
                              selectedItems.add(selectedMechanic!.nama ?? '');
                              isStartedMap[selectedMechanic!.nama ?? ''] = false;
                              additionalInputControllers[selectedMechanic!.nama ?? ''] = TextEditingController();
                            }
                          });
                        },
                        child: Text('Tambah'),
                      ),
                    if (showDetails) SizedBox(height: 20),
                    ...selectedItems.map((item) => buildTextFieldAndStartButton(item)).toList(),
                  ],
                );
              }
            },
          ),
        );
      },
    );
  }
}
