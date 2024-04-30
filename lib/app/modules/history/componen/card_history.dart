import 'package:flutter/material.dart';
import 'package:mekanik/app/componen/color.dart';

import '../../../data/data_endpoint/boking.dart';
import '../../../data/data_endpoint/history.dart';

class HistoryList extends StatelessWidget {
  final DataHistory items;
  final VoidCallback onTap;

  const HistoryList({Key? key, required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color statusColor = StatusColor.getColor(items.status??'');
    return InkWell(
      onTap: onTap, // Menggunakan onTap yang diterima dari luar
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [
                  Text('Tipe Service'),
                  Text(items.tipeSvc??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                ],),
                Column(
                    children: [
                      Text('Status'),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Text(
                              items.status.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),]),
              ],),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(10),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(children: [
                    Text('Tgl estimasi :'),
                    Text(items.tglEstimasi??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                  ],),
                  Column(children: [
                    Text('Kode estimasi :'),
                    Text(items.kodeEstimasi??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                  ],),
                ],),),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(10),
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Detail Pelanggan',style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      Text('Pelanggan :'),
                      Text(items.nama??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                    ],),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      Text('Kode PKB :'),
                      Text(items.kodeEstimasi??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                    ],),
                  ],),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('No Polisi :'),
                          Text(items.noPolisi??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                        ],),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Odometer :'),
                          Text(items.odometer??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                        ],),
                    ],),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('KM Keluar :'),
                          Text(items.kmKeluar??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                        ],),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('KM Kembali :'),
                          Text(items.kmKembali??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                        ],),
                    ],),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Tgl Keluar :'),
                          Text(items.tglKeluar??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                        ],),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Tgl Kembali :'),
                          Text(items.tglKembali??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                        ],),
                    ],),
                  SizedBox(height: 10,),
                  Divider(color: Colors.grey,),
                  SizedBox(height: 10,),
                  Text('Detail Mekanik',style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('PIC Estimasi :'),
                          Text(items.createdBy??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                        ],),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('PIC PKB :'),
                          Text(items.createdByPkb??"-",style: TextStyle(fontWeight: FontWeight.bold),),
                        ],),
                    ],),
                ],),),
          ],
        ),
      ),
    );
  }
}

class StatusColor {
  static Color getColor(String status) {
    switch (status.toLowerCase()) {
      case 'diproses':
        return Colors.orange;
      case 'estimasi':
        return Colors.lime;
      case 'dikerjakan':
        return Colors.orange;
      case 'invoice':
        return Colors.blue;
      case 'ditolak by sistem':
        return Colors.red;
      case 'ditolak':
        return Colors.red;
      case 'selesai dikerjakan':
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }
}
