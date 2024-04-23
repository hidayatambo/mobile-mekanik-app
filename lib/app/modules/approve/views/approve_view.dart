import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mekanik/app/componen/color.dart';
import '../../../routes/app_pages.dart';
import '../../general_checkup/componen/card_info.dart';
import '../../general_checkup/views/general_checkup_view.dart';
import '../controllers/approve_controller.dart';

class ApproveView extends GetView<GetxController> {
  const ApproveView({super.key});
  void approveBooking(Map<String, dynamic> arguments) {
    // Lakukan logika untuk menyetujui booking di sini
    // Anda dapat mengakses argumen menggunakan arguments['namaArgumen']
    String id = arguments['id'];
    String tglBooking = arguments['tgl_booking'];
    String nama_jenissvc = arguments['nama_jenissvc'];
    // Dan seterusnya untuk argumen lainnya

    // Contoh tindakan:
    print('Menyetujui booking dengan ID: $id, Tanggal: $tglBooking, nama_jenissvc: $nama_jenissvc');
  }
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
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic>? arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

                    if (arguments != null) {
                      // Periksa jenis layanan, jika "General Check UP/P2H", arahkan ke GeneralCheckupView()
                      if (arguments['nama_jenissvc'] == 'General Check UP/P2H') {
                        ApproveController controller = Get.put(ApproveController());
                        controller.setData(
                          id: arguments['id'],
                          tglBooking: arguments['tgl_booking'],
                          jamBooking: arguments['jam_booking'],
                          nama: arguments['nama'],
                          namaJenissvc: arguments['nama_jenissvc'],
                          noPolisi: arguments['no_polisi'],
                          namaMerk: arguments['nama_merk'],
                          namaTipe: arguments['nama_tipe'],
                          status: arguments['status'],
                        );
                        _showBottomSheet(context, arguments);
                        // Navigator.pushNamed(
                        //   context,
                        //   Routes.GENERAL_CHECKUP,
                        //   arguments: {
                        //     'id': arguments['id'],
                        //     'tgl_booking': arguments['tgl_booking'],
                        //     'jam_booking': arguments['jam_booking'],
                        //     'nama': arguments['nama'],
                        //     'nama_jenissvc': arguments['nama_jenissvc'],
                        //     'no_polisi': arguments['no_polisi'],
                        //     'nama_merk': arguments['nama_merk'],
                        //     'nama_tipe': arguments['nama_tipe'],
                        //     'status': arguments['status'],
                        //   },
                        // );
                      } else {
                        // Jika bukan "General Check UP/P2H", lakukan logika persetujuan yang lain
                        Navigator.pushNamed(
                          context,
                          Routes.REPAIR_MAINTENEN,
                          arguments: {
                            'id': arguments['id'],
                            'tgl_booking': arguments['tgl_booking'],
                            'jam_booking': arguments['jam_booking'],
                            'nama': arguments['nama'],
                            'nama_jenissvc': arguments['nama_jenissvc'],
                            'no_polisi': arguments['no_polisi'],
                            'nama_merk': arguments['nama_merk'],
                            'nama_tipe': arguments['nama_tipe'],
                            'status': arguments['status'],
                          },
                        );
                      }
                    } else {
                      // Handle kasus ketika arguments null
                      print('Error: Arguments tidak diterima');
                      // Atau lakukan tindakan lain sesuai kebutuhan aplikasi Anda
                    }
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
  // Fungsi untuk menampilkan BottomSheet
  void _showBottomSheet(BuildContext context, Map<String, dynamic> arguments) {
    ApproveController bottomSheetController = Get.put(ApproveController());

    bottomSheetController.idController.text = arguments['id'] ?? '';
    bottomSheetController.tglBookingController.text = arguments['tgl_booking'] ?? '';
    bottomSheetController.jamBookingController.text = arguments['jam_booking'] ?? '';
    bottomSheetController.namaController.text = arguments['nama'] ?? '';
    bottomSheetController.namaJenissvcController.text = arguments['nama_jenissvc'] ?? '';
    bottomSheetController.noPolisiController.text = arguments['no_polisi'] ?? '';
    bottomSheetController.namaMerkController.text = arguments['nama_merk'] ?? '';
    bottomSheetController.namaTipeController.text = arguments['nama_tipe'] ?? '';
    bottomSheetController.statusController.text = arguments['status'] ?? '';

    showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: 700,
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Ingin ubah tanggal dan jam booking ?',style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                TextField(
                  controller: bottomSheetController.tglBookingController,
                  decoration: InputDecoration(
                    labelText: 'Tanggal Booking',
                  ),
                ),
                TextField(
                  controller: bottomSheetController.jamBookingController,
                  decoration: InputDecoration(
                    labelText: 'Jam Booking',
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                    onPressed: () {
                      // Lakukan sesuatu dengan nilai yang dimasukkan
                      String id = bottomSheetController.idController.text;
                      String tglBooking = bottomSheetController.tglBookingController.text;
                      String jamBooking = bottomSheetController.jamBookingController.text;
                      String nama = bottomSheetController.namaController.text;
                      String namaJenissvc = bottomSheetController.namaJenissvcController.text;
                      String noPolisi = bottomSheetController.noPolisiController.text;
                      String namaMerk = bottomSheetController.namaMerkController.text;
                      String namaTipe = bottomSheetController.namaTipeController.text;
                      String status = bottomSheetController.statusController.text;

                      // Tutup BottomSheet
                      Navigator.of(context).pop();
                      showModalBottomSheet(
                        context: context,
                        enableDrag: true,
                        showDragHandle: true,
                        builder: (BuildContext context) {
                          return SingleChildScrollView(
                            child: Container(
                              height: 700,
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text('Ingin ubah tanggal dan jam booking ?',style: TextStyle(fontWeight: FontWeight.bold),),
                                  SizedBox(height: 20,),
                                  TextField(
                                    controller: bottomSheetController.tglBookingController,
                                    decoration: InputDecoration(
                                      labelText: 'Tanggal Booking',
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          Routes.GENERAL_CHECKUP,
                                          arguments: {
                                            'id': arguments['id'],
                                            'tgl_booking': arguments['tgl_booking'],
                                            'jam_booking': arguments['jam_booking'],
                                            'nama': arguments['nama'],
                                            'nama_jenissvc': arguments['nama_jenissvc'],
                                            'no_polisi': arguments['no_polisi'],
                                            'nama_merk': arguments['nama_merk'],
                                            'nama_tipe': arguments['nama_tipe'],
                                            'status': arguments['status'],
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: MyColors.appPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20)),
                                        elevation: 4.0,
                                      ),
                                      child: const Text('Konfirmasi',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //     // Lakukan sesuatu dengan nilai yang dimasukkan
                                  //     String id = bottomSheetController.idController.text;
                                  //     String tglBooking = bottomSheetController.tglBookingController.text;
                                  //     String jamBooking = bottomSheetController.jamBookingController.text;
                                  //     String nama = bottomSheetController.namaController.text;
                                  //     String namaJenissvc = bottomSheetController.namaJenissvcController.text;
                                  //     String noPolisi = bottomSheetController.noPolisiController.text;
                                  //     String namaMerk = bottomSheetController.namaMerkController.text;
                                  //     String namaTipe = bottomSheetController.namaTipeController.text;
                                  //     String status = bottomSheetController.statusController.text;
                                  //
                                  //     // Tutup BottomSheet
                                  //     Navigator.of(context).pop();
                                  //   },
                                  //   child: Text('Simpan'),
                                  // ),
                                ],
                              ),
                            ),
                          );
                        },
                      );

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.appPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 4.0,
                    ),
                    child: const Text('Simpan',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
                // ElevatedButton(
                //   onPressed: () {
                //     // Lakukan sesuatu dengan nilai yang dimasukkan
                //     String id = bottomSheetController.idController.text;
                //     String tglBooking = bottomSheetController.tglBookingController.text;
                //     String jamBooking = bottomSheetController.jamBookingController.text;
                //     String nama = bottomSheetController.namaController.text;
                //     String namaJenissvc = bottomSheetController.namaJenissvcController.text;
                //     String noPolisi = bottomSheetController.noPolisiController.text;
                //     String namaMerk = bottomSheetController.namaMerkController.text;
                //     String namaTipe = bottomSheetController.namaTipeController.text;
                //     String status = bottomSheetController.statusController.text;
                //
                //     // Tutup BottomSheet
                //     Navigator.of(context).pop();
                //   },
                //   child: Text('Simpan'),
                // ),
              ],
            ),
          ),
        );
      },
    );

  }
}
