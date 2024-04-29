class SubmitGC {
  int? bookingId;
  List<GeneralCheckup>? generalCheckup;

  SubmitGC({this.bookingId, this.generalCheckup});

  SubmitGC.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    if (json['general_checkup'] != null) {
      generalCheckup = <GeneralCheckup>[];
      json['general_checkup'].forEach((v) {
        generalCheckup!.add(new GeneralCheckup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    if (this.generalCheckup != null) {
      data['general_checkup'] =
          this.generalCheckup!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GeneralCheckup {
  int? subHeadingId;
  List<Gcus>? gcus;

  GeneralCheckup({this.subHeadingId, this.gcus});

  GeneralCheckup.fromJson(Map<String, dynamic> json) {
    subHeadingId = json['sub_heading_id'];
    if (json['gcus'] != null) {
      gcus = <Gcus>[];
      json['gcus'].forEach((v) {
        gcus!.add(new Gcus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sub_heading_id'] = this.subHeadingId;
    if (this.gcus != null) {
      data['gcus'] = this.gcus!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gcus {
  String? gcuId;
  String? status;
  String? description;

  Gcus({this.gcuId, this.status, this.description});

  Gcus.fromJson(Map<String, dynamic> json) {
    gcuId = json['gcu_id'];
    status = json['status'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gcu_id'] = this.gcuId;
    data['status'] = this.status;
    data['description'] = this.description;
    return data;
  }
}