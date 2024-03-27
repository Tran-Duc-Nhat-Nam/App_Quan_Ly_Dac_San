class LuotXemDacSan {
  String idNguoiDung;
  int idDacSan;
  DateTime thoiGianXem;

  LuotXemDacSan({
    required this.idNguoiDung,
    required this.idDacSan,
    required this.thoiGianXem,
  });

  LuotXemDacSan.tam()
      : idNguoiDung = "",
        idDacSan = -1,
        thoiGianXem = DateTime.now();

  factory LuotXemDacSan.fromJson(Map<String, dynamic> json) {
    return LuotXemDacSan(
      idNguoiDung: json['id_nguoi_dung'],
      idDacSan: json['id_dac_san'],
      thoiGianXem: DateTime.parse(json['thoi_gian']),
    );
  }

  static List<LuotXemDacSan> fromJsonList(List<dynamic> json) {
    List<LuotXemDacSan> dsVungMien = [];

    for (var value in json) {
      dsVungMien.add(LuotXemDacSan.fromJson(value));
    }

    return dsVungMien;
  }
}
