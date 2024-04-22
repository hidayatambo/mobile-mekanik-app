import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../componen/color.dart';

class cardInfo extends StatefulWidget {
  const cardInfo({super.key});

  @override
  State<cardInfo> createState() => _cardInfoState();
}

class _cardInfoState extends State<cardInfo> {
  @override
  Widget build(BuildContext context) {
    final Map args = Get.arguments;
    final String bookingId = args['id'];
    final String tgl_booking = args['tgl_booking'];
    final String jam_booking = args['jam_booking'];
    final String nama = args['nama'];
    final String nama_jenissvc = args['nama_jenissvc'];
    final String no_polisi = args['no_polisi'];
    final String nama_merk = args['nama_merk'];
    final String nama_tipe = args['nama_tipe'];
    final String status = args['status'];
    String dropdownValue = 'Oke';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
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
        children: [
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     const SizedBox(height: 5,),
          //     Container(
          //       width: double.infinity,
          //       padding: const EdgeInsets.all(10),
          //       decoration: BoxDecoration(
          //         color: StatusColor.getColor(status),
          //         borderRadius: BorderRadius.circular(10),
          //       ),
          //       child: Column(
          //         children: [
          //           Text(
          //             '$status',
          //             style: const TextStyle(
          //               color: Colors.white,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Jenis Service'),
                  Text('$nama_jenissvc', style: const TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: MyColors.appPrimaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Column(
                        children: [
                          Text('tgl booking :', style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      '$tgl_booking ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Merek :'),
                  Text('$nama_merk', style: const TextStyle(fontWeight: FontWeight.bold),),
                  const Divider(color: Colors.grey,),
                  const Text('Type :'),
                  Text('$nama_tipe', style: const TextStyle(fontWeight: FontWeight.bold),),
                  const Divider(color: Colors.grey,),

                ],
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: MyColors.appPrimaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text('Jam Booking :',style: TextStyle(color: Colors.white),),
                        const SizedBox(height: 10,),
                        Text(
                          '$jam_booking',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('NoPol :'),
              Text('$no_polisi', style: const TextStyle(fontWeight: FontWeight.bold),),
              const Divider(color: Colors.grey,),
              const Text('Pemilik :'),
              Text('$nama', style: const TextStyle(fontWeight: FontWeight.bold),),
            ],),
        ],
      ),
    );
  }
}
