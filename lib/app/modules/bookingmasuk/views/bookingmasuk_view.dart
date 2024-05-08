import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:get/get.dart';

import '../../../data/data_endpoint/bookingmasuk.dart';
import '../../../data/endpoint.dart';
import '../componen/list_card_booking_masuk.dart';
import '../controllers/bookingmasuk_controller.dart';

class BookingmasukView extends GetView<BookingmasukController> {
  const BookingmasukView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookingmasukView'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: API.BookingMasukID(),
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState !=
                    ConnectionState.waiting &&
                snapshot.data != null) {
              MasukBooking  getDataAcc =
                  snapshot.data ?? MasukBooking();
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
                  children: getDataAcc.bookingMasuk !=
                      null
                      ? getDataAcc.bookingMasuk!
                      .map((e) {
                    return ListBookingMasuk(
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
