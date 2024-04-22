import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mekanik/app/componen/color.dart';
import '../../../../data/data_endpoint/boking.dart';
import '../../../../routes/app_pages.dart';

class BokingList extends StatelessWidget {
  final DataBooking items;

  const BokingList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    Color statusColor = StatusColor.getColor(items.status!);

    return InkWell(
      onTap: () async {
        switch (items.status!.toLowerCase()) {
          case 'diproses':
            Get.toNamed(Routes.GENERAL_CHECKUP);
            break;
          case 'dikerjakan':
            Get.toNamed(Routes.GENERAL_CHECKUP);
            break;
          case 'estimasi':
            showModalBottomSheet(
              enableDrag: true,
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: const Center(
                    child: Text('Harus Diproses/Dikerjakan dahulu untuk melanjutkan proses GENERAL CHECKUP', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                );
              },
            );
            break;
          case 'selesai dikerjakan':
            showModalBottomSheet(
              enableDrag: true,
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: const Center(
                    child: Text('Sudah Selesai dikerjakan tidak bisa GENERAL CHECKUP lagi', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            );
            break;
          case 'invoice':
            Get.toNamed(Routes.GENERAL_CHECKUP);
            // showModalBottomSheet(
            //   enableDrag: true,
            //   context: context,
            //   builder: (context) {
            //     return Container(
            //       padding: const EdgeInsets.all(10),
            //       height: 100,
            //       child: const Center(
            //         child: Text('Sudah Invoice tidak bisa GENERAL CHECKUP lagi', style: TextStyle(fontWeight: FontWeight.bold)),
            //       ),
            //     );
            //   },
            // );
            break;
          case 'ditolak':
            showModalBottomSheet(
              enableDrag: true,
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: const Center(
                    child: Text('Sudah Ditolak tidak bisa GENERAL CHECKUP lagi', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            );
            break;
          case 'ditolak by sistem':
            showModalBottomSheet(
              enableDrag: true,
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: const Center(
                    child: Text('Sudah ditolak by sistem tidak bisa GENERAL CHECKUP lagi', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            );
            break;
          default:
            showModalBottomSheet(
              enableDrag: true,
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  height: 100,
                  child: const Center(
                    child: Text('Harus Diproses dahulu untuk melanjutkan proses GENERAL CHECKUP', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                );
              },
            );
            break;
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Jenis Service'),
                    Text(items.namaJenissvc!.toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                Column(
                  children: [
                    const Text('Jam Booking :'),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: MyColors.appPrimaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            items.jamBooking!.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Merek :'),
                    Text(items.namaMerk!.toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                    const Text('Type :'),
                    Text(items.namaTipe!.toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                    const Text('NoPol :'),
                    Text(items.noPolisi!.toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                    const Text('Pemilik :'),
                    Text(items.nama!.toString(), style: const TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: const [
                          Text('Status :'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            items.status!.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusColor {
  static Color getColor(String status) {
    switch (status.toLowerCase()) {
      case 'diproses':
        return Colors.orange;
      case 'estimasi':
        return Colors.lime;
      case 'dikerjakan':
        return Colors.orange;
      case 'invoice':
        return Colors.blue;
      case 'ditolak by sistem':
        return Colors.red;
      case 'ditolak':
        return Colors.red;
      case 'selesai dikerjakan':
        return Colors.green;
      default:
        return Colors.transparent;
    }
  }
}
