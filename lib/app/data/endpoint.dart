import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mekanik/app/data/publik.dart';
import '../routes/app_pages.dart';
import 'data_endpoint/approve.dart';
import 'data_endpoint/boking.dart';
import 'data_endpoint/estimasi.dart';
import 'data_endpoint/gc_mekanik.dart';
import 'data_endpoint/general_chackup.dart';
import 'data_endpoint/history.dart';
import 'data_endpoint/kategory.dart';
import 'data_endpoint/login.dart';
import 'data_endpoint/mekanik.dart';
import 'data_endpoint/profile.dart';
import 'data_endpoint/submit_finish.dart';
import 'data_endpoint/submit_gc.dart';
import 'data_endpoint/unapprove.dart';
import 'localstorage.dart';

class API {
  static const _url = 'https://mobile.techthinkhub.id';
  static const _urlbe = 'https://be.techthinkhub.id';
  static const _baseUrl = '$_url/api';
  static const _getProfile = '$_baseUrl/mekanik/profile-karyawan';
  static const _getLogin = '$_baseUrl/mekanik/login';
  static const _getTooking = '$_baseUrl/mekanik/booking';
  static const _getGeneral = '$_baseUrl/mekanik/general-checkup';
  static const _getMekanik = '$_baseUrl/mekanik/get-mekanik';
  static const _postApprovek = '$_baseUrl/mekanik/approve-booking';
  static const _postUpprovek = '$_baseUrl/mekanik/unapprove-booking';
  static const _postSubmitGC = '$_baseUrl/mekanik/submit-general-checkup';
  static const _postestimasi = '$_baseUrl/mekanik/insert-estimasi';
  static const _postSubmitGCFinish = '$_baseUrl/mekanik/submit-general-checkup-finish';
  static const _gethistory = '$_baseUrl/mekanik/get-history-mekanik';
  static const _getKategory = '$_baseUrl/mekanik/kategori-kendaraan';
  static const _getGCMekanik = '$_baseUrl/mekanik/general-checkup-mekanik';
  static final _controller = Publics.controller;


