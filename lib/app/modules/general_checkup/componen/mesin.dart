import 'package:fine_stepper/fine_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../data/data_endpoint/general_chackup.dart';
import '../../../data/endpoint.dart';
import 'card_info.dart';

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}

class _YourWidgetState extends State<YourWidget> {
  late ValueNotifier<String> dropdownValueNotifier;
  late bool showTextField;

  @override
  void initState() {
    super.initState();
    dropdownValueNotifier = ValueNotifier<String>('Oke');
    showTextField = false;

    dropdownValueNotifier.addListener(() {
      setState(() {
        showTextField = dropdownValueNotifier.value == 'Not Oke';
      });
    });
  }

  @override
  void dispose() {
    dropdownValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                const cardInfoGC(),
                const SizedBox(height: 20,),
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
                      general_checkup? getDataAcc = snapshot.data;
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
                              .map((e) {
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
                                              child: Text(gcus.gcu ?? ''),
                                            ),
                                            DropdownButton<String>(
                                              value: dropdownValueNotifier.value,
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
                                            ),
                                          ],
                                        ),
                                        // Tampilkan TextField hanya jika showTextField true
                                        if (showTextField)
                                          SizedBox(height: 10), // Spasi untuk memisahkan dari DropdownButton
                                        TextField(
                                          decoration: InputDecoration(
                                            labelText: 'Keterangan',
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
                              .toList() ?? [],
                        ),
                      );
                    } else {
                      return SizedBox(
                        height: Get.height - 250,
                        child: const SingleChildScrollView(
                          child: Column(
                            children: [],
                          ),
                        ),
                      );
                    }
                  },
                ),
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
