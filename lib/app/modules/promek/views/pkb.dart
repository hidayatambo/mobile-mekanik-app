import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mekanik/app/componen/color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:search_page/search_page.dart';
import '../../../componen/loading_cabang_shimmer.dart';
import '../../../componen/loading_search_shimmer.dart';
import '../../../componen/loading_shammer_booking.dart';
import '../../../data/data_endpoint/pkb.dart';
import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';
import '../../../data/localstorage.dart';
import '../../../routes/app_pages.dart';
import '../componen/card_pkb.dart';

class PKBlist extends StatefulWidget {
  const PKBlist({super.key});

  @override
  State<PKBlist> createState() => _PKBlistState();
}

class _PKBlistState extends State<PKBlist> with AutomaticKeepAliveClientMixin<PKBlist> {
  late RefreshController _refreshController;

  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  Future<void> handleBookingTap(DataPKB e) async {
    Get.toNamed(
      Routes.STARTSTOPPKB,
      arguments: {
        'kode_pkb': e.kodePkb ?? '',
        'no_polisi': e.noPolisi ?? '',
        'tahun': e.tahun ?? '',
        'warna': e.warna ?? '',
        'nama': e.nama ?? '',
        'alamat': e.alamat ?? '',
        'hp': e.hp ?? '',
        'transmisi': e.transmisi ?? '',
        'tipe_svc': e.tipeSvc ?? '',
        'kode_svc': e.kodeSvc ?? '',
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PKB Service', style: TextStyle(color: MyColors.appPrimaryColor, fontWeight: FontWeight.bold)),
            FutureBuilder<Profile>(
              future: API.profileiD(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const loadcabang();
                } else if (snapshot.hasError) {
                  return const loadcabang();
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
                    return const loadcabang();
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          FutureBuilder(
            future: API.PKBID(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: loadsearch(),
                );
              } else if (snapshot.hasData && snapshot.data != null) {
                final data = snapshot.data!.dataPKB;

                if (data != null && data.isNotEmpty) {
                  return InkWell(
                    onTap: () => showSearch(
                      context: context,
                      delegate: SearchPage<DataPKB>(
                        items: data,
                        searchLabel: 'Cari PKB Service',
                        searchStyle: GoogleFonts.nunito(color: Colors.black),
                        showItemsOnEmpty: true,
                        failure: Center(
                          child: Text(
                            'History Tidak Dtemukan :(',
                            style: GoogleFonts.nunito(),
                          ),
                        ),
                        filter: (booking) => [
                          booking.nama,
                          booking.noPolisi,
                          booking.status,
                          booking.createdByPkb,
                          booking.createdBy,
                          booking.tglEstimasi,
                          booking.tipeSvc,
                        ],
                        builder: (items) =>
                            pkblist(items: items,
                                onTap: () {
                                  handleBookingTap(items);
                                }),
                      ),
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: MyColors.appPrimaryColor,
                    ),
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
                  child: loadsearch(),
                );
              }
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: const WaterDropHeader(),
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: API.PKBID(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.connectionState != ConnectionState.waiting && snapshot.data != null) {
                    PKB getDataAcc = snapshot.data ?? PKB();
                    return Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 475),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: getDataAcc.dataPKB != null && getDataAcc.dataPKB!.isNotEmpty
                            ? getDataAcc.dataPKB!.map((e) {
                          return pkblist(
                            items: e,
                            onTap: () {
                              Get.toNamed(
                                Routes.STARTSTOPPKB,
                                arguments: {
                                  'kode_pkb': e.kodePkb ?? '',
                                  'no_polisi': e.noPolisi ?? '',
                                  'tahun': e.tahun ?? '',
                                  'warna': e.warna ?? '',
                                  'nama': e.nama ?? '',
                                  'alamat': e.alamat ?? '',
                                  'hp': e.hp ?? '',
                                  'transmisi': e.transmisi ?? '',
                                  'tipe_svc': e.tipeSvc ?? '',
                                  'kode_svc': e.kodeSvc ?? '',
                                },
                              );
                            },
                          );
                        }).toList()
                            : [Container(
                        height: 500,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/booking.png',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Belum ada data PKB Service',
                              style: TextStyle(
                                  color: MyColors.appPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),],
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: Get.height - 250,
                      child: SingleChildScrollView(
                        child: Loadingshammer(),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onLoading() {
    _refreshController.loadComplete();
  }

  _onRefresh() {
    HapticFeedback.lightImpact();
    setState(() {
      const PKBlist();
      _refreshController.refreshCompleted();
    });
  }

  void logout() {
    LocalStorages.deleteToken();
    Get.offAllNamed(Routes.SIGNIN);
  }
}
