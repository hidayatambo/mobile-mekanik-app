import 'package:flutter/material.dart';
import '../../../data/data_endpoint/general_chackup.dart';

class CardGeneral extends StatelessWidget {
  final Data items;
  const CardGeneral({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.subHeading == "Mesin") {
      return Text(items.subHeading!);
    } else {
      return SizedBox.shrink();
    }
  }
}
