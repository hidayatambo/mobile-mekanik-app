import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/data_endpoint/mekanik.dart';
import '../../../data/endpoint.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: CustomSliverDelegate(
                expandedHeight: 150,
              ),
            ),
            SliverFillRemaining(
              child: null
              // MyStepperPage()
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;

  CustomSliverDelegate({
    required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final Map args = Get.arguments;
    final String? bookingId = args['kode_booking'];
    final String nama = args['nama'] ?? '';
    final String nama_jenissvc = args['nama_jenissvc'] ?? '';
    final String nama_tipe = args['nama_tipe'] ?? '';
    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight / 3 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    String? selectedMechanic = '';
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return SizedBox(
      height: expandedHeight + expandedHeight / 0.6,
      child: Stack(
        children: [
          SizedBox(
            height: appBarSize < kToolbarHeight ? kToolbarHeight : appBarSize,
            child: AppBar(
              backgroundColor:Colors.white,
              toolbarHeight: 40,
              elevation: 0.0,
              title: Opacity(
                  opacity: hideTitleWhenExpanded ? 1.0 - percent : 1.0,
                  child: Text("Test",)),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: cardTopPosition > 0 ? cardTopPosition : 2,
            bottom: 0.0,
            child: Opacity(
              opacity: percent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10 * percent),
                child: Container(
                  margin: EdgeInsets.only(top: 0),
                  child:
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 5,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child:Column(
                      children: [
                       Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama :', style: TextStyle(fontSize: 13),),
                                Text('$nama',style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                Text('Kendaraan :',style: TextStyle(fontSize: 13),),
                                Text('$nama_tipe',style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                              ]),

                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Jenis Service :', style: TextStyle(fontSize: 13),),
                                Text('$nama_jenissvc',style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                Text('Kode Boking :',style: TextStyle(fontSize: 13),),
                                Text('$bookingId',style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                              ]),
                        ],),
                      SizedBox(height: 5,),
                      FutureBuilder<Mekanik>(
                        future: API.MekanikID(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            if (snapshot.hasData && snapshot.data!.dataMekanik != null && snapshot.data!.dataMekanik!.isNotEmpty) {
                              final List<DataMekanik> _list = snapshot.data!.dataMekanik!;
                              final List<String> namaMekanikList = _list
                                  .map((mekanik) => mekanik.nama!)
                                  .where((nama) => nama != null)
                                  .toList();
                              return Column(
                                children: [
                                  CustomDropdown<String>.search(
                                    hintText: 'Pilih mekanik',
                                    items: namaMekanikList,
                                    excludeSelected: false,
                                    onChanged: (value) {
                                      selectedMechanic = value;
                                      log('Mengubah nilai menjadi: $value');
                                    },
                                  ),
                                ],
                              );
                            } else {
                              // Menampilkan pesan jika tidak ada data Mekanik
                              return Center(child: Text('Mekanik tidak ada'));
                            }
                          }
                        },
                      ),
                    ],),
                  ),
                ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight + expandedHeight / 2;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
