class LuotDanhGiaNoiBan {
  String idNguoiDung;
  int idNoiBan;
  DateTime thoiGianDanhGia;
  int diemDanhGia;
  String noiDung = "";

  LuotDanhGiaNoiBan(
      {required this.idNguoiDung,
      required this.idNoiBan,
      required this.thoiGianDanhGia,
      required this.diemDanhGia,
      this.noiDung = ""});

  LuotDanhGiaNoiBan.tam()
      : idNguoiDung = "",
        idNoiBan = -1,
        thoiGianDanhGia = DateTime.now(),
        diemDanhGia = -1;

  factory LuotDanhGiaNoiBan.fromJson(Map<String, dynamic> json) {
    return LuotDanhGiaNoiBan(
      idNguoiDung: json['id_nguoi_dung'],
      idNoiBan: json['id_noi_ban'],
      thoiGianDanhGia: DateTime.parse(json['thoi_gian']),
      diemDanhGia: json['diem_danh_gia'],
      noiDung: json['noi_dung'],
    );
  }

  static List<LuotDanhGiaNoiBan> fromJsonList(List<dynamic> json) {
    List<LuotDanhGiaNoiBan> dsVungMien = [];

    for (var value in json) {
      dsVungMien.add(LuotDanhGiaNoiBan.fromJson(value));
    }

    return dsVungMien;
  }
}
