import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';
import '../componen/card_history.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('History'),
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
                              color: Colors.grey,
                              fontSize: 15.0,
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
            ],),
          bottom: const TabBar(
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
            const Center(
              child: Text('Pengaturan Profil'),
            ),
            const Center(
              child: Text('Pengaturan Profil'),
            ),
            const Center(
              child: Text('Pengaturan Profil'),
            ),
            const Center(
              child: Text('Pengaturan Profil'),
            ),
          ],
        ),
      ),
    );
  }
}