import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/data_endpoint/detailhistory.dart';
import '../../../data/endpoint.dart';
import '../controllers/detailhistory_controller.dart';

class DetailhistoryView extends GetView<DetailhistoryController> {
  const DetailhistoryView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments = Get.arguments as Map<String, dynamic>?;
    final String kodeSvc = arguments?['kode_svc'] ?? '';
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailhistoryView'),
        centerTitle: true,
      ),
      body: FutureBuilder<DetailHistory>(
        future: API.DetailhistoryID(kodesvc: kodeSvc),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            if (snapshot.data != null) {
              final tglEstimasi = snapshot.data!.dataSvc?.tglEstimasi ?? "";
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        8.0, 0.0, 8.0, 8.0),
                    child: Text(
                      tglEstimasi,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
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
    );
  }
}
