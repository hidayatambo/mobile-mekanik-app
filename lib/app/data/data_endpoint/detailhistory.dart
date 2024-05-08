class DetailHistory {
  bool? status;
  String? message;
  DataSvc? dataSvc;
  List<Null>? dataSvcPaket;
  List<Null>? dataSvcDtlPart;
  List<Null>? dataSvcDtlJasa;
  List<Null>? paket;
  Null? deskripsiMembership;

  DetailHistory(
      {this.status,
        this.message,
        this.dataSvc,
        this.dataSvcPaket,
        this.dataSvcDtlPart,
        this.dataSvcDtlJasa,
        this.paket,
        this.deskripsiMembership});

  DetailHistory.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    dataSvc = json['data_svc'] != null
        ? new DataSvc.fromJson(json['data_svc'])
        : null;
    if (json['data_svc_paket'] != null) {
      dataSvcPaket = <Null>[];
      json['data_svc_paket'].forEach((v) {
        dataSvcPaket!.add((v));
      });
    }
    if (json['data_svc_dtl_part'] != null) {
      dataSvcDtlPart = <Null>[];
      json['data_svc_dtl_part'].forEach((v) {
        dataSvcDtlPart!.add((v));
      });
    }
    if (json['data_svc_dtl_jasa'] != null) {
      dataSvcDtlJasa = <Null>[];
      json['data_svc_dtl_jasa'].forEach((v) {
        dataSvcDtlJasa!.add((v));
      });
    }
    if (json['paket'] != null) {
      paket = <Null>[];
      json['paket'].forEach((v) {
        paket!.add((v));
      });
    }
    deskripsiMembership = json['deskripsi_membership'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.dataSvc != null) {
      data['data_svc'] = this.dataSvc!.toJson();
    }
    if (this.dataSvcPaket != null) {
      data['data_svc_paket'] =
          this.dataSvcPaket!.map((v) => ()).toList();
    }
    if (this.dataSvcDtlPart != null) {
      data['data_svc_dtl_part'] =
          this.dataSvcDtlPart!.map((v) => ()).toList();
    }
    if (this.dataSvcDtlJasa != null) {
      data['data_svc_dtl_jasa'] =
          this.dataSvcDtlJasa!.map((v) => ()).toList();
    }
    if (this.paket != null) {
      data['paket'] = this.paket!.map((v) =>()).toList();
    }
    data['deskripsi_membership'] = this.deskripsiMembership;
    return data;
  }
}

class DataSvc {
  int? id;
  String? kodeBooking;
  int? cabangId;
  String? kodeSvc;
  String? kodeEstimasi;
  String? kodePkb;
  String? kodePelanggan;
  String? kodeKendaraan;
  Null? odometer;
  Null? pic;
  Null? hpPic;
  Null? kodeMembership;
  Null? kodePaketmember;
  String? tipeSvc;
  String? tipePelanggan;
  String? referensi;
  Null? referensiTeman;
  Null? poNumber;
  Null? paketSvc;
  Null? tglKeluar;
  Null? tglKembali;
  Null? kmKeluar;
  Null? kmKembali;
  Null? keluhan;
  Null? perintahKerja;
  Null? pergantianPart;
  Null? saran;
  Null? ppn;
  String? penanggungJawab;
  String? tglEstimasi;
  String? tglPkb;
  Null? tglTutup;
  Null? jamEstimasiSelesai;
  Null? jamSelesai;
  int? pkb;
  int? tutup;
  int? faktur;
  int? deleted;
  int? notab;
  String? createdBy;
  String? createdByPkb;
  String? createdAt;
  String? updatedBy;
  Null? updatedAt;
  String? kode;
  String? noPolisi;
  int? idMerk;
  int? idTipe;
  String? tahun;
  String? warna;
  String? transmisi;
  Null? noRangka;
  Null? noMesin;
  Null? modelKaroseri;
  String? drivingMode;
  Null? power;
  String? kategoriKendaraan;
  Null? jenisKontrak;
  Null? idCustomer;
  String? nama;
  String? alamat;
  Null? telp;
  String? hp;
  String? email;
  Null? kontak;
  int? due;
  Null? jenisKontrakX;
  String? namaTagihan;
  Null? alamatTagihan;
  Null? telpTagihan;
  Null? npwpTagihan;
  Null? picTagihan;
  String? password;
  Null? rememberToken;
  Null? emailVerifiedAt;
  String? otp;
  String? otpExpiry;
  String? gambar;
  String? namaMerk;
  String? namaTipe;
  String? namaCabang;

