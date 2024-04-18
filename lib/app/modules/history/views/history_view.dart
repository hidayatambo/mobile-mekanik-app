import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';
import '../componen/card_history.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('History'),
              FutureBuilder<Profile>(
                future: API.profile,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    if (snapshot.data != null) {
                      final cabang = snapshot.data!.data?.cabang ?? "";
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$cabang",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Text('Tidak ada data');
                    }
                  }
                },
              ),
            ],),
          bottom: TabBar(
            isScrollable: true, // Membuat tab dapat digulir
            tabs: [
              Tab(text: 'Semua'),
              Tab(text: 'Booking Baru'),
              Tab(text: 'Dikerjakan'),
              Tab(text: 'Dikomplain'),
              Tab(text: 'Selesai'),
            ],
          ),
        ),
        body:  TabBarView(
          children: [
            // Konten untuk tab Info
            ProfileApp(),
            // Konten untuk tab Settings
            Center(
              child: Text('Pengaturan Profil'),
            ),
            Center(
              child: Text('Pengaturan Profil'),
            ),
            Center(
              child: Text('Pengaturan Profil'),
            ),
            Center(
              child: Text('Pengaturan Profil'),
            ),
          ],
        ),
      ),
    );
  }
}