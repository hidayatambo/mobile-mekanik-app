import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../data/endpoint.dart';
import '../componen/card_consument.dart';
import '../controllers/repair_maintenen_controller.dart';

class RepairMaintenenView extends GetView<RepairMaintenenController> {
  const RepairMaintenenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
    final String kodeBooking = arguments?['kode_booking'] ?? '';
    final String kodepelanggan = arguments?['kode_pelanggan'] ?? '';
    final String kodekendaraan = arguments?['kode_kendaraan'] ?? '';
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
        title: const Text('Repair Maintenence'),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(10), child:
        Column(
          children: [
            Cardmaintenent(),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: ElevatedButton(
                      onPressed: () {
                        if (kDebugMode) {
                          print('kode_booking: $kodeBooking');
                        }
                        if (kDebugMode) {
                          print('kode_pelanggan: $kodekendaraan');
                        }
                        if (kDebugMode) {
                          print('kode_kendaraan: $tipeSvc');
                        }
                        if (tipeSvc == 'Repair & Maintenance') {
                          QuickAlert.show(
                            context: context,
                            type: QuickAlertType.warning,
                            headerBackgroundColor: Colors.yellow,
                            text: 'Pastikan Kembali data Booking sudah sesuai, untuk Lanjut ke Estimasi ',
                            confirmBtnText: 'Konfirmasi',
                            cancelBtnText: 'Kembali',
                            confirmBtnColor: Colors.blue,
                            onConfirmBtnTap: () async {
                              Navigator.pop(Get.context!);
                              try {
                                if (kDebugMode) {
                                  print('kode_booking: $kodeBooking');
                                }
                                if (kDebugMode) {
                                  print('kode_pelanggan: $kodepelanggan');
                                }
                                if (kDebugMode) {
                                  print('kode_kendaraan: $kodekendaraan');
                                }
                                // Tampilkan indikator loading
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: Get.context!,
                                  type: QuickAlertType.loading,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Buat Estimasi......',
                                );
                                // Panggil API untuk menyetujui booking
                                await API.estimasiId(
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
                                  kodePelanggan: kodepelanggan,
                                  kodeKendaraan: kodekendaraan,
                                );
                              } catch (e) {
                                Navigator.pop(Get.context!);
                                Navigator.of(context).popUntil((route) => route.isFirst);
                                QuickAlert.show(
                                  barrierDismissible: false,
                                  context: Get.context!,
                                  type: QuickAlertType.success,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Estimasi Telah diBuat',
                                  confirmBtnText: 'Kembali',
                                  cancelBtnText: 'Kembali',
                                  confirmBtnColor: Colors.green,
                                );
                              }
                            },
                          );
                        }  else {
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Buat Estimasi',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5,),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Buat PKB',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5,),
              ],
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Cetak P2H',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}