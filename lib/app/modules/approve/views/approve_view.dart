import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mekanik/app/componen/color.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/data_endpoint/mekanik.dart';
import '../../../data/endpoint.dart';
import '../componen/card_consument.dart';
import '../controllers/approve_controller.dart';

class ApproveView extends GetView<ApproveController> {
  ApproveView({super.key});
  String? selectedMechanic = '';
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
    final String perintahKerja = arguments?['perintah_kerja'] ?? '';

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 125,
        color: MyColors.appPrimaryColor,
        shape: const CircularNotchedRectangle(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Penting !!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
            Text('Periksa lagi data Pelanggan sebelum Approve', style: TextStyle(color: Colors.white),),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ElevatedButton(

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
                    barrierDismissible: true,
                    text: 'Periksa kembali data Pelanganss',
                    confirmBtnText: 'Konfirmasi',
                    widget: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                      Text('Keluhan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      TextFormField(
                        controller: controller.keluhan,
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'catatan',
                          prefixIcon: Icon(
                            Icons.note_alt_rounded,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        // onChanged: (value) => message = value,
                      ),
                      SizedBox(height: 10,),
                      Text('Perintah Kerja',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
                      TextFormField(
                        controller: controller.perintah,
                        decoration: const InputDecoration(
                          alignLabelWithHint: true,
                          hintText: 'catatan',
                          prefixIcon: Icon(
                            Icons.note_alt_rounded,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        // onChanged: (value) => message = value,
                      ),
                    ],),

                    onConfirmBtnTap: () async {
                      Navigator.pop(Get.context!);
                      try {
                        if (kDebugMode) {
                          print('jam_booking: $email');
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
                        if (kDebugMode) {
                          print('jam_booking: $jamBooking');
                        }
                        if (kDebugMode) {
                          print('kode_booking: $kodeBooking');
                        }
                        if (kDebugMode) {
                          print('tgl_booking: $tglBooking');
                        }
                        await API.approveId(
                          email: email,
                          kodeBooking: kodeBooking,
                          tglBooking: controller.tanggal.text,
                          jamBooking: controller.jam.text,
                          odometer: controller.odometer.text,
                          pic: controller.pic.text,
                          hpPic: controller.hppic.text,
                          kodeMembership: kodeMembership,
                          kodePaketmember: kodePaketmember,
                          tipeSvc: tipeSvc,
                          referensi: referensi,
                          referensiTmn: referensiTmn,
                          paketSvc: paketSvc,
                          keluhan: controller.keluhan.text,
                          perintahKerja: controller.perintah.text,
                          ppn: 10,
                          tipePelanggan: tipePelanggan,
                        );
                      } catch (e) {
                        Navigator.pop(Get.context!);
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
                          email: selectedMechanic ?? '',
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
            ElevatedButton(
              onPressed: () {
                var message = '';
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    barrierDismissible: true,
                    text: 'catatan kenapa anda Unapprove',
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
                enableFeedback: true,
                foregroundColor:  Colors.red,
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
          ],
        ),],),
      ),
      appBar: AppBar(
        title: const Text('Approve'),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: MyColors.appPrimaryColor,
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              CardConsuments2(),
              SizedBox(width: 10,),
              SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}

