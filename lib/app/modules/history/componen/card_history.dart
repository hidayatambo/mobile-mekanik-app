import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class ProfileApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileScreen();
  }
}

class Job {
  final String title;
  final String vehicle;
  final String client;
  final String date;
  final String status;
  final String mechanic;

  Job({
    required this.title,
    required this.vehicle,
    required this.client,
    required this.date,
    required this.status,
    required this.mechanic,
  });
}

class ProfileScreen extends StatelessWidget {
  final List<Job> jobs = [
    Job(
      title: 'Repair & Maintenance',
      vehicle: 'SX4 S-Cross',
      client: 'DIDIT',
      date: '2024-03-25',
      status: 'Selesai',
      mechanic: 'Riki',
    ),
    Job(
      title: 'Emergency Service',
      vehicle: 'Avanza',
      client: 'RIXKI',
      date: '2024-03-26',
      status: 'Selesai',
      mechanic: 'Perimansyah',
    ),
    Job(
      title: 'General Checkup',
      vehicle: 'Civic',
      client: 'ANDI',
      date: '2024-03-27',
      status: 'Selesai',
      mechanic: 'Mbah Jenggot',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: Column(
        children: AnimationConfiguration.toStaggeredList(
          duration: const Duration(milliseconds: 475),
          childAnimationBuilder: (widget) => SlideAnimation(
            child: FadeInAnimation(
              child: widget,
            ),
          ),
          children: jobs.map((job) {
            return AnimationConfiguration.staggeredList(
              position: jobs.indexOf(job),
              duration: const Duration(milliseconds: 475),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: InkWell(
                    onTap: () {
                      // Get.toNamed(Routes.GENERAL_CHECKUP);
                    },
                    child:
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.car_repair_rounded, color: Colors.blue),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${job.title} - ${job.vehicle}'),
                                          Text(
                                            '${job.status}',
                                            style: TextStyle(color: Colors.green),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${job.client} - ${job.date}',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          Text('Mekanik: ${job.mechanic}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
