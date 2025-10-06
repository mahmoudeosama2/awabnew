class Governorate {
  String? id;
  String? governorateNameAr;
  String? governorateNameEn;
  double? lat;
  double? long;

  Governorate(
      {this.id,
      this.governorateNameAr,
      this.governorateNameEn,
      this.lat,
      this.long});

  Governorate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    governorateNameAr = json['governorate_name_ar'];
    governorateNameEn = json['governorate_name_en'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['governorate_name_ar'] = governorateNameAr;
    data['governorate_name_en'] = governorateNameEn;
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}
