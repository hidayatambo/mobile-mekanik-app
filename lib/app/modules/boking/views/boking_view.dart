  import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
  import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
  import 'package:get/get.dart';
  import 'package:google_fonts/google_fonts.dart';
import 'package:mekanik/app/data/data_endpoint/kategory.dart';
  import 'package:pull_to_refresh/pull_to_refresh.dart';
  import 'package:search_page/search_page.dart';

  import '../../../componen/loading_cabang_shimmer.dart';
import '../../../componen/loading_search_shimmer.dart';
import '../../../componen/loading_shammer_booking.dart';
import '../../../data/data_endpoint/boking.dart';
  import '../../../data/data_endpoint/profile.dart';
  import '../../../data/endpoint.dart';
  import '../../../routes/app_pages.dart';
import '../../../tester/tester_kategori.dart';
import '../componen/card_booking.dart';

  class BokingView extends StatefulWidget {
  const BokingView({super.key});

    @override
    State<BokingView> createState() => _BokingViewState();
  }

  class _BokingViewState extends State<BokingView> {

    void clearCachedBoking() {
      setState(() {
      });
    }

    @override
    Widget build(BuildContext context) {
      return BokingView2(
        clearCachedBoking: clearCachedBoking,
      );
    }
  }

  class BokingView2 extends StatefulWidget {
    final VoidCallback clearCachedBoking; // Menggunakan VoidCallback untuk tipe fungsi tanpa parameter

    const BokingView2({super.key, required this.clearCachedBoking});

    @override
    State<BokingView2> createState() => _BokingView2State();
  }

  class _BokingView2State extends State<BokingView2> {
    late List<RefreshController> _refreshControllers;

    @override
    void initState() {
      _refreshControllers = List.generate(7, (index) => RefreshController());
      super.initState();
    }

    @override
    Widget build(BuildContext context) {
      return DefaultTabController(
        length: 7,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            toolbarHeight: 60,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Booking'),
                FutureBuilder<Profile>(
                  future: API.profileiD(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const loadcabang();
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
              ],
            ),
            actions: [
              FutureBuilder(
                future: API.bokingid(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: loadsearch(),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final data = snapshot.data!.dataBooking;

                    if (data != null && data.isNotEmpty) {
                      return InkWell(
                        onTap: () => showSearch(
                          context: context,
                          delegate: SearchPage<DataBooking>(
                            items: data,
                            searchLabel: 'Cari Booking',
                            searchStyle: GoogleFonts.nunito(color: Colors.black),
                            showItemsOnEmpty: true,
                            failure: Center(
                              child: Text(
                                'Booking Tidak Dtemukan :(',
                                style: GoogleFonts.nunito(),
                              ),
                            ),
                            filter: (booking) => [
                              booking.nama,
                              booking.noPolisi,
                              booking.bookingStatus,
                              booking.namaMerk,
                              booking.namaTipe,
                            ],
                            builder: (items) => BokingList(items: items, onTap: () {  },),
                          ),
                        ),
                        child: const Icon(Icons.search_rounded),
                      );
                    } else {
                      return Center(
                        child: Text(
                          'Pencarian',
                          style: GoogleFonts.nunito(fontSize: 16),
                        ),
                      );
                    }
                  } else {
                    return Center(
                      child: Text(
                        'Terjadi kesalahan saat mengambil data.',
                        style: GoogleFonts.nunito(),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 20)
            ],
            bottom: const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Semua'),
                Tab(text: 'Diproses'),
                Tab(text: 'Dikerjakan'),
                Tab(text: 'Estimasi'),
                Tab(text: 'Selesai Dikerjakan'),
                Tab(text: 'Invoice'),
                Tab(text: 'Ditolak'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildTabContent(null), // Semua
              _buildTabContent('diproses'), // Diproses
              _buildTabContent('dikerjakan'), // Dikerjakan
              _buildTabContent('estimasi'), // Estimasi
              _buildTabContent('selesai dikerjakan'), // Selesai Dikerjakan
              _buildTabContent('invoice'), // Invoice
              _buildTabContent('ditolak'), // Ditolak
            ],
          ),
        ),
      );
    }

    Widget _buildTabContent(String? status) {
      DataBooking? selectedData;
      return SmartRefresher(
        controller: _refreshControllers[_getStatusIndex(status)],
        enablePullDown: true,
        header: const WaterDropHeader(),
        onRefresh: () => _onRefresh(status),
        onLoading: () => _onLoading(status),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: API.kategoriID(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData &&
                      snapshot.connectionState != ConnectionState.waiting &&
                      snapshot.data != null) {
                    Kategori getDataAcc =
                        snapshot.data ?? DataKategoriKendaraan();
                    return Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 475),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: getDataAcc.dataKategoriKendaraan != null
                            ? getDataAcc.dataKategoriKendaraan!
                            .map((e) {
                          return Datakategori(
                            items: e,
                            onTap: () {},
                          );
                        })
                            .toList()
                            : [Container()],
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: Get.height - 250,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [],
                        ),
                      ),
                    );
                  }
                },
              ),
              FutureBuilder<Boking>(
                future: API.bokingid(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SingleChildScrollView(
                      child: Loadingshammer(),
                    );
                  } else if (snapshot.hasError) {
                    return  Center(
                      child: Text('Belum ada data booking.'),
                    );
                  } else if (snapshot.hasData) {
                    Boking getDataAcc = snapshot.data!;
                    if (getDataAcc.status == false) {
                      return const  Center(
                        child: Text('Belum ada data booking.'),
                      );
                    } else if (getDataAcc.message == 'Invalid token: Expired') {
                      Get.offAllNamed(Routes.SIGNIN);
                      return const SizedBox.shrink();
                    }

                    List<DataBooking> filteredList = status != null
                        ? getDataAcc.dataBooking!
                        .where((item) => item.bookingStatus!.toLowerCase() == status)
                        .toList()
                        : getDataAcc.dataBooking!;

                    if (filteredList.isEmpty) {
                      return Center(
                        child: Text('Belum ada data booking.'),
                      );
                    }

                    return Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 475),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: filteredList
                            .map(
                              (e) => BokingList(
                            items: e,
                            onTap: () async {
                              if (kDebugMode) {
                                print('Nilai e.namaJenissvc: ${e.namaService??''}');
                              }
                              if (e.bookingStatus != null && e.namaService != null) {
                                if (e.bookingStatus!.toLowerCase() == 'diproses' &&
                                    e.namaService!.toLowerCase() !=
                                        'repair & maintenance') {
                                  Get.toNamed(
                                    Routes.APPROVE,
                                    arguments: {
                                      // 'id': e.id??'',
                                      'tgl_booking': e.tglBooking??'',
                                      'jam_booking': e.jamBooking??'',
                                      'nama': e.nama??'',
                                      'kode_kendaraan': e.kodeKendaraan??'',
                                      'kode_pelanggan': e.kodePelanggan??'',
                                      'kode_booking': e.kodeBooking??'',
                                      'nama_jenissvc': e.namaService??'',
                                      'no_polisi': e.noPolisi??'',
                                      'nama_merk': e.namaMerk??'',
                                      'keluhan': e.keluhan??'',
                                      'kode_booking': e.kodeBooking??'',
                                      'tahun': e.tahun??'',
                                      'warna': e.warna??'',
                                      'booking_id': e.tglBooking??'',
                                      'nama_tipe': e.namaTipe??'',
                                      'alamat': e.alamat??'',
                                      'hp': e.hp??'',
                                      'transmisi': e.transmisi??'',
                                      'status': e.bookingStatus??'',
                                    },
                                  );
                                } else if (e.bookingStatus!.toLowerCase() == 'diproses' &&
                                    e.namaService!.toLowerCase() !=
                                        'general check up/p2h') {
                                  Get.toNamed(
                                    Routes.APPROVE,
                                    arguments: {
                                      // 'id': e.id??'',
                                      'tgl_booking': e.tglBooking??'',
                                      'booking_id': e.tglBooking??'',
                                      'jam_booking': e.jamBooking??'',
                                      'nama': e.nama??'',
                                      'keluhan': e.keluhan??'',
                                      'kode_kendaraan': e.kodeKendaraan??'',
                                      'kode_pelanggan': e.kodePelanggan??'',
                                      'nama_jenissvc': e.namaService??'',
                                      'no_polisi': e.noPolisi??'',
                                      'kode_booking': e.kodeBooking??'',
                                      'tahun': e.tahun??'',
                                      'warna': e.warna??'',
                                      'ho': e.hp??'',
                                      'kode_booking': e.kodeBooking??'',
                                      'nama_merk': e.namaMerk??'',
                                      'transmisi': e.transmisi??'',
                                      'nama_tipe': e.namaTipe??'',
                                      'alamat': e.alamat??'',
                                      'status': e.bookingStatus??'',
                                      'status': e.bookingStatus??'',

                                    },
                                  );
                                } else {
                                }
                              } else {
                                // Lakukan penanganan jika status atau namaJenissvc bernilai null
                                print('Status atau namaJenissvc bernilai null');
                              }
                              if (kDebugMode) {
                                print('Nilai e.namaJenissvc: ${e.namaService??''}');
                              }
                              if (e.bookingStatus != null && e.namaService != null) {
                                if (e.bookingStatus!.toLowerCase() ==
                                    'dikerjakan' &&
                                    e.namaService!.toLowerCase() !=
                                        'repair & maintenance') {
                                  final generalData = await API.kategoriID();
                                  String kategoriKendaraanId = '';
                                  if (generalData != null) {
                                    final matchingKategori = generalData
                                        .dataKategoriKendaraan
                                        ?.where((kategori) =>
                                    kategori.kategoriKendaraan ==
                                        e.kategoriKendaraan)
                                        .firstOrNull;
                                    if (matchingKategori != null &&
                                        matchingKategori is DataKategoriKendaraan) {
                                      kategoriKendaraanId = matchingKategori
                                          .kategoriKendaraanId ?? '';
                                    }
                                  }
                                  Get.toNamed(
                                    Routes.CHAT,
                                    arguments: {
                                      // 'id': e.id??'',
                                      'tgl_booking': e.tglBooking ?? '',
                                      'booking_id': e.bookingId.toString(),
                                      'jam_booking': e.jamBooking ?? '',
                                      'nama': e.nama ?? '',
                                      'kode_booking': e.kodeBooking ?? '',
                                      'kode_kendaraan': e.kodeKendaraan ?? '',
                                      'kode_pelanggan': e.kodePelanggan ?? '',
                                      'nama_jenissvc': e.namaService ?? '',
                                      'no_polisi': e.noPolisi ?? '',
                                      'tahun': e.tahun ?? '',
                                      'tahun': e.keluhan ?? '',
                                      'kategori_kendaraan': e
                                          .kategoriKendaraan ?? '',
                                      'kategori_kendaraan_id': kategoriKendaraanId,
                                      'warna': e.warna ?? '',
                                      'ho': e.hp ?? '',
                                      'kode_booking': e.kodeBooking ?? '',
                                      'nama_merk': e.namaMerk ?? '',
                                      'transmisi': e.transmisi ?? '',
                                      'nama_tipe': e.namaTipe ?? '',
                                      'alamat': e.alamat ?? '',
                                      'status': e.bookingStatus ?? '',
                                      'status': e.bookingStatus ?? '',
                                    },
                                  );
                                } else if (e.bookingStatus!.toLowerCase() ==
                                    'dikerjakan' &&
                                    e.namaService!.toLowerCase() !=
                                        'general check up/p2h') {
                                  final generalData = await API.kategoriID();
                                  String kategoriKendaraanId = ''; // Default value

                                  if (generalData != null) {
                                    final matchingKategori = generalData
                                        .dataKategoriKendaraan
                                        ?.firstWhere((kategori) =>
                                    kategori.kategoriKendaraan ==
                                        e.kategoriKendaraan,
                                        orElse: () =>
                                            DataKategoriKendaraan(
                                                kategoriKendaraanId: '',
                                                kategoriKendaraan: ''));
                                    if (matchingKategori != null &&
                                        matchingKategori is DataKategoriKendaraan) {
                                      kategoriKendaraanId = matchingKategori
                                          .kategoriKendaraanId ?? '';
                                    }
                                  }
                                  Get.toNamed(
                                    Routes.REPAIR_MAINTENEN,
                                    arguments: {
                                      'tgl_booking': e.tglBooking ?? '',
                                      'booking_id': e.bookingId.toString(),
                                      'jam_booking': e.jamBooking ?? '',
                                      'nama': e.nama ?? '',
                                      'kategori_kendaraan_id': kategoriKendaraanId,
                                      'kategori_kendaraan': e
                                          .kategoriKendaraan ?? '',
                                      'kode_booking': e.kodeBooking ?? '',
                                      'nama_jenissvc': e.namaService ?? '',
                                      'no_polisi': e.noPolisi ?? '',
                                      'tahun': e.tahun ?? '',
                                      'warna': e.warna ?? '',
                                      'warna': e.keluhan ?? '',
                                      'kode_kendaraan': e.kodeKendaraan ?? '',
                                      'kode_pelanggan': e.kodePelanggan ?? '',
                                      'ho': e.nama ?? '',
                                      'kode_booking': e.kodeBooking ?? '',
                                      'nama_merk': e.namaMerk ?? '',
                                      'transmisi': e.transmisi ?? '',
                                      'nama_tipe': e.namaTipe ?? '',
                                      'alamat': e.alamat ?? '',
                                      'status': e.bookingStatus ?? '',
                                    },
                                  );
                                }
                              } else {
                                // Lakukan penanganan jika status atau namaJenissvc bernilai null
                                print('Status atau namaJenissvc bernilai null');
                              }
                            },
                          ),
                        )
                            .toList(),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text('No data'),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      );
    }

    void _onLoading(String? status) {
      _refreshControllers[_getStatusIndex(status)].loadComplete();
    }

    void _onRefresh(String? status) {
      API.bokingid();
      widget.clearCachedBoking();
      _refreshControllers[_getStatusIndex(status)].refreshCompleted();
    }

    int _getStatusIndex(String? status) {
      switch (status) {
        case 'diproses':
          return 1;
        case 'dikerjakan':
          return 2;
        case 'estimasi':
          return 3;
        case 'selesai dikerjakan':
          return 4;
        case 'Invoice':
          return 5;
        case 'ditolak':
          return 6;
        default:
          return 0; // Semua
      }
    }
  }
