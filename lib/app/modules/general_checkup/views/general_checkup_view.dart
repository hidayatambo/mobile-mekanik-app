import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mekanik/app/componen/color.dart';
import '../../repair_maintenen/componen/card_consument.dart';
import '../componen/step_gc_test.dart';

class GeneralCheckupView extends StatefulWidget {
  const GeneralCheckupView({super.key});

  @override
  _GeneralCheckupViewState createState() => _GeneralCheckupViewState();
}

class _GeneralCheckupViewState extends State<GeneralCheckupView> {
  Map<String, String?> status = {};

  void updateStatus(String key, String? value) {
    setState(() {
      status[key] = value;
    });
  }
  void handleSubmit() {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              for (String checkupItem in status.keys)
                ListTile(
                  title: Text(checkupItem),
                  subtitle: Text(status[checkupItem] ?? ''),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map args = Get.arguments;
    final String? bookingId = args['kode_booking'];
    final String? tgl_booking = args['tgl_booking'];
    final String? jam_booking = args['jam_booking'];
    final String nama = args['nama'] ?? '';
    final String nama_jenissvc = args['nama_jenissvc'] ?? '';
    final String no_polisi = args['no_polisi'] ?? '';
    final String nama_merk = args['nama_merk'] ?? '';
    final String nama_tipe = args['nama_tipe'] ?? '';
    final String alamat = args['alamat'] ?? '';
    final String tahun = args['tahun'] ?? '';
    final String warna = args['warna'] ?? '';
    final String nomesin = args['no_mesin'] ?? '';
    final String norangka = args['no_rangka'] ?? '';
    final String transmisi = args['transmisi'] ?? '';
    final String hp = args['hp'] ?? '';
    final String status = args['status'] ?? '';

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
        ),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Text('Edit General Check UP/P2H',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
              SizedBox(width: 50,),
            ],),
            SizedBox(height: 10,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
        Column(
        mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nama :', style: TextStyle(fontSize: 13),),
            Text('$nama',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
            Text('Kendaraan :',style: TextStyle(fontSize: 13),),
            Text('$nama_tipe',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
          ]),

                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jenis Service :', style: TextStyle(fontSize: 13),),
                      Text('$nama_jenissvc',style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                      Text('Kode Boking :',style: TextStyle(fontSize: 13),),
                      Text('$bookingId',style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                    ]),
            ],),

        ],),
        toolbarHeight: 120,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: false,
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.info, color: Colors.black),
          //   onPressed: () {
          //     Get.bottomSheet(
          //       _buildBottomSheet(),
          //       isDismissible: true,
          //       enableDrag: true,
          //       elevation: 10,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      body:  MyStepperPage()
     );
  }
  Widget _buildBottomSheet() {
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
    final Map args = Get.arguments;
    final String? bookingId = args['id'];
    final String? tgl_booking = args['tgl_booking'];
    final String? jam_booking = args['jam_booking'];
    final String nama = args['nama'] ?? '';
    final String nama_jenissvc = args['nama_jenissvc'] ?? '';
    final String no_polisi = args['no_polisi'] ?? '';
    final String nama_merk = args['nama_merk'] ?? '';
    final String nama_tipe = args['nama_tipe'] ?? '';
    final String alamat = args['alamat'] ?? '';
    final String tahun = args['tahun'] ?? '';
    final String warna = args['warna'] ?? '';
    final String nomesin = args['no_mesin'] ?? '';
    final String norangka = args['no_rangka'] ?? '';
    final String transmisi = args['transmisi'] ?? '';
    final String hp = args['hp'] ?? '';
    final String status = args['status'] ?? '';
    return Container(
      color: Colors.white,
      height: Get.height * 0.9, // Mengatur tinggi bottom sheet menjadi 80% dari tinggi layar
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Bottom Sheet',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Get.back(); // Menutup bottom sheet saat tombol close ditekan
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: const Center(
                child:  Cardmaintenent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
