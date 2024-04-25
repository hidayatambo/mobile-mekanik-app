import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ApproveController extends GetxController {
  //TODO: Implement ApproveController
  late String id;
  late String tglBooking;
  late String jamBooking;
  late String nama;
  late String namaJenissvc;
  late String noPolisi;
  late String namaMerk;
  late String namaTipe;
  late String status;
  final TextEditingController odometer = TextEditingController(text: '');
  final TextEditingController catatan = TextEditingController();
  final TextEditingController mekanik = TextEditingController();

  void setData({
    required String id,
    required String tglBooking,
    required String jamBooking,
    required String nama,
    required String namaJenissvc,
    required String noPolisi,
    required String namaMerk,
    required String namaTipe,
    required String status,
    required String catatan,
  }) {
    this.id = id;
    this.tglBooking = tglBooking;
    this.jamBooking = jamBooking;
    this.nama = nama;
    this.namaJenissvc = namaJenissvc;
    this.noPolisi = noPolisi;
    this.namaMerk = namaMerk;
    this.namaTipe = namaTipe;
    this.status = status;
    this.status = catatan;
  }
  final count = 0.obs;
  late TextEditingController idController;
  late TextEditingController tglBookingController;
  late TextEditingController jamBookingController;
  late TextEditingController namaController;
  late TextEditingController namaJenissvcController;
  late TextEditingController noPolisiController;
  late TextEditingController namaMerkController;
  late TextEditingController namaTipeController;
  late TextEditingController statusController;
  late TextEditingController tanggalController;
  late TextEditingController jamController;

  @override
  void onInit() {
  super.onInit();
  idController = TextEditingController();
  tglBookingController = TextEditingController();
  jamBookingController = TextEditingController();
  namaController = TextEditingController();
  namaJenissvcController = TextEditingController();
  noPolisiController = TextEditingController();
  namaMerkController = TextEditingController();
  namaTipeController = TextEditingController();
  statusController = TextEditingController();
  tanggalController = TextEditingController();
  jamController = TextEditingController();
  }

  @override
  void onClose() {
  idController.dispose();
  tglBookingController.dispose();
  jamBookingController.dispose();
  namaController.dispose();
  namaJenissvcController.dispose();
  noPolisiController.dispose();
  namaMerkController.dispose();
  namaTipeController.dispose();
  statusController.dispose();
  catatan.dispose();
  super.onClose();
  }

  void increment() => count.value++;
}
