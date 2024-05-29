import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../componen/color.dart';
import 'card_detailpkb.dart';
import '../controllers/promek_controller.dart';

class DetailPKB extends StatefulWidget {
  const DetailPKB({super.key});

  @override
  State<DetailPKB> createState() => _DetailPKBState();
}

class _DetailPKBState extends State<DetailPKB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // if (tipeSvc == 'Repair & Maintenance') {
                  //   QuickAlert.show(
                  //     context: context,
                  //     type: QuickAlertType.warning,
                  //     headerBackgroundColor: Colors.yellow,
                  //     text:
                  //     'Pastikan Kembali data Booking sudah sesuai, untuk Lanjut ke Estimasi ',
                  //     confirmBtnText: 'Konfirmasi',
                  //     cancelBtnText: 'Kembali',
                  //     confirmBtnColor: Colors.blue,
                  //     onConfirmBtnTap: () async {
                  //       Navigator.pop(Get.context!);
                  //       try {
                  //         // Tampilkan indikator loading
                  //         QuickAlert.show(
                  //           barrierDismissible: false,
                  //           context: Get.context!,
                  //           type: QuickAlertType.loading,
                  //           headerBackgroundColor: Colors.yellow,
                  //           text: 'Buat Estimasi......',
                  //         );
                  //         // Panggil API untuk menyetujui booking
                  //         await API.estimasiId(
                  //           idkaryawan: '',
                  //           kodeBooking: kodeBooking,
                  //           kodepelanggan: kodepelanggan,
                  //           kodekendaraan: kodekendaraan,
                  //           kategorikendaraan: kategorikendaraan,
                  //           tglBooking: controller.tanggal.text,
                  //           jamBooking: controller.jam.text,
                  //           odometer: controller.odometer.text,
                  //           pic: controller.pic.text,
                  //           hpPic: controller.hppic.text,
                  //           kodeMembership: kodeMembership,
                  //           kodePaketmember: kodePaketmember,
                  //           tipeSvc: tipeSvc,
                  //           tipePelanggan: tipePelanggan,
                  //           referensi: referensi,
                  //           referensiTmn: referensiTmn,
                  //           paketSvc: paketSvc,
                  //           keluhan: controller.keluhan.text,
                  //           perintahKerja: controller.perintah.text,
                  //           ppn: 10,
                  //         );
                  //       } catch (e) {
                  //         Navigator.pop(Get.context!);
                  //         Navigator.of(context)
                  //             .popUntil((route) => route.isFirst);
                  //         QuickAlert.show(
                  //           barrierDismissible: false,
                  //           context: Get.context!,
                  //           type: QuickAlertType.success,
                  //           headerBackgroundColor: Colors.yellow,
                  //           text: 'Estimasi Telah diBuat',
                  //           confirmBtnText: 'Kembali',
                  //           cancelBtnText: 'Kembali',
                  //           confirmBtnColor: Colors.green,
                  //         );
                  //       }
                  //     },
                  //   );
                  // } else {}
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Mekanik',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Detail PKB',
          style: TextStyle(
              color: MyColors.appPrimaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
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
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              CardDetailPKB(),
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
