class Mekanik {
  bool? status;
  String? message;
  List<DataMekanik>? dataMekanik;

  Mekanik({this.status, this.message, this.dataMekanik});

  Mekanik.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['dataMekanik'] != null) {
      dataMekanik = <DataMekanik>[];
      json['dataMekanik'].forEach((v) {
        dataMekanik!.add(new DataMekanik.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.dataMekanik != null) {
      data['dataMekanik'] = this.dataMekanik!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataMekanik {
  int? id;
  String? nama;
  String? email;
  String? roleNama;

  DataMekanik({this.id, this.nama, this.email, this.roleNama});

  DataMekanik.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nama = json['nama'];
    email = json['email'];
    roleNama = json['role_nama'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nama'] = this.nama;
    data['email'] = this.email;
    data['role_nama'] = this.roleNama;
    return data;
  }
}