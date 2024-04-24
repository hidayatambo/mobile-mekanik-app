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
  int? bookingId;
  String? kodeBooking;
  int? idJenissvc;
  String? bookingStatus;
  String? jamBooking;
  String? tglBooking;
  String? pic;
  String? hpPic;
  String? namaService;
  String? namaCabang;
  String? noPolisi;
  String? tahun;
  String? warna;
  String? transmisi;
  String? noRangka;
  String? noMesin;
  String? namaTipe;
  String? namaMerk;
  String? namaPelanggan;
  String? alamatpelanggan;
  String? hpPelanggan;

  DataBooking(
      {this.bookingId,
        this.kodeBooking,
        this.idJenissvc,
        this.bookingStatus,
        this.jamBooking,
        this.tglBooking,
        this.pic,
        this.hpPic,
        this.namaService,
        this.namaCabang,
        this.noPolisi,
        this.tahun,
        this.warna,
        this.transmisi,
        this.noRangka,
        this.noMesin,
        this.namaTipe,
        this.namaMerk,
        this.namaPelanggan,
        this.alamatpelanggan,
        this.hpPelanggan});

  DataBooking.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    kodeBooking = json['kode_booking'];
    idJenissvc = json['id_jenissvc'];
    bookingStatus = json['booking_status'];
    jamBooking = json['jam_booking'];
    tglBooking = json['tgl_booking'];
    pic = json['pic'];
    hpPic = json['hp_pic'];
    namaService = json['nama_service'];
    namaCabang = json['nama_cabang'];
    noPolisi = json['no_polisi'];
    tahun = json['tahun'];
    warna = json['warna'];
    transmisi = json['transmisi'];
    noRangka = json['no_rangka'];
    noMesin = json['no_mesin'];
    namaTipe = json['nama_tipe'];
    namaMerk = json['nama_merk'];
    namaPelanggan = json['nama'];
    alamatpelanggan = json['alamat'];
    hpPelanggan = json['hp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['kode_booking'] = this.kodeBooking;
    data['id_jenissvc'] = this.idJenissvc;
    data['booking_status'] = this.bookingStatus;
    data['jam_booking'] = this.jamBooking;
    data['tgl_booking'] = this.tglBooking;
    data['pic'] = this.pic;
    data['hp_pic'] = this.hpPic;
    data['nama_service'] = this.namaService;
    data['nama_cabang'] = this.namaCabang;
    data['no_polisi'] = this.noPolisi;
    data['tahun'] = this.tahun;
    data['warna'] = this.warna;
    data['transmisi'] = this.transmisi;
    data['no_rangka'] = this.noRangka;
    data['no_mesin'] = this.noMesin;
    data['nama_tipe'] = this.namaTipe;
    data['nama_merk'] = this.namaMerk;
    data['nama'] = this.namaPelanggan;
    data['alamat'] = this.alamatpelanggan;
    data['hp'] = this.hpPelanggan;
    return data;
  }
}