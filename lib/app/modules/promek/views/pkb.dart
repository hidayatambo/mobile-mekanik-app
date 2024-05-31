import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:mekanik/app/componen/color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../componen/loading_cabang_shimmer.dart';
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
          Icon(
            Icons.search_rounded,
            color: MyColors.appPrimaryColor,
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
                        children: getDataAcc.dataPKB != null
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
                            : [Container()],
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
