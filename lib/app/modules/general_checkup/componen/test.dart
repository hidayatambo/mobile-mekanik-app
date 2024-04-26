
import 'package:fine_stepper/fine_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../componen/color.dart';
import '../../../data/endpoint.dart';
import '../../approve/componen/card_consument.dart';
import 'card_info.dart';

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
        StepItem.icon(builder: buildMesinStep),
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
          builder: buildMesinStep,
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

  Widget buildMesinStep(BuildContext context) {
    Map<String, ValueNotifier<String>> dropdownValueNotifiers = {};
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
                      'Mesin',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                const cardInfoGC(),
                const SizedBox(height: 20),
                Text('General Checkup', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
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
            child:
                FutureBuilder(
                  future: API.GeneralID(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (snapshot.hasData) {
                      final generalData = snapshot.data;
                      final getDataAcc = generalData?.data
                          ?.where((e) => e.subHeading == "Mesin")
                          .toList();
                      if (getDataAcc != null && getDataAcc.isNotEmpty) {
                        return Column(
                            children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                              final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Container(
                              decoration: BoxDecoration(
                              color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: const EdgeInsets.all(5),
                              padding: EdgeInsets.all(5),
                              child:
                              Row(
                                    children: [
                                      Expanded(
                                        child: Text(gcus.gcu ?? ''),
                                      ),
                                      ValueListenableBuilder<String>(
                                        valueListenable: dropdownValueNotifier,
                                        builder: (context, value, _) {
                                          return DropdownButton<String>(
                                            value: value,
                                            onChanged: (String? newValue) {
                                              dropdownValueNotifier.value = newValue!;
                                            },
                                            items: <String>['Oke', 'Not Oke']
                                                .map<DropdownMenuItem<String>>((String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          );
                                        },
                                      ),
                                    ],
                                  ),),
                                  TextFieldVisibility(
                                    valueNotifier: dropdownValueNotifier,
                                  ),
                                ],
                              );
                            }).toList(),
                        );
                      } else {
                        return const SizedBox(
                          height: 150,
                          child: Center(
                            child: Text('No data available'),
                          ),
                        );
                      }
                    } else {
                      return const SizedBox(
                        height: 150,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),),
                const SizedBox(
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
    Map<String, ValueNotifier<String>> dropdownValueNotifiers = {};
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
                      'Brake',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                const cardInfoGC(),
                const SizedBox(height: 20),
                Text('General Checkup', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
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
                  child:
                  FutureBuilder(
                    future: API.GeneralID(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        final generalData = snapshot.data;
                        final getDataAcc = generalData?.data
                            ?.where((e) => e.subHeading == "Brake")
                            .toList();
                        if (getDataAcc != null && getDataAcc.isNotEmpty) {
                          return Column(
                            children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                              final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(5),
                                    padding: EdgeInsets.all(5),
                                    child:
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''),
                                        ),
                                        ValueListenableBuilder<String>(
                                          valueListenable: dropdownValueNotifier,
                                          builder: (context, value, _) {
                                            return DropdownButton<String>(
                                              value: value,
                                              onChanged: (String? newValue) {
                                                dropdownValueNotifier.value = newValue!;
                                              },
                                              items: <String>['Oke', 'Not Oke']
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),),
                                  TextFieldVisibility(
                                    valueNotifier: dropdownValueNotifier,
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        } else {
                          return const SizedBox(
                            height: 150,
                            child: Center(
                              child: Text('No data available'),
                            ),
                          );
                        }
                      } else {
                        return const SizedBox(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),),
                const SizedBox(
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
    Map<String, ValueNotifier<String>> dropdownValueNotifiers = {};
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
                      'Accel',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                const cardInfoGC(),
                const SizedBox(height: 20),
                Text('General Checkup', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
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
                  child:
                  FutureBuilder(
                    future: API.GeneralID(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        final generalData = snapshot.data;
                        final getDataAcc = generalData?.data
                            ?.where((e) => e.subHeading == "Accel")
                            .toList();
                        if (getDataAcc != null && getDataAcc.isNotEmpty) {
                          return Column(
                            children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                              final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(5),
                                    padding: EdgeInsets.all(5),
                                    child:
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''),
                                        ),
                                        ValueListenableBuilder<String>(
                                          valueListenable: dropdownValueNotifier,
                                          builder: (context, value, _) {
                                            return DropdownButton<String>(
                                              value: value,
                                              onChanged: (String? newValue) {
                                                dropdownValueNotifier.value = newValue!;
                                              },
                                              items: <String>['Oke', 'Not Oke']
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),),
                                  TextFieldVisibility(
                                    valueNotifier: dropdownValueNotifier,
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        } else {
                          return const SizedBox(
                            height: 150,
                            child: Center(
                              child: Text('No data available'),
                            ),
                          );
                        }
                      } else {
                        return const SizedBox(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),),
                const SizedBox(
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
    Map<String, ValueNotifier<String>> dropdownValueNotifiers = {};
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
                      'Interior',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                const cardInfoGC(),
                const SizedBox(height: 20),
                Text('General Checkup', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
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
                  child:
                  FutureBuilder(
                    future: API.GeneralID(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        final generalData = snapshot.data;
                        final getDataAcc = generalData?.data
                            ?.where((e) => e.subHeading == "Interior")
                            .toList();
                        if (getDataAcc != null && getDataAcc.isNotEmpty) {
                          return Column(
                            children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                              final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(5),
                                    padding: EdgeInsets.all(5),
                                    child:
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''),
                                        ),
                                        ValueListenableBuilder<String>(
                                          valueListenable: dropdownValueNotifier,
                                          builder: (context, value, _) {
                                            return DropdownButton<String>(
                                              value: value,
                                              onChanged: (String? newValue) {
                                                dropdownValueNotifier.value = newValue!;
                                              },
                                              items: <String>['Oke', 'Not Oke']
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),),
                                  TextFieldVisibility(
                                    valueNotifier: dropdownValueNotifier,
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        } else {
                          return const SizedBox(
                            height: 150,
                            child: Center(
                              child: Text('No data available'),
                            ),
                          );
                        }
                      } else {
                        return const SizedBox(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),),
                const SizedBox(
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
    Map<String, ValueNotifier<String>> dropdownValueNotifiers = {};
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
                      'Exterior',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                const cardInfoGC(),
                const SizedBox(height: 20),
                Text('General Checkup', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
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
                  child:
                  FutureBuilder(
                    future: API.GeneralID(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        final generalData = snapshot.data;
                        final getDataAcc = generalData?.data
                            ?.where((e) => e.subHeading == "Exterior")
                            .toList();
                        if (getDataAcc != null && getDataAcc.isNotEmpty) {
                          return Column(
                            children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                              final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(5),
                                    padding: EdgeInsets.all(5),
                                    child:
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''),
                                        ),
                                        ValueListenableBuilder<String>(
                                          valueListenable: dropdownValueNotifier,
                                          builder: (context, value, _) {
                                            return DropdownButton<String>(
                                              value: value,
                                              onChanged: (String? newValue) {
                                                dropdownValueNotifier.value = newValue!;
                                              },
                                              items: <String>['Oke', 'Not Oke']
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),),
                                  TextFieldVisibility(
                                    valueNotifier: dropdownValueNotifier,
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        } else {
                          return const SizedBox(
                            height: 150,
                            child: Center(
                              child: Text('No data available'),
                            ),
                          );
                        }
                      } else {
                        return const SizedBox(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),),
                const SizedBox(
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
    Map<String, ValueNotifier<String>> dropdownValueNotifiers = {};
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
                      'Bawah Kendaraan',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                const cardInfoGC(),
                const SizedBox(height: 20),
                Text('General Checkup', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
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
                  child:
                  FutureBuilder(
                    future: API.GeneralID(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        final generalData = snapshot.data;
                        final getDataAcc = generalData?.data
                            ?.where((e) => e.subHeading == "Bawah Kendaraan")
                            .toList();
                        if (getDataAcc != null && getDataAcc.isNotEmpty) {
                          return Column(
                            children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                              final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(5),
                                    padding: EdgeInsets.all(5),
                                    child:
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''),
                                        ),
                                        ValueListenableBuilder<String>(
                                          valueListenable: dropdownValueNotifier,
                                          builder: (context, value, _) {
                                            return DropdownButton<String>(
                                              value: value,
                                              onChanged: (String? newValue) {
                                                dropdownValueNotifier.value = newValue!;
                                              },
                                              items: <String>['Oke', 'Not Oke']
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),),
                                  TextFieldVisibility(
                                    valueNotifier: dropdownValueNotifier,
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        } else {
                          return const SizedBox(
                            height: 150,
                            child: Center(
                              child: Text('No data available'),
                            ),
                          );
                        }
                      } else {
                        return const SizedBox(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),),
                const SizedBox(
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
    Map<String, ValueNotifier<String>> dropdownValueNotifiers = {};
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
                      'Stall Test',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 5),
                const cardInfoGC(),
                const SizedBox(height: 20),
                Text('General Checkup', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
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
                  child:
                  FutureBuilder(
                    future: API.GeneralID(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.hasData) {
                        final generalData = snapshot.data;
                        final getDataAcc = generalData?.data
                            ?.where((e) => e.subHeading == "Stall Test")
                            .toList();
                        if (getDataAcc != null && getDataAcc.isNotEmpty) {
                          return Column(
                            children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
                              final dropdownValueNotifier = dropdownValueNotifiers.putIfAbsent(gcus.gcu!, () => ValueNotifier<String>('Oke'));
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    margin: const EdgeInsets.all(5),
                                    padding: EdgeInsets.all(5),
                                    child:
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(gcus.gcu ?? ''),
                                        ),
                                        ValueListenableBuilder<String>(
                                          valueListenable: dropdownValueNotifier,
                                          builder: (context, value, _) {
                                            return DropdownButton<String>(
                                              value: value,
                                              onChanged: (String? newValue) {
                                                dropdownValueNotifier.value = newValue!;
                                              },
                                              items: <String>['Oke', 'Not Oke']
                                                  .map<DropdownMenuItem<String>>((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ],
                                    ),),
                                  TextFieldVisibility(
                                    valueNotifier: dropdownValueNotifier,
                                  ),
                                ],
                              );
                            }).toList(),
                          );
                        } else {
                          return const SizedBox(
                            height: 150,
                            child: Center(
                              child: Text('No data available'),
                            ),
                          );
                        }
                      } else {
                        return const SizedBox(
                          height: 150,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),),
                const SizedBox(
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

class TextFieldVisibility extends StatefulWidget {
  final ValueNotifier<String> valueNotifier;

  const TextFieldVisibility({super.key,
    required this.valueNotifier,
  });

  @override
  _TextFieldVisibilityState createState() => _TextFieldVisibilityState();
}

class _TextFieldVisibilityState extends State<TextFieldVisibility> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.valueNotifier.value == 'Not Oke',
      child: const Column(
        children: [
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Keterangan',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.valueNotifier.addListener(_updateState);
  }

  @override
  void dispose() {
    widget.valueNotifier.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }
}