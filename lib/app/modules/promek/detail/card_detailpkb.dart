import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/data_endpoint/pkb.dart';

class CardDetailPKB extends StatelessWidget {
  const CardDetailPKB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Accessing jasa and parts lists
    final List<dynamic>? jasa = args['jasa'];
    final List<dynamic>? parts = args['parts'];

    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              args['tipe_svc'] ?? '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Tanggal & Jam PKB:', args['tgl_pkb'] ?? ''),
            _buildInfoRow('Jam Selesai:', args['jam_selesai'] ?? '-'),
            _buildInfoRow('Cabang:', args['nama_cabang'] ?? ''),
            _buildInfoRow('Kode PKB:', args['kode_pkb'] ?? '',
                color: Colors.green),
            _buildInfoRow('Tipe Pelanggan:', args['tipe_pelanggan'] ?? ''),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              'Detail Pelanggan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
            _buildDetailText('Nama:', args['nama'] ?? ''),
            _buildDetailText('No Handphone:', args['telp'] ?? ''),
            _buildDetailText('Alamat:', args['alamat'] ?? ''),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              'Kendaraan Pelanggan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
            _buildInfoRow('Merk:', args['nama_merk'] ?? ''),
            _buildInfoRow('Tipe:', args['nama_tipe'] ?? ''),
            _buildInfoRow('Tahun:', args['tahun'] ?? '-'),
            _buildInfoRow('Warna:', args['warna'] ?? '-'),
            _buildInfoRow('Kategori Kendaraan:',
                args['kategori_kendaraan'] ?? '-'),
            _buildInfoRow('Transmisi:', args['transmisi'] ?? '-'),
            _buildInfoRow('No Polisi:', args['no_polisi'] ?? '-'),
            const Divider(color: Colors.grey),
            _buildDetailSection('Keluhan:', args['keluhan'] ?? '-'),
            const Divider(color: Colors.grey),
            const SizedBox(height: 10),
            Text(
              'Parts',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            _buildPartsList(parts?.cast<Parts>()),
            const SizedBox(height: 10),
            Text(
              'Jasa',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            _buildJasaList(jasa?.cast<Jasa>()),
          ],
        ),
      ),
    );
  }

  Widget _buildJasaList(List<Jasa>? jasaItems) {
    if (jasaItems == null || jasaItems.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          'Belum ada Jasa',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: jasaItems.map((jasa) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${jasa.namaJasa}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Qty: ${jasa.qtyJasa}',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          Text(
            'Harga: ${formatCurrency(jasa.hargaJasa ?? 0)}',
          ),
          Divider(color: Colors.grey),
        ],
      )).toList(),
    );
  }
  Widget _buildPartsList(List<Parts>? partsItems) {
    if (partsItems == null || partsItems.isEmpty) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          'Belum ada Parts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: partsItems.map((part) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${part.namaSparepart} - Qty: ${part.qty}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            'Qty: ${part.qty}',
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          Text(
            'Harga: ${formatCurrency(part.hargaSparepart ?? 0)}',
          ),
          Divider(color: Colors.grey),
        ],
      )).toList(),
    );
  }

  String formatCurrency(int amount) {
    var format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    return format.format(amount);
  }

  Widget _buildInfoRow(String title, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailText(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _buildDetailSection(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.normal,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