  DataSvc(
      {this.id,
        this.kodeBooking,
        this.cabangId,
        this.kodeSvc,
        this.kodeEstimasi,
        this.kodePkb,
        this.kodePelanggan,
        this.kodeKendaraan,
        this.odometer,
        this.pic,
        this.hpPic,
        this.kodeMembership,
        this.kodePaketmember,
        this.tipeSvc,
        this.tipePelanggan,
        this.referensi,
        this.referensiTeman,
        this.poNumber,
        this.paketSvc,
        this.tglKeluar,
        this.tglKembali,
        this.kmKeluar,
        this.kmKembali,
        this.keluhan,
        this.perintahKerja,
        this.pergantianPart,
        this.saran,
        this.ppn,
        this.penanggungJawab,
        this.tglEstimasi,
        this.tglPkb,
        this.tglTutup,
        this.jamEstimasiSelesai,
        this.jamSelesai,
        this.pkb,
        this.tutup,
        this.faktur,
        this.deleted,
        this.notab,
        this.createdBy,
        this.createdByPkb,
        this.createdAt,
        this.updatedBy,
        this.updatedAt,
        this.kode,
        this.noPolisi,
        this.idMerk,
        this.idTipe,
        this.tahun,
        this.warna,
        this.transmisi,
        this.noRangka,
        this.noMesin,
        this.modelKaroseri,
        this.drivingMode,
        this.power,
        this.kategoriKendaraan,
        this.jenisKontrak,
        this.idCustomer,
        this.nama,
        this.alamat,
        this.telp,
        this.hp,
        this.email,
        this.kontak,
        this.due,
        this.jenisKontrakX,
        this.namaTagihan,
        this.alamatTagihan,
        this.telpTagihan,
        this.npwpTagihan,
        this.picTagihan,
        this.password,
        this.rememberToken,
        this.emailVerifiedAt,
        this.otp,
        this.otpExpiry,
        this.gambar,
        this.namaMerk,
        this.namaTipe,
        this.namaCabang});

