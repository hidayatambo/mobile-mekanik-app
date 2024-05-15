import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

import '../../../componen/color.dart';
import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';
import '../controllers/approve_controller.dart';

class CardConsuments2 extends StatefulWidget {
  const CardConsuments2({super.key});

  @override
  State<CardConsuments2> createState() => _CardConsuments2State();
}

class _CardConsuments2State extends State<CardConsuments2> {
  String? id_karyawan;
  String? kode_booking;
  String? kode_pelanggan;
  String? kode_kendaraan;
  String? kategori_kendaraan;
  String? tgl_booking;
  String? jam_booking;
  String? odometer;
  String? pic;
  String? hp_pic;
  String? kode_membership;
  String? kode_paketmember;
  String? tipe_svc;
  String? tipe_pelanggan;
  String? referensi;
  String? referensi_teman;
  String? paket_svc;
  String? keluhan;
  String? perintah_kerja;
  String? ppn;

  @override
  void initState() {
    super.initState();

  }
  final controller = Get.find<ApproveController>();
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Use DateFormat to format the DateTime object
        controller.tanggal.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }


    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _selectedTime ?? TimeOfDay.now(),
      );
      if (picked != null && picked != _selectedTime) {
        setState(() {
          _selectedTime = picked;
          // Format the time as HH:mm:00
          String formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
          controller.jam.text = formattedTime; // Assign formatted time to the controller
          print('Time picked: $formattedTime'); // Debugging output to verify the picked time
        });
      }
    }


  @override
  Widget build(BuildContext context) {
    final Map args = Get.arguments;
    String? tgl_booking = args['tgl_booking'];
    final String? jam_booking = args['jam_booking'];
    final String nama = args['nama'] ?? '';
    final String nama_jenissvc = args['nama_jenissvc'] ?? '';
    final String no_polisi = args['no_polisi'] ?? '';
    final String nama_merk = args['nama_merk'] ?? '';
    final String nama_tipe = args['nama_tipe'] ?? '';
    final String alamat = args['alamat'] ?? '';
    final String tahun = args['tahun'] ?? '';
    final String warna = args['warna'] ?? '';
    final String keluhan = args['keluhan'] ?? '';
    final String kodebooking = args['kode_booking'] ?? '';
    final String nomesin = args['no_mesin'] ?? '';
    final String norangka = args['no_rangka'] ?? '';
    final String transmisi = args['transmisi'] ?? '';
    final String hp = args['hp'] ?? '';
    final String hppic = args['hp_pic'] ?? '';
    return Column(children: [
      Container(
        padding: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder<Profile>(
              future: API.profileiD(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data != null) {
                    final cabang = snapshot.data!.data?.cabang ?? "";
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cabang,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('Tidak ada data');
                  }
                }
              },
            ),
            Row(children: [
              Text('Kode Booking : ',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,)),
              Text(kodebooking,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,)),
            ],),
            SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Jenis Service'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.only(left: 25, right: 20),
                  child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      hintText: nama_jenissvc,
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ),

              ],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Tanggal Booking(edit)'),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                        },
                        child:
                        Container(
                          width: double.infinity,
                          height: 47,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(left: 25, right: 20),
                          child:  Center(
                            child:
                            Text( _selectedDate == null
                                  ? '$tgl_booking'
                                  : DateFormat('yyyy-MM-dd').format(_selectedDate!),style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),

                    ],),),
                SizedBox(width: 10,),
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Jam Booking(edit)'),
                      InkWell(
                        onTap: () {
                          _selectTime(context);
                        },
                        child:
                        Container(
                          width: double.infinity,
                          height: 47,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(left: 25, right: 20),
                          child:  Center(
                            child:
                            Text(
                              _selectedTime == null
                                  ? '$jam_booking'
                                  : DateFormat('HH:mm:ss').format(
                                  DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, _selectedTime!.hour, _selectedTime!.minute)
                              ),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),

                    ],),),
              ],),
            const Divider(
              color: Colors.grey,
            ),
            const Text('Detail Kendaraan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,)),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('No Polisi'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(no_polisi ??'-', style: TextStyle(color: Colors.black),),
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none,
                          ),
                        ),
                      ),

                    ],),),
                SizedBox(width: 10,),
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Merk'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(nama_merk ??'-', style: TextStyle(color: Colors.black),),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    ],),),
              ],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Tipe'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(nama_tipe ??'-', style: TextStyle(color: Colors.black),),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    ],),),
                SizedBox(width: 10,),
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Tahun'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(tahun ??'-', style: TextStyle(color: Colors.black),),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    ],),),
              ],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Warna'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(warna ??'-', style: TextStyle(color: Colors.black),),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),

                          ),
                        ),
                      ),

                    ],),),
                SizedBox(width: 10,),
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Transmisi'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(transmisi ??'-', style: TextStyle(color: Colors.black),),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    ],),),
              ],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('No Rangka'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: controller.rangka,
                          decoration: InputDecoration(
                            hintText: norangka?? "-",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    ],),),
                SizedBox(width: 10,),
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('No Mesin'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: controller.mesin,
                          decoration: InputDecoration(
                            hintText: nomesin,
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    ],),),
              ],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Odometer'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: controller.odometer,
                          decoration: InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],),),
                SizedBox(width: 10,),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Keluhan'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,

                          decoration: InputDecoration(
                            label: Text(keluhan ??'-', style: TextStyle(color: Colors.black),),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    ],),),
              ],),
            const Divider(
              color: Colors.grey,
            ),
            const Text('Detail Pelangan',
                style: TextStyle(
                  fontWeight: FontWeight.bold,)),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Nama Pelangan'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(nama ??'-', style: TextStyle(color: Colors.black),),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),

                          ),
                        ),
                      ),

                    ],),),
                SizedBox(width: 10,),
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Alamat Pelangan'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(alamat ??'-', style: TextStyle(color: Colors.black),),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    ],),),
              ],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('HP'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: hp?? "-",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    ],),),
                SizedBox(width: 10,),
                Flexible(
                  child:
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('PIC'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          controller: controller.nomesin,
                          decoration: InputDecoration(
                            hintText: nomesin,
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    ],),),
              ],),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HP PIC'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child:  TextField(
                          keyboardType: TextInputType.number,
                          controller: controller.hppic,
                          decoration: InputDecoration(
                            hintText: '',
                            label: Text(hppic),
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),

                    ],),),
                SizedBox(width: 10,),
                Flexible(
                  child:
                  Column(
                    children: [
                    ],),),
              ],),

          ],
        ),
      ),
      SizedBox(height: 20,),
      Container(
          padding: const EdgeInsets.all(10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            Text('Keluhan'),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.only(left: 25, right: 20),
              child: TextField(
                controller: controller.keluhan,
                decoration: InputDecoration(
                  hintText: '',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Text('Printah Kerja'),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.only(left: 25, right: 20),
              child: TextField(
                controller: controller.perintah,
                decoration: InputDecoration(
                  hintText: '',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],)
      ),
    ]);
  }
}
