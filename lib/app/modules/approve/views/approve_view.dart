import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mekanik/app/componen/color.dart';
import 'package:search_choices/search_choices.dart';
import '../../../data/data_endpoint/mekanik.dart';
import '../../../data/endpoint.dart';
import '../../../routes/app_pages.dart';
import '../../general_checkup/componen/card_info.dart';
import '../../general_checkup/views/general_checkup_view.dart';
import '../controllers/approve_controller.dart';

class ApproveView extends GetView<GetxController> {
  const ApproveView({super.key});
  void approveBooking(Map<String, dynamic> arguments) {
    // Lakukan logika untuk menyetujui booking di sini
    // Anda dapat mengakses argumen menggunakan arguments['namaArgumen']
    String id = arguments['id'];
    String tglBooking = arguments['tgl_booking'];
    String nama_jenissvc = arguments['nama_jenissvc'];
    // Dan seterusnya untuk argumen lainnya

    // Contoh tindakan:
    print('Menyetujui booking dengan ID: $id, Tanggal: $tglBooking, nama_jenissvc: $nama_jenissvc');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Approve'),
          centerTitle: true,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
          ),
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(10),child:
          Column(
            children: [
            const cardInfo(),
            const SizedBox(width: 10,),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Map<String, dynamic>? arguments = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

                    if (arguments != null) {
                      // Periksa jenis layanan, jika "General Check UP/P2H", arahkan ke GeneralCheckupView()
                      if (arguments['nama_jenissvc'] == 'General Check UP/P2H') {
                        ApproveController controller = Get.put(ApproveController());
                        controller.setData(
                          id: arguments['id'],
                          tglBooking: arguments['tgl_booking'],
                          jamBooking: arguments['jam_booking'],
                          nama: arguments['nama'],
                          namaJenissvc: arguments['nama_jenissvc'],
                          noPolisi: arguments['no_polisi'],
                          namaMerk: arguments['nama_merk'],
                          namaTipe: arguments['nama_tipe'],
                          status: arguments['status'],
                        );
                        _showBottomSheet(context, arguments);
                        // Navigator.pushNamed(
                        //   context,
                        //   Routes.GENERAL_CHECKUP,
                        //   arguments: {
                        //     'id': arguments['id'],
                        //     'tgl_booking': arguments['tgl_booking'],
                        //     'jam_booking': arguments['jam_booking'],
                        //     'nama': arguments['nama'],
                        //     'nama_jenissvc': arguments['nama_jenissvc'],
                        //     'no_polisi': arguments['no_polisi'],
                        //     'nama_merk': arguments['nama_merk'],
                        //     'nama_tipe': arguments['nama_tipe'],
                        //     'status': arguments['status'],
                        //   },
                        // );
                      } else {
                        // Jika bukan "General Check UP/P2H", lakukan logika persetujuan yang lain
                        // Get.toNamed(Routes.HOME);
                        Navigator.pop(context);
                        // Navigator.pushNamed(
                        //   context,
                        //   Routes.HOME,
                        //   arguments: {
                        //     'id': arguments['id'],
                        //     'tgl_booking': arguments['tgl_booking'],
                        //     'jam_booking': arguments['jam_booking'],
                        //     'nama': arguments['nama'],
                        //     'nama_jenissvc': arguments['nama_jenissvc'],
                        //     'no_polisi': arguments['no_polisi'],
                        //     'nama_merk': arguments['nama_merk'],
                        //     'nama_tipe': arguments['nama_tipe'],
                        //     'status': arguments['status'],
                        //   },
                        // );
                      }
                    } else {
                      // Handle kasus ketika arguments null
                      print('Error: Arguments tidak diterima');
                      // Atau lakukan tindakan lain sesuai kebutuhan aplikasi Anda
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 4.0,
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),


                const SizedBox(width: 10,),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 4.0,
                ),
                child: const Text('Unapprove',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
            const SizedBox(width: 10,),
            ElevatedButton(
                onPressed: () {
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 4.0,
                ),
                child: const Text('Cancel',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),],),
          ],),),
        )
    );
  }
  // Fungsi untuk menampilkan BottomSheet
  void _showBottomSheet(BuildContext context, Map<String, dynamic> arguments) {
    ApproveController bottomSheetController = Get.put(ApproveController());
    bottomSheetController.tglBookingController.text = arguments['tgl_booking'] ?? '';
    bottomSheetController.jamBookingController.text = arguments['jam_booking'] ?? '';
    bottomSheetController.tanggalController.text;
    bottomSheetController.jamController.text;

    showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Ingin ubah tanggal dan jam booking ?',style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                GestureDetector(
                  onTap: () {
                    _showDatePicker(context, bottomSheetController); // Panggil fungsi untuk menampilkan bottom picker
                  },
                  child: AbsorbPointer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Tanggal Booking'),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.only(left: 25, right: 20),
                      margin: const EdgeInsets.fromLTRB(10,10,10,10),
                      child: TextField(
                        controller:  bottomSheetController.tglBookingController,
                        decoration: InputDecoration(
                          hintText: "Tanggal Booking",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    ],),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showTimePicker(context, bottomSheetController); // Panggil fungsi untuk menampilkan bottom picker
                  },
                  child: AbsorbPointer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Text('Tanggal Booking'),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.only(left: 25, right: 20),
                      margin: const EdgeInsets.fromLTRB(10,10,10,10),
                      child: TextField(
                        controller: bottomSheetController.jamBookingController,
                        decoration: InputDecoration(
                          hintText: "Jam Booking",
                          border: InputBorder.none,
                        ),
                      ),
                    ),]),
                  ),
                ),
                SizedBox(height: 16),
            Container(
              width: double.infinity,
              child:
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showBottomSheetApprove(context, arguments);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.appPrimaryColor,

                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 4.0,
                  ),
                  child: const Text('Simpan',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // Fungsi untuk menampilkan BottomSheet
  void _showBottomSheetApprove (BuildContext context, Map<String, dynamic> arguments) {
    ApproveController bottomSheetController = Get.put(ApproveController());
    bottomSheetController.tglBookingController.text = arguments['tgl_booking'] ?? '';
    bottomSheetController.jamBookingController.text = arguments['jam_booking'] ?? '';
    bottomSheetController.tanggalController.text;
    bottomSheetController.jamController.text;

    showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Pilih Mekanik',style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                //simpan sini dropdownnya
                FutureBuilder<Mekanik>(
                  future: API.Mekanikid(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final mekanik = snapshot.data!;
                      return SearchChoices.single(
                        items: mekanik.dataMekanik!
                            .map((e) => DropdownMenuItem(
                          value: e.nama,
                          child: Text(e.nama!),
                        ))
                            .toList(),
                        value: mekanik.dataMekanik!.first.nama,
                        hint: "Pilih Mekanik",
                        searchHint: null,
                        onChanged: (value) {
                          mekanik.dataMekanik!.first.nama = value;
                        },
                        isExpanded: true,
                        displayClearIcon: false,
                        underline: Container(),
                      );
                    }
                  },
                ),

                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child:
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 4.0,
                    ),
                    child: const Text('Approve',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// Fungsi untuk menampilkan bottom picker tanggal
  void _showDatePicker(BuildContext context, ApproveController controller) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          ),
          child: CupertinoDatePicker(
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDate) {
              String dateOnly = '${newDate.day}-${newDate.month}-${newDate.year}';
              controller.tglBooking = dateOnly;
            },
            mode: CupertinoDatePickerMode.date,
          ),
        );
      },
    );
  }


// Fungsi untuk menampilkan bottom picker jam
  void _showTimePicker(BuildContext context, ApproveController controller) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: 300,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),
          child: CupertinoDatePicker(
            // initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newTime) {
              final selectedTime = TimeOfDay.fromDateTime(newTime);
              controller.jamBooking = selectedTime.format(context); // Set nilai jam yang dipilih ke dalam controller
            },
            mode: CupertinoDatePickerMode.time,
          ),
        );
      },
    );
  }



}
