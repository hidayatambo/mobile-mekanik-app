import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mekanik/app/componen/color.dart';
import 'package:mekanik/app/data/endpoint.dart';
import 'package:mekanik/app/modules/history/views/history_view.dart';
import 'package:mekanik/app/modules/profile/views/profile_view.dart';

import '../../../data/data_endpoint/boking.dart';
import '../../boking/views/boking_view.dart';
import '../../chat/views/chat_view.dart';
import '../views/home_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Boking? _cachedBoking;

  void clearCachedBoking() {
    setState(() {
      _cachedBoking = null;
    });
  }

  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        items: const [
          CurvedNavigationBarItem(
            child: Icon(
              Icons.home_outlined,
              color: Colors.white,
            ),
            label: 'Home',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
            ),
            label: 'Booking',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.history,
              color: Colors.white,
            ),
            label: 'History',
            labelStyle: TextStyle(color: Colors.white),
          ),
          CurvedNavigationBarItem(
            child: Icon(
              Icons.portrait_outlined,
              color: Colors.white,
            ),
            label: 'Profile',
            labelStyle: TextStyle(color: Colors.white),
          ),
        ],
        color: MyColors.appPrimaryColor,
        buttonBackgroundColor: MyColors.appPrimaryColor,
        backgroundColor: Colors.white,
        animationCurve: Curves.linear,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          HapticFeedback.lightImpact();
          setState(() {
            _page = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          });
        },
        letIndexChange: (index) => true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _page = index;
          });
        },
        children: <Widget>[
          const HomePage(),
          // ChatView(),
          const BokingView(),
          const HistoryView(),
          const ProfileView(),
        ],
      ),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: MyColors.appPrimaryColor,
        ),
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Panggil fungsi notifikasi saat halaman dibangun
//     // Gunakan FutureBuilder untuk memastikan bahwa fungsi notifikasi telah selesai
//     return FutureBuilder(
//       future: API.bokingid(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           // Jika notifikasi telah selesai ditampilkan, tampilkan halaman utama
//           return Scaffold(
//             appBar: AppBar(
//               toolbarHeight: 0,
//               centerTitle: false,
//               systemOverlayStyle: const SystemUiOverlayStyle(
//                 statusBarColor: Colors.transparent,
//                 statusBarIconBrightness: Brightness.dark,
//                 statusBarBrightness: Brightness.light,
//                 systemNavigationBarColor: Colors.white,
//               ),
//             ),
//             body: StatsScreen(),
//           );
//         } else {
//           // Selama proses menampilkan notifikasi, tampilkan loading indicator
//           return Scaffold(
//             appBar: AppBar(
//               toolbarHeight: 0,
//               centerTitle: false,
//               systemOverlayStyle: const SystemUiOverlayStyle(
//                 statusBarColor: Colors.transparent,
//                 statusBarIconBrightness: Brightness.dark,
//                 statusBarBrightness: Brightness.light,
//                 systemNavigationBarColor: Colors.white,
//               ),
//             ),
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
