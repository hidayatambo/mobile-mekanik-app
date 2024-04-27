import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/data_endpoint/general_chackup.dart';
import '../controllers/general_checkup_controller.dart';


class GcuItem extends StatefulWidget {
  final Gcus gcu; // Adjust to your actual type
  final GcuItemState state;

  const GcuItem({Key? key, required this.gcu, required this.state})
      : super(key: key);

  @override
  _GcuItemState createState() => _GcuItemState();
}

class _GcuItemState extends State<GcuItem> {
  String? dropdownValue;

  late TextEditingController textEditingController;
  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    widget.state.dropdownValue = dropdownValue??'';
    widget.state.textEditingController = textEditingController;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 3, // Atur flex untuk Text
                child: Text(
                  widget.gcu.gcu ?? '',
                  textAlign: TextAlign.start, // Atur teks ke sisi kiri
                  overflow: TextOverflow.ellipsis, // Atur overflow agar teks dipotong jika terlalu panjang
                  softWrap: true, // Atur agar teks bisa pindah ke baris berikutnya jika tidak cukup ruang
                ),
              ),
              SizedBox(width: 8), // Berikan sedikit spasi antara teks dan dropdown
              Flexible(
                flex: 1, // Atur flex untuk DropdownButton
                child: DropdownButton<String>(
                  value: dropdownValue,
                  hint: Text('Pilih'),
                  onChanged: (String? value) {
                    setState(() {
                      _handleSubmit();
                      dropdownValue = value!;
                      textEditingController.clear();
                      widget.state.dropdownValue = value;
                    });
                  },
                  items: <String>['Oke', 'Not Oke'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          if (dropdownValue == 'Not Oke')
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: 'Keterangan',
              ),
            ),
        ],
      ),
    );
  }


  void _handleSubmit() {
    if (dropdownValue != null && dropdownValue!.isNotEmpty) {
      Map<String, String> result = {
        'gcu': widget.gcu.gcu ?? '',
        'dropdown': dropdownValue ?? '',
        'textField': textEditingController.text,
      };
    }
  }
}

class GcuItemState {
  late String dropdownValue;
  late TextEditingController textEditingController;
}
