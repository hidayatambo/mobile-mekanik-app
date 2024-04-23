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

                      // Tambahkan variabel untuk menunjukkan apakah ada data yang sesuai
                      bool dataFound = false;

                      for (DataBooking e in bookings) {
                        if (e.status != null && e.namaJenissvc != null) {
                          if (e.status!.toLowerCase() == 'diproses' &&
                              e.namaJenissvc!.toLowerCase() != 'general check up/p2h') {
                            // Lakukan navigasi jika ada data yang sesuai
                            Get.toNamed(
                              Routes.APPROVE,
                              arguments: {
                                'id': e.id.toString(),
                                'tgl_booking': e.tglBooking.toString(),
                                'jam_booking': e.jamBooking.toString(),
                                'nama': e.nama.toString(),
                                'nama_jenissvc': e.namaJenissvc.toString(),
                                'no_polisi': e.noPolisi.toString(),
                                'nama_merk': e.namaMerk.toString(),
                                'nama_tipe': e.namaTipe.toString(),
                                'status': e.status.toString(),
                              },
                            );
                            // Set dataFound menjadi true karena ada data yang sesuai
                            dataFound = true;
                            // Keluar dari loop karena sudah menemukan data yang sesuai
                            break;
                          }
                        }
                      }

                      if (!dataFound) {
                        // Tampilkan pesan jika tidak ada data yang sesuai
                        return Text('Tidak ada data yang sesuai');
                      } else {
                        // Jika ada data yang sesuai, tidak perlu menampilkan widget apa pun di sini
                        // Karena navigasi telah dilakukan di dalam loop
                        return SizedBox();
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