  DataSvc.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    kodeBooking = json['kode_booking'];
    cabangId = json['cabang_id'];
    kodeSvc = json['kode_svc'];
    kodeEstimasi = json['kode_estimasi'];
    kodePkb = json['kode_pkb'];
    kodePelanggan = json['kode_pelanggan'];
    kodeKendaraan = json['kode_kendaraan'];
    odometer = json['odometer'];
    pic = json['pic'];
    hpPic = json['hp_pic'];
    kodeMembership = json['kode_membership'];
    kodePaketmember = json['kode_paketmember'];
    tipeSvc = json['tipe_svc'];
    tipePelanggan = json['tipe_pelanggan'];
    referensi = json['referensi'];
    referensiTeman = json['referensi_teman'];
    poNumber = json['po_number'];
    paketSvc = json['paket_svc'];
    tglKeluar = json['tgl_keluar'];
    tglKembali = json['tgl_kembali'];
    kmKeluar = json['km_keluar'];
    kmKembali = json['km_kembali'];
    keluhan = json['keluhan'];
    perintahKerja = json['perintah_kerja'];
    pergantianPart = json['pergantian_part'];
    saran = json['saran'];
    ppn = json['ppn'];
    penanggungJawab = json['penanggung_jawab'];
    tglEstimasi = json['tgl_estimasi'];
    tglPkb = json['tgl_pkb'];
    tglTutup = json['tgl_tutup'];
    jamEstimasiSelesai = json['jam_estimasi_selesai'];
    jamSelesai = json['jam_selesai'];
    pkb = json['pkb'];
    tutup = json['tutup'];
    faktur = json['faktur'];
    deleted = json['deleted'];
    notab = json['notab'];
    createdBy = json['created_by'];
    createdByPkb = json['created_by_pkb'];
    createdAt = json['created_at'];
    updatedBy = json['updated_by'];
    updatedAt = json['updated_at'];
    kode = json['kode'];
    noPolisi = json['no_polisi'];
    idMerk = json['id_merk'];
    idTipe = json['id_tipe'];
    tahun = json['tahun'];
    warna = json['warna'];
    transmisi = json['transmisi'];
    noRangka = json['no_rangka'];
    noMesin = json['no_mesin'];
    modelKaroseri = json['model_karoseri'];
    drivingMode = json['driving_mode'];
    power = json['power'];
    kategoriKendaraan = json['kategori_kendaraan'];
    jenisKontrak = json['jenis_kontrak'];
    idCustomer = json['id_customer'];
    nama = json['nama'];
    alamat = json['alamat'];
    telp = json['telp'];
    hp = json['hp'];
    email = json['email'];
    kontak = json['kontak'];
    due = json['due'];
    jenisKontrakX = json['jenis_kontrak_x'];
    namaTagihan = json['nama_tagihan'];
    alamatTagihan = json['alamat_tagihan'];
    telpTagihan = json['telp_tagihan'];
    npwpTagihan = json['npwp_tagihan'];
    picTagihan = json['pic_tagihan'];
    password = json['password'];
    rememberToken = json['remember_token'];
    emailVerifiedAt = json['email_verified_at'];
    otp = json['otp'];
    otpExpiry = json['otp_expiry'];
    gambar = json['gambar'];
    namaMerk = json['nama_merk'];
    namaTipe = json['nama_tipe'];
    namaCabang = json['nama_cabang'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['kode_booking'] = this.kodeBooking;
    data['cabang_id'] = this.cabangId;
    data['kode_svc'] = this.kodeSvc;
    data['kode_estimasi'] = this.kodeEstimasi;
    data['kode_pkb'] = this.kodePkb;
    data['kode_pelanggan'] = this.kodePelanggan;
    data['kode_kendaraan'] = this.kodeKendaraan;
    data['odometer'] = this.odometer;
    data['pic'] = this.pic;
    data['hp_pic'] = this.hpPic;
    data['kode_membership'] = this.kodeMembership;
    data['kode_paketmember'] = this.kodePaketmember;
    data['tipe_svc'] = this.tipeSvc;
    data['tipe_pelanggan'] = this.tipePelanggan;
    data['referensi'] = this.referensi;
    data['referensi_teman'] = this.referensiTeman;
    data['po_number'] = this.poNumber;
    data['paket_svc'] = this.paketSvc;
    data['tgl_keluar'] = this.tglKeluar;
    data['tgl_kembali'] = this.tglKembali;
    data['km_keluar'] = this.kmKeluar;
    data['km_kembali'] = this.kmKembali;
    data['keluhan'] = this.keluhan;
    data['perintah_kerja'] = this.perintahKerja;
    data['pergantian_part'] = this.pergantianPart;
    data['saran'] = this.saran;
    data['ppn'] = this.ppn;
    data['penanggung_jawab'] = this.penanggungJawab;
    data['tgl_estimasi'] = this.tglEstimasi;
    data['tgl_pkb'] = this.tglPkb;
    data['tgl_tutup'] = this.tglTutup;
    data['jam_estimasi_selesai'] = this.jamEstimasiSelesai;
    data['jam_selesai'] = this.jamSelesai;
    data['pkb'] = this.pkb;
    data['tutup'] = this.tutup;
    data['faktur'] = this.faktur;
    data['deleted'] = this.deleted;
    data['notab'] = this.notab;
    data['created_by'] = this.createdBy;
    data['created_by_pkb'] = this.createdByPkb;
    data['created_at'] = this.createdAt;
    data['updated_by'] = this.updatedBy;
    data['updated_at'] = this.updatedAt;
    data['kode'] = this.kode;
    data['no_polisi'] = this.noPolisi;
    data['id_merk'] = this.idMerk;
    data['id_tipe'] = this.idTipe;
    data['tahun'] = this.tahun;
    data['warna'] = this.warna;
    data['transmisi'] = this.transmisi;
    data['no_rangka'] = this.noRangka;
    data['no_mesin'] = this.noMesin;
    data['model_karoseri'] = this.modelKaroseri;
    data['driving_mode'] = this.drivingMode;
    data['power'] = this.power;
    data['kategori_kendaraan'] = this.kategoriKendaraan;
    data['jenis_kontrak'] = this.jenisKontrak;
    data['id_customer'] = this.idCustomer;
    data['nama'] = this.nama;
    data['alamat'] = this.alamat;
    data['telp'] = this.telp;
    data['hp'] = this.hp;
    data['email'] = this.email;
    data['kontak'] = this.kontak;
    data['due'] = this.due;
    data['jenis_kontrak_x'] = this.jenisKontrakX;
    data['nama_tagihan'] = this.namaTagihan;
    data['alamat_tagihan'] = this.alamatTagihan;
    data['telp_tagihan'] = this.telpTagihan;
    data['npwp_tagihan'] = this.npwpTagihan;
    data['pic_tagihan'] = this.picTagihan;
    data['password'] = this.password;
    data['remember_token'] = this.rememberToken;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['otp'] = this.otp;
    data['otp_expiry'] = this.otpExpiry;
    data['gambar'] = this.gambar;
    data['nama_merk'] = this.namaMerk;
    data['nama_tipe'] = this.namaTipe;
    data['nama_cabang'] = this.namaCabang;
    return data;
  }
}