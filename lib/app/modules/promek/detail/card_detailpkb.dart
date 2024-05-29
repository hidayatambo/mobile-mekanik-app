import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';
import '../controllers/promek_controller.dart';

class CardDetailPKB extends StatefulWidget {
  const CardDetailPKB({super.key});

  @override
  State<CardDetailPKB> createState() => _CardDetailPKBState();
}

class _CardDetailPKBState extends State<CardDetailPKB> {
  final PromekController controller = Get.put(PromekController());
  TimeOfDay? _selectedTime;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final Map args = Get.arguments;
    controller.setInitialValues(args);
  }

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
        String formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}:00";
        controller.jam.text = formattedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map args = Get.arguments;
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
        child: Column(
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
            // Kode Booking
            Row(
              children: [
                const Text('Kode PKB : ', style: TextStyle(fontWeight: FontWeight.normal)),
                Text(args['kode_pkb'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 10),
            // Jenis Service
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
                      label: Text(args['tipe_svc'] ?? '', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ),

              ],
            ),
            const SizedBox(height: 10),
            // Tanggal dan Jam Booking
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Tanggal Booking (edit)'),
                      // TextField(
                      //   controller: controller.tanggal,
                      //   readOnly: true,
                      //   onTap: () {
                      //     _selectDate(context);
                      //   },
                      //   decoration: InputDecoration(
                      //     filled: true,
                      //     fillColor: Colors.white,
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //     contentPadding: const EdgeInsets.only(left: 25, right: 20),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                // Flexible(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Text('Jam Booking (edit)'),
                //       TextField(
                //         controller: controller.jam, // Gunakan controller dari GetX
                //         readOnly: true,
                //         onTap: () {
                //           _selectTime(context);
                //         },
                //         decoration: InputDecoration(
                //           filled: true,
                //           fillColor: Colors.white,
                //           border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(10),
                //           ),
                //           contentPadding: const EdgeInsets.only(left: 25, right: 20),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
            // Detail Kendaraan
            const Divider(color: Colors.grey),
            const Text('Detail Kendaraan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // No Polisi dan Merk
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('No Polisi'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(args['no_polisi'] ?? '-', style: const TextStyle(color: Colors.black)),
                            hintStyle: const TextStyle(color: Colors.black),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Merk'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(args['nama_merk'] ?? '-', style: const TextStyle(color: Colors.black)),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Tipe dan Tahun
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Tipe'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(args['nama_tipe'] ?? '-', style: const TextStyle(color: Colors.black)),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Tahun'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(args['tahun'] ?? '-', style: const TextStyle(color: Colors.black)),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Warna dan Transmisi
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Warna'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(args['warna'] ?? '-', style: const TextStyle(color: Colors.black)),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Transmisi'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(args['transmisi'] ?? '-', style: const TextStyle(color: Colors.black)),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // No Rangka dan No Mesin
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('No Rangka'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: controller.rangka,
                          decoration: InputDecoration(
                            hintText: args['no_rangka'] ?? "-",
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('No Mesin'),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          keyboardType: TextInputType.number,
                          controller: controller.mesin,
                          decoration: InputDecoration(
                            label: Text(args['no_mesin'] ?? "-"),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Odometer
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Odometer'),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: controller.odometer,
                          decoration: InputDecoration(
                            label: Text(args['odometer'] ?? ''),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                const Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(''),
                    ],
                  ),
                ),
              ],
            ),
            // Detail Pelanggan
            const Divider(color: Colors.grey),
            const Text('Detail Pelangan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Nama Pelangan'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(args['nama'] ?? '-', style: const TextStyle(color: Colors.black)),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Alamat Pelangan'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            label: Text(args['alamat'] ?? '-', style: const TextStyle(color: Colors.black)),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // HP dan PIC
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('HP'),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 25, right: 20),
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            hintText: args['hp'] ?? "-",
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // HP PIC
            const SizedBox(height: 10),
            const Divider(color: Colors.grey),
            const Text('PIC', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('PIC'),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: controller.pic,
                          decoration: InputDecoration(
                            hintText: args['pic'] ?? '-',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('HP PIC'),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: controller.hppic,
                          decoration: InputDecoration(
                            hintText: '',
                            label: Text(args['hp_pic'] ?? ''),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Tgl Keluar (edit)'),
                      TextField(
                        controller: controller.tanggal,
                        readOnly: true,
                        onTap: () {
                          _selectDate(context);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.only(left: 25, right: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text('Jam Estimasi (edit)'),
                      TextField(
                        controller: controller.jam, // Gunakan controller dari GetX
                        readOnly: true,
                        onTap: () {
                          _selectTime(context);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.only(left: 25, right: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('KM Keluar'),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: controller.odometer,
                          decoration: InputDecoration(
                            label: Text(args['odometer'] ?? ''),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tanggal kembali'),
                      TextField(
                        controller: controller.tanggal,
                        readOnly: true,
                        onTap: () {
                          _selectDate(context);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.only(left: 25, right: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('KM Kembali'),
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: controller.odometer,
                          decoration: InputDecoration(
                            label: Text(args['odometer'] ?? ''),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintStyle: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Jam Selesai'),
                      TextField(
                        controller: controller.jam, // Gunakan controller dari GetX
                        readOnly: true,
                        onTap: () {
                          _selectTime(context);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.only(left: 25, right: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Keluhan dan Perintah Kerja
            const Divider(color: Colors.grey),
            const Text('Keluhan', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(3.0),
              child: SizedBox(
                height: 140, // <-- TextField expands to this height.
                child: TextField(
                  maxLines: null, // Set this
                  expands: true, // and this
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    label: Text(args['odometer'] ?? ''),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintStyle: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Printah Kerja', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(3.0),
              child: SizedBox(
                height: 140, // <-- TextField expands to this height.
                child: TextField(
                  maxLines: null, // Set this
                  expands: true, // and this
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    label: Text(args['odometer'] ?? ''),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintStyle: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text('Pergantian Part', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(3.0),
              child: SizedBox(
                height: 140, // <-- TextField expands to this height.
                child: TextField(
                  maxLines: null, // Set this
                  expands: true, // and this
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    label: Text(args['odometer'] ?? ''),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintStyle: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
    ]);
  }
}
