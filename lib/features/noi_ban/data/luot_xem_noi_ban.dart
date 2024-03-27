class LuotXemNoiBan {
  String idNguoiDung;
  int idNoiBan;
  DateTime thoiGianXem;

  LuotXemNoiBan({
    required this.idNguoiDung,
    required this.idNoiBan,
    required this.thoiGianXem,
  });

  LuotXemNoiBan.tam()
      : idNguoiDung = "",
        idNoiBan = -1,
        thoiGianXem = DateTime.now();

  factory LuotXemNoiBan.fromJson(Map<String, dynamic> json) {
    return LuotXemNoiBan(
      idNguoiDung: json['id_nguoi_dung'],
      idNoiBan: json['id_noi_ban'],
      thoiGianXem: DateTime.parse(json['thoi_gian']),
    );
  }

  static List<LuotXemNoiBan> fromJsonList(List<dynamic> json) {
    List<LuotXemNoiBan> dsVungMien = [];

    for (var value in json) {
      dsVungMien.add(LuotXemNoiBan.fromJson(value));
    }

    return dsVungMien;
  }
}
