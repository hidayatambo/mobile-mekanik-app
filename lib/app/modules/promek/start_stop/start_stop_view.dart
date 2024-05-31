import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/data_endpoint/mekanik_pkb.dart';
import '../../../data/data_endpoint/prosesspromaxpkb.dart';
import '../../../data/endpoint.dart';
import '../controllers/promek_controller.dart';

class StartStopView extends StatefulWidget {
  const StartStopView({Key? key});

  @override
  State<StartStopView> createState() => _StartStopViewState();
}

class _StartStopViewState extends State<StartStopView> with AutomaticKeepAliveClientMixin<StartStopView> {
  String? selectedItemJasa;
  String? selectedItemKodeJasa;
  Mekanikpkb? selectedMechanic;
  bool showDetails = false;
  TextEditingController textFieldController = TextEditingController();
  Map<String, String> selectedItems = {};
  Map<String, bool> isStartedMap = {};
  Map<String, TextEditingController> additionalInputControllers = {};
  final PromekController controller = Get.put(PromekController());
  Map<String, List<Proses>> historyData = {};

  @override
  void initState() {
    super.initState();
    final Map args = Get.arguments;
    controller.setInitialValues(args);
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> fetchPromekData(String kodesvc, String kodejasa, String idmekanik) async {
    try {
      var response = await API.PromekProsesPKBID(
        kodesvc: kodesvc,
        kodejasa: kodejasa,
        idmekanik: idmekanik,
      );
      if (response.status == 200) {
        setState(() {
          historyData[idmekanik] = response.dataProsesMekanik?.proses ?? [];
        });
      }
    } catch (e) {
      print('Error fetching promek data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Map args = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
        ),
        title: const Text(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
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
                    if (jasaList.isEmpty) {
                      return const Center(child: Text('Jasa belum diinput di module PKB Service pada web, mohon input jasa dahulu'));
                    }
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pilih Jasa', style: TextStyle(fontWeight: FontWeight.bold)),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: jasaList.length,
                          itemBuilder: (context, index) {
                            final jasa = jasaList[index];
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedItemJasa = jasa.namaJasa;
                                  selectedItemKodeJasa = jasa.kodeJasa;
                                  showDetails = true;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      spreadRadius: 5,
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  color: selectedItemKodeJasa == jasa.kodeJasa ? Colors.blue : Colors.white,
                                  border: Border.all(
                                    color: selectedItemKodeJasa == jasa.kodeJasa ? Colors.blue : Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  jasa.namaJasa ?? '',
                                  style: TextStyle(
                                    color: selectedItemKodeJasa == jasa.kodeJasa ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        if (showDetails)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              const Text('Pilih Mekanik', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              Container(
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
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: DropdownButtonHideUnderline(
                                  child: ButtonTheme(
                                    alignedDropdown: true,
                                    child: DropdownButton<String>(
                                      value: selectedMechanic?.id.toString(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedMechanic = mechanics.firstWhere((mechanic) => mechanic.id.toString() == newValue);
                                          textFieldController.text = newValue ?? '';
                                        });
                                      },
                                      items: mechanics.map<DropdownMenuItem<String>>((mechanic) {
                                        return DropdownMenuItem<String>(
                                          value: mechanic.id.toString(),
                                          child: Text(mechanic.nama ?? ''),
                                        );
                                      }).toList(),
                                      isExpanded: true,
                                      hint: selectedMechanic == null
                                          ? const Text("Mekanik belum dipilih", style: TextStyle(color: Colors.grey))
                                          : null,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () async {
                                  String kodejasa = selectedItemKodeJasa ?? '';
                                  String kodesvc = args['kode_svc'] ?? '';
                                  await fetchPromekData(kodesvc, kodejasa, selectedMechanic!.id.toString());
                                  setState(() {
                                    if (selectedMechanic != null) {
                                      final mechanicId = selectedMechanic!.id.toString();
                                      final mechanicName = selectedMechanic!.nama!;
                                      selectedItems[mechanicId] = mechanicName;
                                      isStartedMap[mechanicName] = false;
                                      additionalInputControllers[mechanicName] = TextEditingController();
                                      mechanics.removeWhere((mechanic) => mechanic.id.toString() == mechanicId);
                                      selectedMechanic = null;
                                    }
                                  });
                                },
                                child: const Text('Tambah', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                              ...selectedItems.keys.map((item) => buildTextFieldAndStartButton(item)).toList(),
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
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10,),
          const Text('Mekanik yang di tambahkan',style: TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.all(10),
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
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(selectedItems[item] ?? '', style: const TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(height: 10),
                if (isStartedMap[item] == true)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                    child:
                    TextField(
                      controller: additionalInputControllers[item],
                      decoration: const InputDecoration(
                        labelText: 'Isi keterangan tambahan',
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        additionalInputControllers[item]?.text = value;
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                const Text('History :', style: TextStyle(fontWeight: FontWeight.bold),),
                if (historyData.containsKey(item))
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: historyData[item]!.map((proses) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start Promek: ${proses.startPromek ?? 'N/A'}'),
                          Text('Stop Promek: ${proses.stopPromek ?? 'N/A'}'),
                        ],
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 10,),
                ElevatedButton(
                  onPressed: () async {
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

                    bool isStarted = isStartedMap[item] ?? false;
                    if (isStarted && additionalInputControllers[item]?.text.isEmpty == true) {
                      QuickAlert.show(
                        context: Get.context!,
                        type: QuickAlertType.warning,
                        title: 'Penting !!',
                        text: 'Isi keterangan terlebih dahulu sebelum menghentikan',
                        confirmBtnText: 'Oke',
                        confirmBtnColor: Colors.green,
                      );
                      return;
                    }

                    String role = isStarted ? 'stop' : 'start';
                    String kodejasa = selectedItemKodeJasa ?? '';
                    String idmekanik = item;
                    String kodesvc = args['kode_svc'] ?? '';

                    try {
                      var response = await API.InsertPromexoPKBID(
                        role: role,
                        kodejasa: kodejasa,
                        idmekanik: idmekanik,
                        kodesvc: kodesvc,
                      );
                      if (response.status == 200) {
                        setState(() {
                          isStartedMap[item] = !isStarted;
                        });

                        if (isStarted) {
                          await API.updateketeranganID(
                            promekid: 'promekId.toString()',
                            keteranganpromek: additionalInputControllers[item]?.text ?? '',
                          );
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
                    foregroundColor: Colors.white,
                    backgroundColor: isStartedMap[item] == true ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),]
    );
  }
}
