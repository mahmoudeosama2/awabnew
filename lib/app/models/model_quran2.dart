class Awab {
  int? id;
  int? jozz;
  int? suraNo;
  String? suraNameEn;
  String? suraNameAr;
  int? page;
  int? lineStart;
  int? lineEnd;
  int? ayaNo;
  String? ayaText;
  String? ayaTextEmlaey;

  Awab(
      {this.id,
      this.jozz,
      this.suraNo,
      this.suraNameEn,
      this.suraNameAr,
      this.page,
      this.lineStart,
      this.lineEnd,
      this.ayaNo,
      this.ayaText,
      this.ayaTextEmlaey});

  Awab.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    jozz = json['jozz'];
    suraNo = json['sura_no'];
    suraNameEn = json['sura_name_en'];
    suraNameAr = json['sura_name_ar'];
    page = json['page'];
    lineStart = json['line_start'];
    lineEnd = json['line_end'];
    ayaNo = json['aya_no'];
    ayaText = json['aya_text'];
    ayaTextEmlaey = json['aya_text_emlaey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['jozz'] = jozz;
    data['sura_no'] = suraNo;
    data['sura_name_en'] = suraNameEn;
    data['sura_name_ar'] = suraNameAr;
    data['page'] = page;
    data['line_start'] = lineStart;
    data['line_end'] = lineEnd;
    data['aya_no'] = ayaNo;
    data['aya_text'] = ayaText;
    data['aya_text_emlaey'] = ayaTextEmlaey;
    return data;
  }
}
