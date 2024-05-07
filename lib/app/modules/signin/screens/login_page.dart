import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mekanik/app/componen/color.dart';
import '../../../data/data_endpoint/login.dart';
import '../../../data/endpoint.dart';
import '../../../data/localstorage.dart';
import '../../../routes/app_pages.dart';
import '../common/common.dart';
import '../widgets/custom_widget.dart';
import 'fade_animationtest.dart';
import 'forget_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscureText = true;
  late TextEditingController _passwordController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void togglePasswordVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  bool flag = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FadeInAnimation(
                          delay: 1.3,
                          child: Text(
                            "Selamat Datang",
                            style: Common().titelTheme,
                          ),
                        ),
                        FadeInAnimation(
                          delay: 1.6,
                          child: Text(
                            "Bengkelly!!",
                            style: Common().titelTheme,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      child: Column(
                        children: [
                          FadeInAnimation(
                            delay: 1.9,
                            child: CustomTextFormField(
                              hinttext: 'Masukkan email Anda',
                              obsecuretext: false,
                              controller: _emailController, // Tambahkan controller untuk TextFormField
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FadeInAnimation(
                            delay: 2.2,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(18),
                                hintText: "Masukkan kata sandi Anda",
                                hintStyle: Common().hinttext,
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                suffixIcon: IconButton(
                                  onPressed: togglePasswordVisibility,
                                  icon: Icon(
                                    obscureText ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          FadeInAnimation(
                            delay: 2.5,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Get.to(const ForgetPasswordPage());
                                },
                                child: Text(
                                  "",
                                  style: Common().semiboldblack,
                                ),
                              ),
                            ),
                          ),
                          FadeInAnimation(
                            delay: 2.8,
                            child: CustomElevatedButton(
                              message: "Masuk",
                              function: () async {
                                if (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
                                  try {
                                    Token aksesPX = await API.login(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    );

                                    if (aksesPX.status != false) {
                                      if (aksesPX.token != null) {
                                        // await LocalStorages.deleteToken();
                                        Get.offAllNamed(Routes.HOME);
                                      }
                                    } else {
                                      // Menampilkan pesan kesalahan sesuai dengan respons server
                                      String errorMessage = aksesPX.message ?? 'Terjadi kesalahan saat login';
                                      Object errorDetail = aksesPX.data ?? '';
                                      Get.snackbar('Error', '$errorMessage: $errorDetail');
                                    }
                                  } catch (e) {
                                    // Menampilkan pesan kesalahan saat terjadi error
                                    print('Error during login: $e');
                                    Get.snackbar('Gagal Login', 'Terjadi kesalahan saat login');
                                  }
                                } else {
                                  Get.snackbar('Gagal Login', 'Username dan Password harus diisi');
                                }

                                setState(() {
                                  flag = !flag;
                                });

                              },

                              color: MyColors.appPrimaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
