import 'package:get/get.dart';

import '../modules/boking/bindings/boking_binding.dart';
import '../modules/boking/views/boking_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/general_checkup/bindings/general_checkup_binding.dart';
import '../modules/general_checkup/views/general_checkup_view.dart';
import '../modules/history/bindings/history_binding.dart';
import '../modules/history/views/history_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/componen/buttomnavigationbar.dart';
import '../modules/home/views/home_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/signin/bindings/signin_binding.dart';
import '../modules/signin/views/signin_view.dart';
import '../modules/splashcreen/bindings/splashcreen_binding.dart';
import '../modules/splashcreen/views/splashcreen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHCREEN;

  static final routes = [
    GetPage(
      transition: Transition.zoom,
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SIGNIN,
      page: () => const SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: _Paths.BOKING,
      page: () => const BokingView(),
      binding: BokingBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      transition: Transition.rightToLeft,
      name: _Paths.GENERAL_CHECKUP,
      page: () => GeneralCheckupView(),
      binding: GeneralCheckupBinding(),
    ),
    GetPage(
      transition: Transition.zoom,
      name: _Paths.SPLASHCREEN,
      page: () => SplashcreenView(),
      binding: SplashcreenBinding(),
    ),
  ];
}
