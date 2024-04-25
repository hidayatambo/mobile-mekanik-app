import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mekanik/app/componen/color.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:search_choices/search_choices.dart';
import '../../../data/data_endpoint/approve.dart';
import '../../../data/data_endpoint/mekanik.dart';
import '../../../data/endpoint.dart';
import '../componen/card_consument.dart';
import '../controllers/approve_controller.dart';

class ApproveView extends GetView<GetxController> {
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
    final String tipeSvc = arguments?['tipe_svc'] ?? '';
    final String tipePelanggan = arguments?['tipe_pelanggan'] ?? '';
    final String referensi = arguments?['referensi'] ?? '';
    final String referensiTmn = arguments?['referensi_teman'] ?? '';
    final String paketSvc = arguments?['paket_svc'] ?? '';
    final String keluhan = arguments?['keluhan'] ?? '';
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
                        onPressed: () {
                          QuickAlert.show(
                            context: Get.context!,
                            type: QuickAlertType.warning,
                            headerBackgroundColor: Colors.yellow,
                            text: 'Pastikan Kembali data Booking sudah sesuai ',
                            confirmBtnText: 'Approve',
                            cancelBtnText: 'Kembali',
                            confirmBtnColor: Colors.green,
                            onConfirmBtnTap: () async {
                              try {
                                print('Email: $email');
                                print('kode_booking: $kodeBooking');
                                print('tgl_booking: $tglBooking');

                                await API.approveId(
                                  email: email,
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

                                Navigator.pop(Get.context!);

                                QuickAlert.show(
                                  context: Get.context!,
                                  type: QuickAlertType.success,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Booking has been approved',
                                  confirmBtnText: 'Kembali',
                                  cancelBtnText: 'Kembali',
                                  confirmBtnColor: Colors.red,
                                );
                              } catch (e) {
                                Navigator.pop(Get.context!);
                                QuickAlert.show(
                                  context: Get.context!,
                                  type: QuickAlertType.success,
                                  headerBackgroundColor: Colors.yellow,
                                  text: 'Booking has been approved',
                                  confirmBtnText: 'Kembali',
                                  cancelBtnText: 'Kembali',
                                  confirmBtnColor: Colors.red,
                                );
                              }
                            },
                          );
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
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
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  elevation: 4.0,
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
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
