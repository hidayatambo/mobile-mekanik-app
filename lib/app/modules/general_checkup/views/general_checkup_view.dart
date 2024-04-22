import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../componen/color.dart';
import '../componen/test.dart';

class GeneralCheckupView extends StatefulWidget {
  const GeneralCheckupView({super.key});

  @override
  _GeneralCheckupViewState createState() => _GeneralCheckupViewState();
}

class _GeneralCheckupViewState extends State<GeneralCheckupView> {
  Map<String, String?> status = {};

  void updateStatus(String key, String? value) {
    setState(() {
      status[key] = value;
    });
  }

  List<String> checkupItems = [
    'Fungsi engine Stop',
    'Jumlah Oli Mesin',
    'Jumlah Air Radiator',
    'Speling Kabel Gas',
    'Sambungan Selang Radiator',
    'Water Separator',
    'Kelenturan Kondisi V-Belt',
    'Kebocoran Oli Air dan Solar',
    'Jumlah & Kualitas Minyak Rem',
    'Speling Pedal Rem & Fungsi Ren',
  ];

  void handleSubmit() {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              for (String checkupItem in status.keys)
                ListTile(
                  title: Text(checkupItem),
                  subtitle: Text(status[checkupItem] ?? ''),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
          systemNavigationBarColor: Colors.white,
        ),
        title: const Text('General Checkup'),
      ),
      body: DetailTemaView()
      // ListView(
      //   children: [
      //     for (String checkupItem in checkupItems)
      //       ListTile(
      //         title: Text(checkupItem),
      //         trailing: DropdownButton<String>(
      //           value: status[checkupItem],
      //           hint: const Text('Select Status'),
      //           onChanged: (String? newValue) {
      //             updateStatus(checkupItem, newValue);
      //           },
      //           items: <String?>['oke', 'not oke'].map((String? value) {
      //             return DropdownMenuItem<String>(
      //               value: value,
      //               child: Text(value ?? ''),
      //             );
      //           }).toList(),
      //         ),
      //       ),
      //     Padding(padding: const EdgeInsets.all(10),child:
      //     ElevatedButton(
      //       style : ElevatedButton.styleFrom(
      //         backgroundColor: MyColors.appPrimaryColor,),
      //       onPressed: handleSubmit,
      //       child: const Text('Submit', style: TextStyle(color: Colors.white),),
      //     ),),
      //   ],
      // ),
    );
  }
}
