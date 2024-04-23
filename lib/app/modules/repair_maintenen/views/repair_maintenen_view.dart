import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';

import '../../../data/data_endpoint/boking.dart';
import '../../../data/endpoint.dart';
import '../../../routes/app_pages.dart';
import '../../boking/views/componen/card_booking.dart';
import '../../general_checkup/componen/card_info.dart';
import '../controllers/repair_maintenen_controller.dart';

class RepairMaintenenView extends GetView<RepairMaintenenController> {
  const RepairMaintenenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Repair Maintenen'),
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
          ),
          leading: IconButton(
            icon: Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(10), child:
          Column(
            children: [
              cardInfo(),
              SizedBox(width: 10,),
              SizedBox(height: 20,),

            ],),),
        )
    );
  }
}