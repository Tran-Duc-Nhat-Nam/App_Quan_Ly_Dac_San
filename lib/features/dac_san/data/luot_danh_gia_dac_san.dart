class LuotDanhGiaDacSan {
  String idNguoiDung;
  int idDacSan;
  DateTime thoiGianDanhGia;
  int diemDanhGia;
  String noiDung = "";

  LuotDanhGiaDacSan(
      {required this.idNguoiDung,
      required this.idDacSan,
      required this.thoiGianDanhGia,
      required this.diemDanhGia,
      this.noiDung = ""});

  LuotDanhGiaDacSan.tam()
      : idNguoiDung = "",
        idDacSan = -1,
        thoiGianDanhGia = DateTime.now(),
        diemDanhGia = -1;

  factory LuotDanhGiaDacSan.fromJson(Map<String, dynamic> json) {
    return LuotDanhGiaDacSan(
      idNguoiDung: json['id_nguoi_dung'],
      idDacSan: json['id_dac_san'],
      thoiGianDanhGia: DateTime.parse(json['thoi_gian']),
      diemDanhGia: json['diem_danh_gia'],
      noiDung: json['noi_dung'],
    );
  }

  static List<LuotDanhGiaDacSan> fromJsonList(List<dynamic> json) {
    List<LuotDanhGiaDacSan> dsVungMien = [];

    for (var value in json) {
      dsVungMien.add(LuotDanhGiaDacSan.fromJson(value));
    }

    return dsVungMien;
  }
}
