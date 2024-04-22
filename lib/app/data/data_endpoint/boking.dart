class Boking {
  bool? status;
  String? message;
  List<DataBooking>? dataBooking;

  Boking({this.status, this.message, this.dataBooking});

  Boking.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['dataBooking'] != null) {
      dataBooking = <DataBooking>[];
      json['dataBooking'].forEach((v) {
        dataBooking!.add(new DataBooking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.dataBooking != null) {
      data['dataBooking'] = this.dataBooking!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataBooking {
  int? id;
  String? kodeBooking;
  String? tglBooking;
  String? jamBooking;
  String? nama;
  String? namaJenissvc;
  String? noPolisi;
  String? namaMerk;
  String? namaTipe;
  String? status;

  DataBooking(
      {this.id,
        this.kodeBooking,
        this.tglBooking,
        this.jamBooking,
        this.nama,
        this.namaJenissvc,
        this.noPolisi,
        this.namaMerk,
        this.namaTipe,
        this.status});

  DataBooking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kodeBooking = json['kode_booking'];
    tglBooking = json['tgl_booking'];
    jamBooking = json['jam_booking'];
    nama = json['nama'];
    namaJenissvc = json['nama_jenissvc'];
    noPolisi = json['no_polisi'];
    namaMerk = json['nama_merk'];
    namaTipe = json['nama_tipe'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kode_booking'] = this.kodeBooking;
    data['tgl_booking'] = this.tglBooking;
    data['jam_booking'] = this.jamBooking;
    data['nama'] = this.nama;
    data['nama_jenissvc'] = this.namaJenissvc;
    data['no_polisi'] = this.noPolisi;
    data['nama_merk'] = this.namaMerk;
    data['nama_tipe'] = this.namaTipe;
    data['status'] = this.status;
    return data;
  }
}