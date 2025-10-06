class Qari {
  int? id;
  String? name;
  String? arabicName;
  String? relativePath;
  String? fileFormats;
  int? sectionId;
  bool? home;

  String? torrentFilename;
  String? torrentInfoHash;
  int? torrentSeeders;
  int? torrentLeechers;

  Qari(
      {this.id,
      this.name,
      this.arabicName,
      this.relativePath,
      this.fileFormats,
      this.sectionId,
      this.home,
      this.torrentFilename,
      this.torrentInfoHash,
      this.torrentSeeders,
      this.torrentLeechers});

  Qari.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    arabicName =
        json['arabic_name'] ?? json['name'];
    relativePath = json['relative_path'];
    fileFormats = json['file_formats'];
    sectionId = json['section_id'];
    home = json['home'];

    torrentFilename = json['torrent_filename'];
    torrentInfoHash = json['torrent_info_hash'];
    torrentSeeders = json['torrent_seeders'];
    torrentLeechers = json['torrent_leechers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['arabic_name'] = arabicName;
    data['relative_path'] = relativePath;
    data['file_formats'] = fileFormats;
    data['section_id'] = sectionId;
    data['home'] = home;

    data['torrent_filename'] = torrentFilename;
    data['torrent_info_hash'] = torrentInfoHash;
    data['torrent_seeders'] = torrentSeeders;
    data['torrent_leechers'] = torrentLeechers;
    return data;
  }
}
