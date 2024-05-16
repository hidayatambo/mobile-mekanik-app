import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mekanik/app/componen/color.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/endpoint.dart';
import '../../repair_maintenen/componen/card_consument.dart';
import '../componen/card_consument.dart';
import '../controllers/approve_controller.dart';

class ApproveView extends GetView<ApproveController> {
  ApproveView({super.key});
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
    Get.arguments as Map<String, dynamic>?;
    final String kodeBooking = arguments?['kode_booking'] ?? '';
    final String tglBooking = arguments?['tgl_booking'] ?? '';
    final String jamBooking = arguments?['jam_booking'] ?? '';
    final String kodeMembership = arguments?['kode_membership'] ?? '';
    final String kodePaketmember = arguments?['kode_paketmember'] ?? '';
    final String tipeSvc = arguments?['nama_jenissvc'] ?? '';
    final String tipePelanggan = arguments?['tipe_pelanggan'] ?? '';
    final String referensi = arguments?['referensi'] ?? '';
    final String referensiTmn = arguments?['referensi_teman'] ?? '';
    final String paketSvc = arguments?['paket_svc'] ?? '';
    final String kategorikendaraan = arguments?['kategori_kendaraan'] ?? '';
    final String kodepelanggan = arguments?['kode_pelanggan'] ?? '';
    final String kodekendaraan = arguments?['kode_kendaraan'] ?? '';

    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        height: 125,
        color: MyColors.appPrimaryColor,
        shape: const CircularNotchedRectangle(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Penting !!',
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              'Periksa lagi data Pelanggan sebelum Approve',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      barrierDismissible: true,
                      text: 'Periksa kembali data Pelanganss',
                      confirmBtnText: 'Konfirmasi',
                      onConfirmBtnTap: () async {
                        if (tipeSvc == 'Repair & Maintenance') {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            headerBackgroundColor: Colors.yellow,
                            text: 'Pastikan kembali data Booking sudah sesuai, untuk lanjut ke Estimasi',
                            confirmBtnText: 'Konfirmasi',
                            cancelBtnText: 'Kembali',
                            confirmBtnColor: Colors.blue,
                            onConfirmBtnTap: () async {
                              Navigator.pop(Get.context!);
                              // Tampilkan indikator loading
                              QuickAlert.show(
                                barrierDismissible: false,
                                context: Get.context!,
                                type: QuickAlertType.loading,
                                headerBackgroundColor: Colors.yellow,
                                text: 'Buat Estimasi......',
                              );
                              try {
                                await API.approveId(
                                  idkaryawan: '',
                                  kodeBooking: kodeBooking,
                                  kodepelanggan: kodepelanggan,
                                  kodekendaraan: kodekendaraan,
                                  kategorikendaraan: kategorikendaraan,
                                  tglBooking: controller.tanggal.text,
                                  jamBooking: controller.jam.text,
                                  odometer: controller.odometer.text,
                                  pic: controller.pic.text,
                                  hpPic: controller.hppic.text,
                                  kodeMembership: kodeMembership,
                                  kodePaketmember: kodePaketmember,
                                  tipeSvc: tipeSvc,
                                  tipePelanggan: tipePelanggan,
                                  referensi: referensi,
                                  referensiTmn: referensiTmn,
                                  paketSvc: paketSvc,
                                  keluhan: controller.keluhan.text,
                                  perintahKerja: controller.perintah.text,
                                  ppn: 10,
                                );
                                // Handle successful API call
                                Navigator.pop(Get.context!);  // Hide loading indicator
                                QuickAlert.show(
                                  context: Get.context!,
                                  type: QuickAlertType.success,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Estimasi telah dibuat',
                                  confirmBtnText: 'Kembali',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () => Navigator.pop(Get.context!),
                                );
                                Navigator.pop(Get.context!);
                              } catch (e) {
                                QuickAlert.show(
                                  context: Get.context!,
                                  type: QuickAlertType.error,
                                  headerBackgroundColor: Colors.red,
                                  text: 'Gagal membuat estimasi: $e',
                                  confirmBtnText: 'Ok',
                                  confirmBtnColor: Colors.red,
                                );
                              }
                            },
                          );
                        } else if (tipeSvc == 'General Check UP/P2H') {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            headerBackgroundColor: Colors.yellow,
                            text: 'Pastikan kembali data Booking sudah sesuai, untuk lanjut ke General Checkup',
                            confirmBtnText: 'Konfirmasi',
                            cancelBtnText: 'Kembali',
                            confirmBtnColor: Colors.blue,
                            onConfirmBtnTap: () async {
                              Navigator.pop(Get.context!);
                              // Tampilkan indikator loading
                              QuickAlert.show(
                                barrierDismissible: false,
                                context: Get.context!,
                                type: QuickAlertType.loading,
                                headerBackgroundColor: Colors.yellow,
                                text: 'Mempersiapkan General Checkup......',
                              );
                              try {
                                await API.approveId(
                                  idkaryawan: '',
                                  kodeBooking: kodeBooking,
                                  kodepelanggan: kodepelanggan,
                                  kodekendaraan: kodekendaraan,
                                  kategorikendaraan: kategorikendaraan,
                                  tglBooking: controller.tanggal.text,
                                  jamBooking: controller.jam.text,
                                  odometer: controller.odometer.text,
                                  pic: controller.pic.text,
                                  hpPic: controller.hppic.text,
                                  kodeMembership: kodeMembership,
                                  kodePaketmember: kodePaketmember,
                                  tipeSvc: tipeSvc,
                                  tipePelanggan: tipePelanggan,
                                  referensi: referensi,
                                  referensiTmn: referensiTmn,
                                  paketSvc: paketSvc,
                                  keluhan: controller.keluhan.text,
                                  perintahKerja: controller.perintah.text,
                                  ppn: 10,
                                );
                                // Handle successful API call
                                Navigator.pop(Get.context!);  // Hide loading indicator
                                QuickAlert.show(
                                  context: Get.context!,
                                  type: QuickAlertType.success,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Persiapan General Checkup selesai',
                                  confirmBtnText: 'Kembali',
                                  confirmBtnColor: Colors.green,
                                  onConfirmBtnTap: () => Navigator.pop(Get.context!),
                                );
                              } catch (e) {
                                Navigator.pop(Get.context!);  // Hide loading indicator
                                QuickAlert.show(
                                  context: Get.context!,
                                  type: QuickAlertType.error,
                                  headerBackgroundColor: Colors.red,
                                  text: 'Gagal mempersiapkan General Checkup: $e',
                                  confirmBtnText: 'Ok',
                                  confirmBtnColor: Colors.red,
                                );
                              }
                            },
                          );
                        } else {
                          // Handle other service types or show a default message if needed
                        }

                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
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
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
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
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    enableFeedback: true,
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
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
            ),
          ],
        ),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Approve',
          style: TextStyle(
              color: MyColors.appPrimaryColor, fontWeight: FontWeight.bold),
        ),
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
              SizedBox(
                width: 10,
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