  static Future<Token> login({required String email, required String password}) async {
    final data = {
      "email": email,
      "password": password,
    };
    try {
      var response = await Dio().post(
        _getLogin,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            // 'Cookie': 'PHPSESSID=4p7dvd8adhtocikl945vpcb991'
          },
        ),
        data: data,
      );
      if (response.statusCode == 200) {
        final responseData = response.data;
        final obj = Token.fromJson(responseData);
        if (obj.message == 'Invalid token: Expired') {
          Get.offAllNamed(Routes.SIGNIN);
        } else {
          if (obj.message != 0) {
            if (obj.token != null) {
              LocalStorages.setToken(obj.token ?? ''); // Gunakan nilai default jika obj.token null
              Get.snackbar('Selamat Datang', 'Menkanik Bengkelly');
              Get.offAllNamed(Routes.HOME);
            } else {
              Get.snackbar('Error', 'Kode Perusahaan tidak ditemukan',
                  backgroundColor: const Color(0xffe5f3e7));
            }
          } else {
            Get.snackbar('Error', 'Gagal melakukan login',
                backgroundColor: const Color(0xffe5f3e7));
          }
        }
        print(obj.toJson());
        return obj;
      } else {
        throw Exception('Failed to load data, status code: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

//beda


  static Future<Profile> profileiD() async {
    final token = Publics.controller.getToken.value ?? '';
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _getProfile,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        return Profile(status: false, message: "Tidak ada data booking untuk karyawan ini.");
      }

      final obj = Profile.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      throw e;
    }
  }

//beda
  static Future<Boking> bokingid() async {
    try {
      final token = Publics.controller.getToken.value ?? '';
      var data = {"token": token};
      var response = await Dio().get(
        _getTooking,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        return Boking(status: false, message: "Tidak ada data booking untuk karyawan ini.");
      }

      final obj = Boking.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }

  //Beda
  static Future<general_checkup> GeneralID() async {
    final token = Publics.controller.getToken.value ?? '';
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _getGeneral,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = general_checkup.fromJson(response.data);

      if (obj.data == null) {
        throw Exception("Data general checkup kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }

  //Beda
  static Future<Approve> approveId({
    required String email,
    required String kodeBooking,
    required String tglBooking,
    required String jamBooking,
    required String odometer,
    required String pic,
    required String hpPic,
    required String kodeMembership,
    required String kodePaketmember,
    required String tipeSvc,
    required String tipePelanggan,
    required String referensi,
    required String referensiTmn,
    required String paketSvc,
    required String keluhan,
    required String perintahKerja,
    required int ppn,
  }) async {
    final data = {
      "email": email,
      "kode_booking": kodeBooking,
      "tgl_booking": tglBooking,
      "jam_booking": jamBooking,
      "odometer": odometer,
      "pic": pic,
      "hp_pic": hpPic,
      "kode_membership": kodeMembership,
      "kode_paketmember": kodePaketmember,
      "tipe_svc": tipeSvc,
      "tipe_pelanggan": tipePelanggan,
      "referensi": referensi,
      "referensi_teman": referensiTmn,
      "paket_svc": paketSvc,
      "keluhan": keluhan,
      "perintah_kerja": perintahKerja,
      "ppn": ppn,
    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token'); // Cetak token untuk memeriksa kevalidan

      var response = await Dio().post(
        _postApprovek,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}'); // Cetak respons untuk memeriksa tanggapan dari server

      final obj = Approve.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e'); // Cetak kesalahan jika terjadi
      throw e;
    }
  }
  //Beda
  static Future<Unapprove> unapproveId({
    required String catatan,
    required String kodeBooking,
  }) async {
    final data = {
      "catatan": catatan,
      "kode_booking": kodeBooking,

    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token'); // Cetak token untuk memeriksa kevalidan

      var response = await Dio().post(
        _postUpprovek,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}'); // Cetak respons untuk memeriksa tanggapan dari server

      final obj = Unapprove.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e'); // Cetak kesalahan jika terjadi
      throw e;
    }
  }
  //Beda
  static Future<Mekanik> MekanikID() async {
    final token = Publics.controller.getToken.value ?? '';
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _getMekanik,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = Mekanik.fromJson(response.data);

      if (obj.message == null) {
        throw Exception("Data Mekanik kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
  //Beda

//Beda
  static Future<Estimasi> estimasiId({
    required String kodeBooking,
    required String kodePelanggan,
    required String kodeKendaraan,
    required String tglBooking,
    required String jamBooking,
    required String odometer,
    required String pic,
    required String hpPic,
    required String kodeMembership,
    required String kodePaketmember,
    required String tipeSvc,
    required String tipePelanggan,
    required String referensi,
    required String referensiTmn,
    required String paketSvc,
    required String keluhan,
    required String perintahKerja,
    required int ppn,
  }) async {
    final data = {
      "kode_booking": kodeBooking,
      "kode_pelanggan": kodePelanggan,
      "kode_kendaraan": kodeKendaraan,
      "tgl_booking": tglBooking,
      "jam_booking": jamBooking,
      "odometer": odometer,
      "pic": pic,
      "hp_pic": hpPic,
      "kode_membership": kodeMembership,
      "kode_paketmember": kodePaketmember,
      "tipe_svc": tipeSvc,
      "tipe_pelanggan": tipePelanggan,
      "referensi": referensi,
      "referensi_teman": referensiTmn,
      "paket_svc": paketSvc,
      "keluhan": keluhan,
      "perintah_kerja": perintahKerja,
      "ppn": ppn,
    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token'); // Cetak token untuk memeriksa kevalidan

      var response = await Dio().post(
        _postestimasi,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}'); // Cetak respons untuk memeriksa tanggapan dari server

      final obj = Estimasi.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e'); // Cetak kesalahan jika terjadi
      throw e;
    }
  }

//Beda
  static Future<SubmitGC> submitGCID({
    required Map<String, dynamic> generalCheckup,
  }) async {
    try {
      final token = await Publics.controller.getToken.value;
      print('Token: $token');

      final response = await Dio().post(
        _postSubmitGC,
        data: generalCheckup,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}'); // Cetak respons untuk memeriksa tanggapan dari server

      if (response.statusCode == 200) {
        final data = response.data;
        final submitGCData = SubmitGC.fromJson(data);
        return submitGCData;
      } else {
        // Tangani respon yang tidak sesuai dengan harapan
        throw Exception('Failed to submit general checkup');
      }
    } catch (e) {
      print('Error: $e'); // Cetak kesalahan jika terjadi
      throw e;
    }
  }
  //Beda
  static Future<Gcfinish> submitGCFinishId({
    required String bookingId,
  }) async {
    final data = {
      "booking_id": bookingId,

    };

    try {
      final token = Publics.controller.getToken.value ?? '';
      print('Token: $token'); // Cetak token untuk memeriksa kevalidan

      var response = await Dio().post(
        _postSubmitGCFinish,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}'); // Cetak respons untuk memeriksa tanggapan dari server

      final obj = Gcfinish.fromJson(response.data);

      if (obj.message == 'Invalid token: Expired') {
        Get.offAllNamed(Routes.SIGNIN);
        Get.snackbar(
          obj.message.toString(),
          obj.message.toString(),
        );
      }
      return obj;
    } catch (e) {
      print('Error: $e'); // Cetak kesalahan jika terjadi
      throw e;
    }
  }
  //beda
  static Future<History> HistoryID() async {
    final token = Publics.controller.getToken.value;
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _gethistory,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = History.fromJson(response.data);

      if (obj.dataHistory == null) {
        throw Exception("Data general checkup kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
//Beda
  static Future<Kategori> kategoriID() async {
    final token = Publics.controller.getToken.value;
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _getKategory,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        queryParameters: data,
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = Kategori.fromJson(response.data);

      if (obj.dataKategoriKendaraan == null) {
        throw Exception("Data general checkup kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
  static Future<GCMekanik> GCMekanikID({
    required String kategoriKendaraanId,
  }) async {
    final token = Publics.controller.getToken.value;
    var data = {
      "kategori_kendaraan_id": kategoriKendaraanId,
    };
    try {
      var response = await Dio().get(
        _getGCMekanik,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token", // Menambahkan token dalam header
          },
        ),
      );

      if (response.statusCode == 404) {
        throw Exception("Tidak ada data general checkup.");
      }

      final obj = GCMekanik.fromJson(response.data);

      if (obj.dataGeneralCheckUp == null) {
        throw Exception("Data general checkup kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }


}
