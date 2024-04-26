import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/general_checkup_controller.dart';

class TextFieldVisibilitykendaraan extends StatefulWidget {
  final ValueNotifier<String> valueNotifier;

  const TextFieldVisibilitykendaraan({super.key,
    required this.valueNotifier,
  });

  @override
  _TextFieldVisibilitykendaraanState createState() => _TextFieldVisibilitykendaraanState();
}

class _TextFieldVisibilitykendaraanState extends State<TextFieldVisibilitykendaraan> {
  final controller = Get.put(GeneralCheckupController());
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.valueNotifier.value == 'Not Oke',
      child: Column(
        children: [
          SizedBox(height: 10),
          TextField(
            controller: controller.kendaraanController,
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