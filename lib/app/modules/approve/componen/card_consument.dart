import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../componen/color.dart';
import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';

class CardConsument extends StatefulWidget {
  const CardConsument({super.key});

  @override
  State<CardConsument> createState() => _CardConsumentState();
}

class _CardConsumentState extends State<CardConsument> {
  @override
  Widget build(BuildContext context) {
    final Map args = Get.arguments;
    final String? bookingId = args['id'];
    final String? tgl_booking = args['tgl_booking'];
    final String? jam_booking = args['jam_booking'];  final String nama = args['nama'] ?? '';
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
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
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
                future: API.profile,
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
              SizedBox(height: 20,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Tipe Service',
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 12)),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.all(5),
                        padding: EdgeInsets.all(5),
                        child: Text(
                         '$nama_jenissvc',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Tanggal',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '$tgl_booking',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Jam',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '$jam_booking',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
              Text('Detail Kendaraan',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('No Polisi *',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '$no_polisi',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Merk',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '$nama_merk',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Tipe',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '$nama_tipe',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Tahun',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                           '$tahun',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Warna',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                           ' $warna',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Transmisi',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('No Rangka',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                           '$norangka',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('No Mesin',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                           '$nomesin',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Odometer',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
              Text('Detail Pemilik',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12)),
              SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Nama',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '$nama',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Alamat',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.all(5),
                            padding: EdgeInsets.all(5),
                            child: Text(
                              '$alamat',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('HP',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '$hp',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('PIC',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('HP PIC',
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 12)),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.all(5),
                          padding: EdgeInsets.all(5),
                          child: null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
