import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/data_endpoint/mekanik.dart';
import '../../../data/data_endpoint/mekanik_pkb.dart';
import '../../../data/endpoint.dart';
import '../controllers/promek_controller.dart';

class StartStopView extends StatefulWidget {
  const StartStopView({Key? key});

  @override
  State<StartStopView> createState() => _StartStopViewState();
}

class _StartStopViewState extends State<StartStopView> {
  String? selectedItemJasa;
  Mekanikpkb? selectedMechanic;
  bool showDetails = false;
  TextEditingController textFieldController = TextEditingController();
  Map<String, String> selectedItems = {}; // Update selectedItems menjadi Map<String, String>
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
                    final mechanics = snapshot.data?.dataJasaMekanik?.mekanik ?? [];
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
                          Column(
                            children: [
                              DropdownButton<String>(
                                value: selectedMechanic?.id.toString(), // Using id instead of nama
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedMechanic = mechanics.firstWhere((mechanic) => mechanic.id.toString() == newValue);
                                    textFieldController.text = newValue ?? '';
                                  });
                                },
                                items: mechanics.map<DropdownMenuItem<String>>((mechanic) {
                                  return DropdownMenuItem<String>(
                                    value: mechanic.id.toString(), // Using id instead of nama
                                    child: Text(mechanic.nama ?? ''),
                                  );
                                }).toList(),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (selectedMechanic != null) {
                                      final mechanicId = selectedMechanic!.id.toString(); // Ambil ID mekanik
                                      final mechanicName = selectedMechanic!.nama!;
                                      selectedItems[mechanicId] = mechanicName; // Simpan ID mekanik dan nama mekanik
                                      isStartedMap[mechanicName] = false;
                                      additionalInputControllers[mechanicName] = TextEditingController();
                                      // Remove the selected mechanic from the dropdown
                                      mechanics.removeWhere((mechanic) => mechanic.id.toString() == mechanicId);
                                      // Reset the selected mechanic
                                      selectedMechanic = null;
                                    }
                                  });
                                },
                                child: Text('Tambah'),
                              ),
                              SizedBox(height: 20),
                              if (showDetails) SizedBox(height: 20),
                              ...selectedItems.keys.map((item) => buildTextFieldAndStartButton(item)).toList(), // Gunakan keys dari selectedItems
                            ],
                          ),
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
          Text(selectedItems[item] ?? ''), // Gunakan nilai dari selectedItems
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              // Check if there's a mechanic selected for the current item
              if (!selectedItems.containsKey(item)) {
                QuickAlert.show(
                  context: Get.context!,
                  type: QuickAlertType.warning,
                  title: 'Penting !!',
                  text: 'Pilih mekanik terlebih dahulu',
                  confirmBtnText: 'Oke',
                  confirmBtnColor: Colors.green,
                );
                return;
              }

              // Debug log untuk memeriksa nilai di TextField
              print('TextField value: ${additionalInputControllers[item]?.text}');
              if (isStartedMap[item] == true && (additionalInputControllers[item]?.text?.isEmpty ?? true)) {
                QuickAlert.show(
                  context: Get.context!,
                  type: QuickAlertType.warning,
                  title: 'Penting !!',
                  text: 'Harap isi keterangan tambahan terlebih dahulu',
                  confirmBtnText: 'Oke',
                  confirmBtnColor: Colors.green,
                );
                return;
              }

              // Rest of your onPressed logic remains the same
              bool isStarted = isStartedMap[item] ?? false;
              String role = isStarted ? 'stop' : 'start';
              String kodejasa = selectedItemJasa ?? '';
              String idmekanik = item; // Use the item directly as ID mekanik
              String kodesvc = args['kode_svc'] ?? '';

              try {
                // Send the request to start or stop the mechanic
                var response = await API.InsertPromexoPKBID(
                  role: role,
                  kodejasa: kodejasa,
                  idmekanik: idmekanik,
                  kodesvc: kodesvc,
                );
                if (response.status == 200) {
                  // Toggle the mechanic's status
                  setState(() {
                    isStartedMap[item] = !isStarted;
                  });

                  // If stopping, update the additional information
                  if (!isStarted) {
                    var updateResponse = await API.updateketeranganID(
                      promekid: 'promekId.toString()',
                      keteranganpromek: additionalInputControllers[item]?.text ?? '',
                    );
                    // Handle the response from the update API call as needed
                  }
                } else {
                  QuickAlert.show(
                    context: Get.context!,
                    type: QuickAlertType.error,
                    title: 'Error !!',
                    text: 'Gagal memperbarui status. Silakan coba lagi.',
                    confirmBtnText: 'Oke',
                    confirmBtnColor: Colors.red,
                  );
                }
              } catch (e) {
                QuickAlert.show(
                  context: Get.context!,
                  type: QuickAlertType.error,
                  title: 'Error !!',
                  text: 'Terjadi kesalahan: $e',
                  confirmBtnText: 'Oke',
                  confirmBtnColor: Colors.red,
                );
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
}
