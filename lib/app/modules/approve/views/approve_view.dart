import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/data_endpoint/mekanik.dart';
import '../../../data/endpoint.dart';
import '../componen/card_consument.dart';
import '../controllers/approve_controller.dart';

class ApproveView extends GetView<ApproveController> {
  const ApproveView({super.key});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
    final String email = arguments?['email'] ?? '';
    final String kodeBooking = arguments?['kode_booking'] ?? '';
    final String tglBooking = arguments?['tgl_booking'] ?? '';
    final String jamBooking = arguments?['jam_booking'] ?? '';
    final String odometer = arguments?['odometer'] ?? '';
    final String pic = arguments?['pic'] ?? '';
    final String hpPic = arguments?['hp_pic'] ?? '';
    final String kodeMembership = arguments?['kode_membership'] ?? '';
    final String kodePaketmember = arguments?['kode_paketmember'] ?? '';
    final String tipeSvc = arguments?['nama_jenissvc'] ?? '';
    final String tipePelanggan = arguments?['tipe_pelanggan'] ?? '';
    final String referensi = arguments?['referensi'] ?? '';
    final String referensiTmn = arguments?['referensi_teman'] ?? '';
    final String paketSvc = arguments?['paket_svc'] ?? '';
    final String keluhan = arguments?['keluhan'] ?? '';
    final String catatan = arguments?['catatan'] ?? '';
    final String perintahKerja = arguments?['perintah_kerja'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve'),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const CardConsument(),
              const SizedBox(width: 10,),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (kDebugMode) {
                            print('Email: $email');
                          }
                          if (kDebugMode) {
                            print('kode_booking: $kodeBooking');
                          }
                          if (kDebugMode) {
                            print('tgl_booking: $tglBooking');
                          }
                          if (kDebugMode) {
                            print('nama_jenissvc: $tipeSvc');
                          }
                          if (tipeSvc == 'Repair & Maintenance') {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              headerBackgroundColor: Colors.yellow,
                              text: 'Pastikan Kembali data Booking sudah sesuai ',
                              confirmBtnText: 'Approve',
                              cancelBtnText: 'Kembali',
                              confirmBtnColor: Colors.green,
                              onConfirmBtnTap: () async {
                                Navigator.pop(Get.context!);
                                try {
                                  if (kDebugMode) {
                                    print('Email: $email');
                                  }
                                  if (kDebugMode) {
                                    print('kode_booking: $kodeBooking');
                                  }
                                  if (kDebugMode) {
                                    print('tgl_booking: $tglBooking');
                                  }

                                  // Tampilkan indikator loading
                                  QuickAlert.show(
                                    barrierDismissible: false,
                                    context: Get.context!,
                                    type: QuickAlertType.loading,
                                    headerBackgroundColor: Colors.yellow,
                                    text: 'Approving...',
                                  );
                                  // Panggil API untuk menyetujui booking
                                  await API.approveId(
                                    email: email,
                                    kodeBooking: kodeBooking,
                                    tglBooking: tglBooking,
                                    jamBooking: jamBooking,
                                    odometer: controller.odometer.text,
                                    pic: pic,
                                    hpPic: hpPic,
                                    kodeMembership: kodeMembership,
                                    kodePaketmember: kodePaketmember,
                                    tipeSvc: tipeSvc,
                                    referensi: referensi,
                                    referensiTmn: referensiTmn,
                                    paketSvc: paketSvc,
                                    keluhan: keluhan,
                                    perintahKerja: perintahKerja,
                                    ppn: 10,
                                    tipePelanggan: tipePelanggan,
                                  );
                                } catch (e) {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                  QuickAlert.show(
                                    barrierDismissible: false,
                                    context: Get.context!,
                                    type: QuickAlertType.success,
                                    headerBackgroundColor: Colors.yellow,
                                    text: 'Booking has been approved',
                                    confirmBtnText: 'Kembali',
                                    cancelBtnText: 'Kembali',
                                    confirmBtnColor: Colors.green,
                                  );
                                }

                              },
                            );
                          } else if (tipeSvc == 'General Check UP/P2H') {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              barrierDismissible: true,
                              confirmBtnText: 'Konfirmasi',
                              text: 'Pilih terlebih dahulu Mekanik yang ingin melakukan General Checkup',
                              widget: FutureBuilder<Mekanik>(
                                future: API.MekanikID(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final List<DataMekanik>? _list = snapshot.data!.dataMekanik;
                                    final List<String> namaMekanikList = _list!
                                        .map((mekanik) => mekanik.nama!)
                                        .where((nama) => nama != null)
                                        .toList();
                                    return Column(
                                      children: [
                                        CustomDropdown<String>.search(
                                          hintText: 'Pilih mekanik',
                                          items: namaMekanikList,
                                          excludeSelected: false,
                                          onChanged: (value) {
                                            controller.mekanik.text = value ?? ''; // Set nilai controller saat nilai dropdown berubah
                                            log('Mengubah nilai menjadi: $value');
                                          },
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                              onConfirmBtnTap: () async {
                                Navigator.pop(Get.context!);
                                try {
                                  if (kDebugMode) {
                                    print('Email: $email');
                                  }
                                  if (kDebugMode) {
                                    print('kode_booking: $kodeBooking');
                                  }
                                  if (kDebugMode) {
                                    print('tgl_booking: $tglBooking');
                                  }

                                  // Tampilkan indikator loading
                                  QuickAlert.show(
                                    barrierDismissible: false,
                                    context: Get.context!,
                                    type: QuickAlertType.loading,
                                    headerBackgroundColor: Colors.yellow,
                                    text: 'Approving...',
                                  );
                                  // Panggil API untuk menyetujui booking
                                  await API.approveId(
                                    email: controller.mekanik.text,
                                    kodeBooking: kodeBooking,
                                    tglBooking: tglBooking,
                                    jamBooking: jamBooking,
                                    odometer: odometer,
                                    pic: pic,
                                    hpPic: hpPic,
                                    kodeMembership: kodeMembership,
                                    kodePaketmember: kodePaketmember,
                                    tipeSvc: tipeSvc,
                                    referensi: referensi,
                                    referensiTmn: referensiTmn,
                                    paketSvc: paketSvc,
                                    keluhan: keluhan,
                                    perintahKerja: perintahKerja,
                                    ppn: 10,
                                    tipePelanggan: tipePelanggan,
                                  );
                                } catch (e) {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                  QuickAlert.show(
                                    barrierDismissible: false,
                                    context: Get.context!,
                                    type: QuickAlertType.success,
                                    headerBackgroundColor: Colors.yellow,
                                    text: 'Booking has been approved',
                                    confirmBtnText: 'Kembali',
                                    cancelBtnText: 'Kembali',
                                    confirmBtnColor: Colors.green,
                                  );
                                }

                              },
                            );
                          } else {
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          elevation: 4.0,
                        ),
                        child: const Text(
                          'Approve',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                    ),
                  ),
                  const SizedBox(width: 10,),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          var message = '';
                          QuickAlert.show(
                              context: context,
                              type: QuickAlertType.warning,
                              barrierDismissible: true,
                              confirmBtnText: 'Konfirmasi',
                              widget: TextFormField(
                                controller: controller.catatan,
                                decoration: const InputDecoration(
                                  alignLabelWithHint: true,
                                  hintText: 'catatan',
                                  prefixIcon: Icon(
                                    Icons.mail_lock_rounded,
                                  ),
                                ),
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                onChanged: (value) => message = value,
                              ),
                              onConfirmBtnTap: () async {
                                Navigator.pop(Get.context!);
                                try {
                                  if (kDebugMode) {
                                    print('kode_booking: $kodeBooking');
                                  }
                                  QuickAlert.show(
                                    context: Get.context!,
                                    type: QuickAlertType.loading,
                                    headerBackgroundColor: Colors.yellow,
                                    text: 'Unapproving...',
                                    confirmBtnText: '',
                                  );
                                  await API.unapproveId(
                                    catatan: controller.catatan.text,
                                    kodeBooking: kodeBooking,
                                  );
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                  QuickAlert.show(
                                    barrierDismissible: false,
                                    context: Get.context!,
                                    type: QuickAlertType.success,
                                    headerBackgroundColor: Colors.yellow,
                                    text: 'Booking has been Unapproving',
                                    confirmBtnText: 'Kembali',
                                    cancelBtnText: 'Kembali',
                                    confirmBtnColor: Colors.green,
                                  );
                                } catch (e) {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                  QuickAlert.show(
                                    barrierDismissible: false,
                                    context: Get.context!,
                                    type: QuickAlertType.success,
                                    headerBackgroundColor: Colors.yellow,
                                    text: 'Booking has been Unapproving',
                                    confirmBtnText: 'Kembali',
                                    cancelBtnText: 'Kembali',
                                    confirmBtnColor: Colors.green,
                                  );
                                }
                              }
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          elevation: 4.0,
                        ),
                        child: const Text(
                          'Unapprove',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10,),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

