import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mekanik/app/modules/general_checkup/componen/Visibility_Accel.dart';
import 'package:mekanik/app/modules/general_checkup/componen/Visibility_Bawah_Kendaraan.dart';
import 'package:mekanik/app/modules/general_checkup/componen/Visibility_Brake.dart';
import 'package:mekanik/app/modules/general_checkup/componen/Visibility_Exterior.dart';
import 'package:mekanik/app/modules/general_checkup/componen/Visibility_Interior.dart';
import 'package:mekanik/app/modules/general_checkup/componen/Visibility_Stall_Test.dart';
import 'package:mekanik/app/modules/general_checkup/componen/Visibility_mesin.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/endpoint.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _nextTab() {
    if (_tabController.index < _tabController.length - 1) {
      _tabController.animateTo(_tabController.index + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
    final String bookingid = arguments?['booking_id'] ?? '';
    final String kodebooking = arguments?['kode_booking'] ?? '';
    final String subheadingid = arguments?['sub_heading_id'] ?? '';
    final String gcus = arguments?['gcus'] ?? '';
    final String gcuid = arguments?['gcu_id'] ?? '';
    Map<String, ValueNotifier<String>> dropdownValueNotifiers = {};
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          isScrollable: true,
          tabs: [
            Tab(text: 'Mesin'),
            Tab(text: 'Brake'),
            Tab(text: 'Accel'),
            Tab(text: 'Interior'),
            Tab(text: 'Exterior'),
            Tab(text: 'Bawah Kendaraan'),
            Tab(text: 'Stall Test'),
          ],
          controller: _tabController,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SingleChildScrollView(
            child:
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
                final getDataAcc = generalData?.data
                    ?.where((e) => e.subHeading == "Mesin")
                    .toList();
                if (getDataAcc != null && getDataAcc.isNotEmpty) {
                  return Column(
                    children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                      final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            child:
                            Row(
                              children: [
                                Expanded(
                                  child: Text(gcus.gcu ?? ''),
                                ),
                                ValueListenableBuilder<String>(
                                  valueListenable: dropdownValueNotifier,
                                  builder: (context, value, _) {
                                    return DropdownButton<String>(
                                      value: value,
                                      onChanged: (String? newValue) {
                                        dropdownValueNotifier.value = newValue!;
                                      },
                                      items: <String>['Oke', 'Not Oke']
                                          .map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                              ],
                            ),),
                          TextFieldVisibilitymesin(
                            valueNotifier: dropdownValueNotifier,
                          ),
                        ],
                      );
                    }).toList(),
                  );
                } else {
                  return const SizedBox(
                    height: 150,
                    child: Center(
                      child: Text('No data available'),
                    ),
                  );
                }
              } else {
                return const SizedBox(
                  height: 150,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
          ),
          SingleChildScrollView(
            child:
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
                  final getDataAcc = generalData?.data
                      ?.where((e) => e.subHeading == "Brake")
                      .toList();
                  if (getDataAcc != null && getDataAcc.isNotEmpty) {
                    return Column(
                      children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                        final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child:
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(gcus.gcu ?? ''),
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: dropdownValueNotifier,
                                    builder: (context, value, _) {
                                      return DropdownButton<String>(
                                        value: value,
                                        onChanged: (String? newValue) {
                                          dropdownValueNotifier.value = newValue!;
                                        },
                                        items: <String>['Oke', 'Not Oke']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),),
                            TextFieldVisibilitybrake(
                              valueNotifier: dropdownValueNotifier,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return const SizedBox(
                      height: 150,
                      child: Center(
                        child: Text('No data available'),
                      ),
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
          SingleChildScrollView(
            child:
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
                  final getDataAcc = generalData?.data
                      ?.where((e) => e.subHeading == "Accel")
                      .toList();
                  if (getDataAcc != null && getDataAcc.isNotEmpty) {
                    return Column(
                      children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                        final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child:
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(gcus.gcu ?? ''),
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: dropdownValueNotifier,
                                    builder: (context, value, _) {
                                      return DropdownButton<String>(
                                        value: value,
                                        onChanged: (String? newValue) {
                                          dropdownValueNotifier.value = newValue!;
                                        },
                                        items: <String>['Oke', 'Not Oke']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),),
                            TextFieldVisibilityAccel(
                              valueNotifier: dropdownValueNotifier,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return const SizedBox(
                      height: 150,
                      child: Center(
                        child: Text('No data available'),
                      ),
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
          SingleChildScrollView(
            child:
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
                  final getDataAcc = generalData?.data
                      ?.where((e) => e.subHeading == "Interior")
                      .toList();
                  if (getDataAcc != null && getDataAcc.isNotEmpty) {
                    return Column(
                      children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                        final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child:
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(gcus.gcu ?? ''),
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: dropdownValueNotifier,
                                    builder: (context, value, _) {
                                      return DropdownButton<String>(
                                        value: value,
                                        onChanged: (String? newValue) {
                                          dropdownValueNotifier.value = newValue!;
                                        },
                                        items: <String>['Oke', 'Not Oke']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),),
                            TextFieldVisibilityintrior(
                              valueNotifier: dropdownValueNotifier,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return const SizedBox(
                      height: 150,
                      child: Center(
                        child: Text('No data available'),
                      ),
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
          SingleChildScrollView(
            child:
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
                  final getDataAcc = generalData?.data
                      ?.where((e) => e.subHeading == "Exterior")
                      .toList();
                  if (getDataAcc != null && getDataAcc.isNotEmpty) {
                    return Column(
                      children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                        final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child:
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(gcus.gcu ?? ''),
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: dropdownValueNotifier,
                                    builder: (context, value, _) {
                                      return DropdownButton<String>(
                                        value: value,
                                        onChanged: (String? newValue) {
                                          dropdownValueNotifier.value = newValue!;
                                        },
                                        items: <String>['Oke', 'Not Oke']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),),
                            TextFieldVisibilityexterior(
                              valueNotifier: dropdownValueNotifier,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return const SizedBox(
                      height: 150,
                      child: Center(
                        child: Text('No data available'),
                      ),
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
          SingleChildScrollView(
            child:
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
                  final getDataAcc = generalData?.data
                      ?.where((e) => e.subHeading == "Bawah Kendaraan")
                      .toList();
                  if (getDataAcc != null && getDataAcc.isNotEmpty) {
                    return Column(
                      children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                        final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child:
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(gcus.gcu ?? ''),
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: dropdownValueNotifier,
                                    builder: (context, value, _) {
                                      return DropdownButton<String>(
                                        value: value,
                                        onChanged: (String? newValue) {
                                          dropdownValueNotifier.value = newValue!;
                                        },
                                        items: <String>['Oke', 'Not Oke']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),),
                            TextFieldVisibilitykendaraan(
                              valueNotifier: dropdownValueNotifier,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return const SizedBox(
                      height: 150,
                      child: Center(
                        child: Text('No data available'),
                      ),
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
          SingleChildScrollView(
            child:
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
                  final getDataAcc = generalData?.data
                      ?.where((e) => e.subHeading == "Stall Test")
                      .toList();
                  if (getDataAcc != null && getDataAcc.isNotEmpty) {
                    return Column(
                      children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                        final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child:
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(gcus.gcu ?? ''),
                                  ),
                                  ValueListenableBuilder<String>(
                                    valueListenable: dropdownValueNotifier,
                                    builder: (context, value, _) {
                                      return DropdownButton<String>(
                                        value: value,
                                        onChanged: (String? newValue) {
                                          dropdownValueNotifier.value = newValue!;
                                        },
                                        items: <String>['Oke', 'Not Oke']
                                            .map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),),
                            TextFieldVisibilitystell(
                              valueNotifier: dropdownValueNotifier,
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return const SizedBox(
                      height: 150,
                      child: Center(
                        child: Text('No data available'),
                      ),
                    );
                  }
                } else {
                  return const SizedBox(
                    height: 150,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (_tabController.index > 0) {
                  _tabController.animateTo(_tabController.index - 1);
                }
              },
            ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              elevation: 4.0,
            ),
        onPressed: () async {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.warning,
            headerBackgroundColor: Colors.yellow,
            text: 'Pastikan Kembali data Booking sudah sesuai ',
            confirmBtnText: 'Submit',
            cancelBtnText: 'Kembali',
            confirmBtnColor: Colors.green,
            onConfirmBtnTap: () async {
              Navigator.pop(Get.context!);
              try {
                if (kDebugMode) {
                  print('booking_id: $bookingid');
                }
                if (kDebugMode) {
                  print('kode_booking: $kodebooking');
                } if (kDebugMode) {
                  print('sub_heading_id: $subheadingid');
                }
                if (kDebugMode) {
                  print('gcus: $gcus');
                } if (kDebugMode) {
                  print('gcu_id: $gcuid');
                }
                // Tampilkan indikator loading
                QuickAlert.show(
                  barrierDismissible: false,
                  context: Get.context!,
                  type: QuickAlertType.loading,
                  headerBackgroundColor: Colors.yellow,
                  text: 'Submit General Chechup...',
                );
                // Panggil API untuk menyetujui booking
                await API.submitGCID(
                  bookingid: bookingid,
                  kodebooking: kodebooking,
                  subheadingid: subheadingid,
                  gcus: gcus,
                  gcuid : gcuid,
                );
              } catch (e) {
                Navigator.of(context).popUntil((route) => route.isFirst);
                QuickAlert.show(
                  barrierDismissible: false,
                  context: Get.context!,
                  type: QuickAlertType.success,
                  headerBackgroundColor: Colors.yellow,
                  text: 'Booking has been General Chechup',
                  confirmBtnText: 'Kembali',
                  cancelBtnText: 'Kembali',
                  confirmBtnColor: Colors.green,
                );
              }

            },
          );
        },
          child: const Text(
          'Submit',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
    ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _nextTab,
            ),
          ],
        ),
      ),
    );
  }
}

