import 'dart:convert';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mekanik/app/data/publik.dart';
import '../routes/app_pages.dart';
import 'data_endpoint/approve.dart';
import 'data_endpoint/boking.dart';
import 'data_endpoint/general_chackup.dart';
import 'data_endpoint/login.dart';
import 'data_endpoint/mekanik.dart';
import 'data_endpoint/profile.dart';
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
  static const _getApprovek = '$_baseUrl/mekanik/approve-booking';
  static const _getUpprovek = '$_baseUrl/mekanik/unapprove-booking';
  static const _getSubmitGC = '$_baseUrl/mekanik/submit-general-checkup';
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
              LocalStorages.setToken(obj.token ?? '');
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
  static Profile? _cachedProfile;
  static Future<Profile> get profile async {
    if (_cachedProfile != null) {
      return _cachedProfile!;
    }

    final token = Publics.controller.getToken.value;
    var data = {"token": token};
    try {
      var response = await Dio().get(
        _getProfile,
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
        data: data,
      );

      final obj = Profile.fromJson(response.data);
      _cachedProfile = obj;

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
  static Boking? _cachedBoking;
  static void clearCachedBoking() {
    _cachedBoking = null;
  }
  static Future<Boking> bokingid() async {
    if (_cachedBoking != null) {
      return _cachedBoking!;
    }

    final token = Publics.controller.getToken.value;
    var data = {"token": token};
    try {
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
      _cachedBoking = obj;

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
  static general_checkup? _cachedGeneral;

  static void clearCacheGeneral() {
    _cachedGeneral = null;
  }

  static Future<general_checkup> GeneralID() async {
    if (_cachedGeneral != null) {
      return _cachedGeneral!;
    }

    final token = Publics.controller.getToken.value;
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
      _cachedGeneral = obj;

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
      final token = await Publics.controller.getToken.value;
      print('Token: $token'); // Cetak token untuk memeriksa kevalidan

      var response = await Dio().post(
        _getApprovek,
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
  static Future<Unapprove> unapproveId({
    required String catatan,
    required String kodeBooking,
  }) async {
    final data = {
      "catatan": catatan,
      "kode_booking": kodeBooking,

    };

    try {
      final token = await Publics.controller.getToken.value;
      print('Token: $token'); // Cetak token untuk memeriksa kevalidan

      var response = await Dio().post(
        _getUpprovek,
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
  static Mekanik? _cachedMekanik;

  static void clearCacheMekanik() {
    _cachedMekanik = null;
  }

  static Future<Mekanik> MekanikID() async {
    if (_cachedMekanik != null) {
      return _cachedMekanik!;
    }

    final token = Publics.controller.getToken.value;
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
      _cachedMekanik = obj;

      if (obj.message == null) {
        throw Exception("Data Mekanik kosong.");
      }

      return obj;
    } catch (e) {
      throw e;
    }
  }
  //Beda
  static Future<SubmitGC> submitGCID({
    required String bookingid,
    required String subheadingid,
    required String gcuid,
    required String status,
    required String description,
  }) async {
    final data = {
    'booking_id': bookingid,
    'sub_heading_id': subheadingid,
    'gcu_id': gcuid,
    'status': status,
    'description': description,
    };

    try {
      final token = await Publics.controller.getToken.value;
      print('Token: $token'); // Cetak token untuk memeriksa kevalidan

      var response = await Dio().post(
        _getSubmitGC,
        data: data,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      print('Response: ${response.data}'); // Cetak respons untuk memeriksa tanggapan dari server

      final obj = SubmitGC.fromJson(response.data);

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
}
