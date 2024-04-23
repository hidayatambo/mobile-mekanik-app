import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../data/data_endpoint/boking.dart';
import '../../../data/endpoint.dart';
import '../../../routes/app_pages.dart';
import '../../general_checkup/componen/card_info.dart';

class ApproveView extends StatelessWidget {
  const ApproveView({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: Padding(padding: const EdgeInsets.all(10),child:
          Column(
            children: [
            const cardInfo(),
            const SizedBox(width: 10,),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<Boking>(
                  future: API.bokingid(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<DataBooking>? bookings = snapshot.data?.dataBooking;
                      print('Data dari API: $bookings');

                      if (bookings == null || bookings.isEmpty) {
                        // Tampilkan pesan jika tidak ada data yang diterima
                        return Text('Tidak ada data yang diterima dari server');
                      }
                      List<DataBooking> filteredList = bookings.where((booking) =>
                      booking.status != null &&
                          booking.namaJenissvc != null &&
                          booking.status!.toLowerCase() == 'diproses' &&
                          !(booking.namaJenissvc!.toLowerCase() == 'Repair & Maintenance' ||
                              booking.namaJenissvc!.toLowerCase() == 'General Check UP/P2H')
                      ).toList();

                      print('Data setelah penyaringan: $filteredList');

                      if (filteredList.isNotEmpty) {
                        DataBooking bookingData = filteredList.first;
                        String routeName = '';
                        if (bookingData.namaJenissvc!.toLowerCase() == 'repair & maintenance') {
                          routeName = Routes.GENERAL_CHECKUP;
                        } else if (bookingData.namaJenissvc!.toLowerCase() == 'general check up/p2h') {
                          routeName = Routes.HOME;
                        } else {
                          Get.snackbar('Info', 'Jenis layanan tidak valid');
                          return SizedBox();
                        }
                        if (bookingData.id != null &&
                            bookingData.tglBooking != null &&
                            bookingData.jamBooking != null &&
                            bookingData.nama != null &&
                            bookingData.namaJenissvc != null &&
                            bookingData.noPolisi != null &&
                            bookingData.namaMerk != null &&
                            bookingData.namaTipe != null &&
                            bookingData.status != null) {
                          return ElevatedButton(
                            onPressed: () {
                              Get.toNamed(
                                routeName,
                                arguments: {
                                  'id': bookingData.id.toString(), // Mengonversi int menjadi String
                                  'tgl_booking': bookingData.tglBooking.toString(), // Mengonversi int menjadi String
                                  'jam_booking': bookingData.jamBooking.toString(), // Mengonversi int menjadi String
                                  'nama': bookingData.nama.toString(),
                                  'nama_jenissvc': bookingData.namaJenissvc.toString(),
                                  'no_polisi': bookingData.noPolisi.toString(),
                                  'nama_merk': bookingData.namaMerk.toString(),
                                  'nama_tipe': bookingData.namaTipe.toString(),
                                  'status': bookingData.status.toString(),
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
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
                          );
                        } else {
                          // Lakukan penanganan jika data tidak lengkap
                          print('Data tidak lengkap');
                          return SizedBox();
                        }
                      } else {
                        // Pastikan bahwa pesan ini muncul ketika tidak ada data yang sesuai
                        return Text('Tidak ada data yang sesuai');
                      }
                    }
                  },
                ),

                const SizedBox(width: 10,),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 4.0,
                ),
                child: const Text('Unapprove',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
            const SizedBox(width: 10,),
            ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 4.0,
                ),
                child: const Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),],),
          ],),),
        )
    );
  }
}
