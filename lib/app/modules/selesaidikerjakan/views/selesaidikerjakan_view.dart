import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:get/get.dart';

import '../../../data/data_endpoint/servicedikerjakan.dart';
import '../../../data/endpoint.dart';
import '../componen/list_card_selesai_dikerjakan.dart';
import '../controllers/selesaidikerjakan_controller.dart';

class SelesaidikerjakanView extends GetView<SelesaidikerjakanController> {
  const SelesaidikerjakanView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SelesaidikerjakanView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: API.DikerjakanID(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState !=
                    ConnectionState.waiting &&
                snapshot.data != null) {
              ServiceDikerjakan  getDataAcc =
                  snapshot.data ?? ServiceDikerjakan();
              return Column(
                children: AnimationConfiguration
                    .toStaggeredList(
                  duration:
                  const Duration(milliseconds: 475),
                  childAnimationBuilder: (widget) =>
                      SlideAnimation(
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                  children: getDataAcc.dataDikerjakan !=
                      null
                      ? getDataAcc.dataDikerjakan!
                      .map((e) {
                    return ListSelesaiDikerjakan(
                        items: e,
                      onTap: () {  },
                    );
                  }).toList()
                      : [Container()],
                ),
              );
            } else {
              return SizedBox(
                  height: Get.height - 250,
                  child: SingleChildScrollView(
                    child: Column(children: [
                    ]),)
              );
            }
          },
        ),
      )
    );
  }
}
