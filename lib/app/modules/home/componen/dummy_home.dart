import 'package:flutter/material.dart';
import 'package:mekanik/app/modules/home/componen/stats_grid.dart';
import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';
import 'bar_chart.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dashboard'),
            FutureBuilder<Profile>(
              future: API.profileiD(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.data != null) {
                    final cabang = snapshot.data!.data?.cabang ?? "";
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cabang,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('Tidak ada data');
                  }
                }
              },
            ),
          ],),
        backgroundColor: Colors.white,
      ),
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            sliver: SliverToBoxAdapter(
              child: StatsGrid(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(top: 20.0),
            sliver: SliverToBoxAdapter(
              child: BarChartSample2(),
            ),
          ),
        ],
      ),
    );
  }

  SliverPadding _buildHeader() {
    return const SliverPadding(
      padding: EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          'Statistics',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildRegionTabBar() {
    return SliverToBoxAdapter(
      child: DefaultTabController(
        length: 2,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 50.0,
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }

  SliverPadding _buildStatsTabBar() {
    return const SliverPadding(
      padding: EdgeInsets.all(20.0),
      sliver: SliverToBoxAdapter(
      ),
    );
  }
}