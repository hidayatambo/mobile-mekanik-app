class ServiceSelesai {
  bool? status;
  String? message;
  String? namaSS;
  int? countBookingMasuk;
  String? serviceSelesai;

  ServiceSelesai(
      {this.status,
        this.message,
        this.namaSS,
        this.countBookingMasuk,
        this.serviceSelesai});

  ServiceSelesai.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    namaSS = json['namaSS'];
    countBookingMasuk = json['countBookingMasuk'];
    serviceSelesai = json['serviceSelesai'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['namaSS'] = this.namaSS;
    data['countBookingMasuk'] = this.countBookingMasuk;
    data['serviceSelesai'] = this.serviceSelesai;
    return data;
  }
}