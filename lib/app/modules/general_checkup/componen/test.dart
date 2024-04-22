
import 'package:fine_stepper/fine_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import '../../../componen/color.dart';
import '../../../data/data_endpoint/boking.dart';
import '../../../data/data_endpoint/general_chackup.dart';
import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';
import '../../../routes/app_pages.dart';
import '../../boking/views/componen/card_booking.dart';
import 'card_general.dart';

class DetailTemaView extends StatefulWidget {
  const DetailTemaView({super.key});

  @override
  State<DetailTemaView> createState() => _DetailTemaViewState();
}

class _DetailTemaViewState extends State<DetailTemaView> {
  int index = 0;


  Widget iconExample() {
    return FineStepper.icon(
      onFinish: () => Future.delayed(const Duration(seconds: 2)),
      indicatorOptions: const IndicatorOptions(scrollable: true),
      steps: [
        StepItem.icon(builder: buildColumnStep),
        StepItem.icon(builder: buildStackStep),
        StepItem.icon(builder: buildFormStep),
        StepItem.icon(builder: buildTanggalAcaraStep),
        StepItem.icon(builder: buildGalleryStep),
        StepItem.icon(builder: buildUcapamStep),
        StepItem.icon(builder: buildStallTestStep),
      ],
    );
  }

  Widget linearExample() {
    return FineStepper.linear(
      onFinish: () => Future.delayed(const Duration(seconds: 2)),
      steps: [
        StepItem.linear(
          title: '',
          description: 'This is a desc',
          builder: buildColumnStep,
        ),
        StepItem.linear(
          title: '',
          builder: buildStackStep,
        ),
        StepItem.linear(
          title: '',
          builder: buildStackStep,
        ),
        StepItem.linear(
          title: '',
          builder: buildTanggalAcaraStep,
        ),
        StepItem.linear(
          title: '',
          builder: buildGalleryStep,
        ),
        StepItem.linear(
          title: '',
          builder: buildUcapamStep,
        ), StepItem.linear(
          title: '',
          builder: buildStallTestStep,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.amber,
          ).copyWith(
            background: Colors.white,
            onBackground: MyColors.appPrimaryColor,
            primary: MyColors.appPrimaryColor,
            onPrimary: Colors.white,
          ),
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              if (index == 0) {
                return iconExample();
              }
              return linearExample();
            },
          ),
        ),
        );
  }
  Widget buildSheetBack() {
    return Container(
        height: 130,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Column(
              children: [
                Text('Anda yakin ingin meninggalkan Pengisian Form Wdding ?',
                    textAlign: TextAlign.center),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    // Get.toNamed(Routes.HOME);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.green),
                    child: const Center(
                      child: Text('Save sebagai Draf',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue),
                    child: const Center(
                      child: Text('Tetap di Sini',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
  Widget buildColumnStep(BuildContext context,) {
    final Map args = Get.arguments;
    final String bookingId = args['id'];
    final String tgl_booking = args['tgl_booking'];
    final String jam_booking = args['jam_booking'];
    final String nama = args['nama'];
    final String nama_jenissvc = args['nama_jenissvc'];
    final String no_polisi = args['no_polisi'];
    final String nama_merk = args['nama_merk'];
    final String nama_tipe = args['nama_tipe'];
    final String status = args['status'];
    String dropdownValue = 'Oke';
    return StepBuilder(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${FineStepper.of(context).stepIndex + 1}  '
                      'Mesin'
                      '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 5,),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: StatusColor.getColor(status),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '$status',
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
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Jenis Service'),
                              Text('$nama_jenissvc', style: const TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: MyColors.appPrimaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: const [
                                      Text('tgl booking :', style: TextStyle(color: Colors.white),),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  '$tgl_booking ',
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
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Merek :'),
                              Text('$nama_merk', style: const TextStyle(fontWeight: FontWeight.bold),),
                              Divider(color: Colors.grey,),
                              const Text('Type :'),
                              Text('$nama_tipe', style: const TextStyle(fontWeight: FontWeight.bold),),
                              Divider(color: Colors.grey,),

                            ],
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: MyColors.appPrimaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    const Text('Jam Booking :',style: TextStyle(color: Colors.white),),
                                    SizedBox(height: 10,),
                                    Text(
                                      '$jam_booking',
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('NoPol :'),
                          Text('$no_polisi', style: const TextStyle(fontWeight: FontWeight.bold),),
                          Divider(color: Colors.grey,),
                          const Text('Pemilik :'),
                          Text('$nama', style: const TextStyle(fontWeight: FontWeight.bold),),
                        ],),
                    ],
                  ),
                ),
                Text('Booking ID: $bookingId'),

                FutureBuilder(
                  future: API.GeneralID(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      general_checkup? getDataAcc = snapshot.data as general_checkup?;
                      return Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 475),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: getDataAcc?.data
                              ?.where((e) => e.subHeading == "Mesin")
                              ?.map((e) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: e.gcus?.map((gcus) {
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(gcus.gcu ?? ''), // Tampilkan gcu dari Gcus
                                            ),
                                            DropdownButton<String>(
                                              value: dropdownValue,
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  dropdownValue = newValue!; // perbarui nilai dropdownValue
                                                });
                                              },
                                              items: <String>['Oke', 'Not Oke']
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        ),
                                        // Tampilkan TextField jika dropdownValue adalah 'Not Oke'
                                        if (dropdownValue == 'Not Oke')
                                          TextField(
                                            decoration: InputDecoration(
                                              labelText: 'Keterangan', // Label untuk TextField
                                              border: OutlineInputBorder(),
                                            ),
                                          ),
                                      ],
                                    );
                                  }).toList() ?? [],
                                ),
                              ],
                            );
                          })
                              ?.toList() ?? [],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: Get.height - 250,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [],
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget buildStackStep(BuildContext context) {
    return StepBuilder(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${FineStepper.of(context).stepIndex + 1}  '
                      'Brake'
                      '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                ),
                FutureBuilder(
                  future: API.GeneralID(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      general_checkup? getDataAcc = snapshot.data as general_checkup?;
                      return Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 475),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: getDataAcc?.data
                              ?.where((e) => e.subHeading == "Brake")
                              ?.map((e) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Step ${FineStepper.of(context).stepIndex + 1} - ${e.subHeading ?? ''}'),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: e.gcus?.map((gcus) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''), // Tampilkan gcu dari Gcus
                                        ),
                                        DropdownButton<String>(
                                          value: 'Oke', // Nilai default dropdown
                                          onChanged: (String? newValue) {
                                            // Tambahkan logika untuk menangani perubahan nilai dropdown di sini
                                          },
                                          items: <String>['Oke', 'Not Oke'] // Opsi dropdown
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  }).toList() ?? [],
                                ),
                              ],
                            );
                          })
                              ?.toList() ?? [],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: Get.height - 250,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [],
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFormStep(BuildContext context) {
    return StepBuilder(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${FineStepper.of(context).stepIndex + 1}  '
                      'Accel'
                      '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                ),
                FutureBuilder(
                  future: API.GeneralID(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      general_checkup? getDataAcc = snapshot.data as general_checkup?;
                      return Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 475),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: getDataAcc?.data
                              ?.where((e) => e.subHeading == "Accel")
                              ?.map((e) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Step ${FineStepper.of(context).stepIndex + 1} - ${e.subHeading ?? ''}'),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: e.gcus?.map((gcus) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''), // Tampilkan gcu dari Gcus
                                        ),
                                        DropdownButton<String>(
                                          value: 'Oke', // Nilai default dropdown
                                          onChanged: (String? newValue) {
                                            // Tambahkan logika untuk menangani perubahan nilai dropdown di sini
                                          },
                                          items: <String>['Oke', 'Not Oke'] // Opsi dropdown
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  }).toList() ?? [],
                                ),
                              ],
                            );
                          })
                              ?.toList() ?? [],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: Get.height - 250,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [],
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTanggalAcaraStep(BuildContext context) {
    return StepBuilder(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${FineStepper.of(context).stepIndex + 1}  '
                      'Interior'
                      '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                ),
                FutureBuilder(
                  future: API.GeneralID(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      general_checkup? getDataAcc = snapshot.data as general_checkup?;
                      return Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 475),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: getDataAcc?.data
                              ?.where((e) => e.subHeading == "Interior")
                              ?.map((e) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Step ${FineStepper.of(context).stepIndex + 1} - ${e.subHeading ?? ''}'),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: e.gcus?.map((gcus) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''), // Tampilkan gcu dari Gcus
                                        ),
                                        DropdownButton<String>(
                                          value: 'Oke', // Nilai default dropdown
                                          onChanged: (String? newValue) {
                                            // Tambahkan logika untuk menangani perubahan nilai dropdown di sini
                                          },
                                          items: <String>['Oke', 'Not Oke'] // Opsi dropdown
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  }).toList() ?? [],
                                ),

                              ],
                            );
                          })
                              ?.toList() ?? [],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: Get.height - 250,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [],
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGalleryStep(BuildContext context) {
    return StepBuilder(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${FineStepper.of(context).stepIndex + 1}  '
                      'Exterior'
                      '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                ),
                FutureBuilder(
                  future: API.GeneralID(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      general_checkup? getDataAcc = snapshot.data as general_checkup?;
                      return Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 475),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: getDataAcc?.data
                              ?.where((e) => e.subHeading == "Exterior")
                              ?.map((e) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Step ${FineStepper.of(context).stepIndex + 1} - ${e.subHeading ?? ''}'),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: e.gcus?.map((gcus) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''), // Tampilkan gcu dari Gcus
                                        ),
                                        DropdownButton<String>(
                                          value: 'Oke', // Nilai default dropdown
                                          onChanged: (String? newValue) {
                                            // Tambahkan logika untuk menangani perubahan nilai dropdown di sini
                                          },
                                          items: <String>['Oke', 'Not Oke'] // Opsi dropdown
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  }).toList() ?? [],
                                ),

                              ],
                            );
                          })
                              ?.toList() ?? [],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: Get.height - 250,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [],
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUcapamStep(BuildContext context) {
    return StepBuilder(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${FineStepper.of(context).stepIndex + 1}  '
                      'Bawah Kendaraan'
                      '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                ),
                FutureBuilder(
                  future: API.GeneralID(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      general_checkup? getDataAcc = snapshot.data as general_checkup?;
                      return Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 475),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: getDataAcc?.data
                              ?.where((e) => e.subHeading == "Bawah Kendaraan")
                              ?.map((e) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Step ${FineStepper.of(context).stepIndex + 1} - ${e.subHeading ?? ''}'),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: e.gcus?.map((gcus) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''), // Tampilkan gcu dari Gcus
                                        ),
                                        DropdownButton<String>(
                                          value: 'Oke', // Nilai default dropdown
                                          onChanged: (String? newValue) {
                                            // Tambahkan logika untuk menangani perubahan nilai dropdown di sini
                                          },
                                          items: <String>['Oke', 'Not Oke'] // Opsi dropdown
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  }).toList() ?? [],
                                ),

                              ],
                            );
                          })
                              ?.toList() ?? [],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: Get.height - 250,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [],
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget buildStallTestStep(BuildContext context) {
    return StepBuilder(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Step ${FineStepper.of(context).stepIndex + 1}  '
                      'Stall Test'
                      '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 17),
                ),
                FutureBuilder(
                  future: API.GeneralID(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      general_checkup? getDataAcc = snapshot.data as general_checkup?;
                      return Column(
                        children: AnimationConfiguration.toStaggeredList(
                          duration: const Duration(milliseconds: 475),
                          childAnimationBuilder: (widget) => SlideAnimation(
                            child: FadeInAnimation(
                              child: widget,
                            ),
                          ),
                          children: getDataAcc?.data
                              ?.where((e) => e.subHeading == "Stall Test")
                              ?.map((e) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text('Step ${FineStepper.of(context).stepIndex + 1} - ${e.subHeading ?? ''}'),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: e.gcus?.map((gcus) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''), // Tampilkan gcu dari Gcus
                                        ),
                                        DropdownButton<String>(
                                          value: 'Oke', // Nilai default dropdown
                                          onChanged: (String? newValue) {
                                            // Tambahkan logika untuk menangani perubahan nilai dropdown di sini
                                          },
                                          items: <String>['Oke', 'Not Oke'] // Opsi dropdown
                                              .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    );
                                  }).toList() ?? [],
                                ),

                              ],
                            );
                          })
                              ?.toList() ?? [],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: Get.height - 250,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [],
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),

              ],
            ),
          ),
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