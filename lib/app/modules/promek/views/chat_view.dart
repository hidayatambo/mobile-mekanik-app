
import 'package:flutter/material.dart';
import 'package:mekanik/app/componen/color.dart';

import '../../../componen/loading_cabang_shimmer.dart';
import '../../../data/data_endpoint/profile.dart';
import '../../../data/endpoint.dart';

class PKB extends StatefulWidget {
  const PKB({super.key});

  @override
  State<PKB> createState() => _PKBState();
}

class _PKBState extends State<PKB> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
         title: Column(
           mainAxisAlignment: MainAxisAlignment.start,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
           Text('Estimasi Service', style: TextStyle(color: MyColors.appPrimaryColor, fontWeight: FontWeight.bold),),
           FutureBuilder<Profile>(
             future: API.profileiD(),
             builder: (context, snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                 return const loadcabang();
               } else if (snapshot.hasError) {
                 return const loadcabang();
               } else {
                 if (snapshot.data != null) {
                   final cabang = snapshot.data!.data?.cabang ?? "";
                   return Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(
                         cabang,
                         style: const TextStyle(
                           color: Colors.grey,
                           fontSize: 15.0,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                     ],
                   );
                 } else {
                   return const loadcabang();
                 }
               }
             },
           ),
         ],),
          actions: [
            Icon(
              Icons.search_rounded,
              color: MyColors.appPrimaryColor,
            ),
            SizedBox(width: 20,),
          ],
       ),
    );
  }
}
