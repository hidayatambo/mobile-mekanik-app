import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mekanik/app/data/publik.dart';
import '../routes/app_pages.dart';
import 'data_endpoint/boking.dart';
import 'data_endpoint/general_chackup.dart';
import 'data_endpoint/login.dart';
import 'data_endpoint/profile.dart';
import 'localstorage.dart';

class API {
  static const _url = 'https://mobile.techthinkhub.id';
  static const _urlbe = 'https://be.techthinkhub.id';
  static const _baseUrl = '$_url/api';
  static const _getProfile = '$_baseUrl/mekanik/profile-karyawan';
  static const _getLogin = '$_baseUrl/mekanik/login';
  static const _getTooking = '$_baseUrl/mekanik/booking';
  static const _getGeneral = '$_baseUrl/mekanik/general-checkup';


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
}
