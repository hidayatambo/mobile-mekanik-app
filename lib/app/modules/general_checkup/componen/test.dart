// import 'package:flutter/material.dart';
// import '../../../data/data_endpoint/general_chackup.dart';
// import '../../../data/endpoint.dart';
//
// class DummyData extends StatefulWidget {
//   late final Gcus gcu;
//   @override
//   _DummyDataState createState() => _DummyDataState();
// }
//
// class _DummyDataState extends State<DummyData> {
//   List<Map<String, String>> results = [];
//
//   // Move _handleSubmit method here
//   void _handleSubmit() {
//     // Print the collected results
//     Map<String, String> result = {
//       'gcu': widget.gcu.gcu ?? '',
//
//     };
//     print('Submitted Results: $results');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: API.GeneralID(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text('Error: ${snapshot.error}'),
//           );
//         } else if (snapshot.hasData) {
//           final generalData = snapshot.data;
//           final getDataAcc = generalData?.data
//               ?.where((e) => e.subHeading == "Mesin")
//               .toList();
//           if (getDataAcc != null && getDataAcc.isNotEmpty) {
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView(
//                     children: getDataAcc.expand((e) => e.gcus ?? []).map((gcus) {
//                       return GcuItem(
//                         gcu: gcus,
//                         onResult: (result) {
//                           setState(() {
//                             results.add(result);
//                           });
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 // Call _handleSubmit() when the button is pressed
//                 ElevatedButton(
//                   onPressed: _handleSubmit,
//                   child: Text('Submit'),
//                 ),
//               ],
//             );
//           } else {
//             return Center(
//               child: Text('No data available for Stall Test'),
//             );
//           }
//         } else {
//           return Center(
//             child: Text('No data available'),
//           );
//         }
//       },
//     );
//   }
// }
//
// class GcuItem extends StatefulWidget {
//   final Gcus gcu;
//   final Function(Map<String, String>) onResult;
//
//   const GcuItem({Key? key, required this.gcu, required this.onResult}) : super(key: key);
//
//   @override
//   _GcuItemState createState() => _GcuItemState();
// }
//
// class _GcuItemState extends State<GcuItem> {
//   String dropdownValue = 'Oke';
//   TextEditingController textEditingController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             widget.gcu.gcu ?? '',
//             textAlign: TextAlign.start,
//             overflow: TextOverflow.ellipsis,
//             softWrap: true,
//           ),
//           DropdownButton<String>(
//             value: dropdownValue,
//             onChanged: (String? value) {
//               setState(() {
//                 dropdownValue = value!;
//               });
//             },
//             items: <String>['Oke', 'Not Oke']
//                 .map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(value),
//               );
//             })
//                 .toList(),
//           ),
//           if (dropdownValue == 'Not Oke')
//             TextField(
//               controller: textEditingController,
//               decoration: InputDecoration(
//                 hintText: 'Keterangan',
//               ),
//             ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     textEditingController.dispose();
//     super.dispose();
//   }
//
// // Remove _handleSubmit method from here
// }
