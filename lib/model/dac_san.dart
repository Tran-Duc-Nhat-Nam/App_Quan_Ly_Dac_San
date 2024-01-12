class DacSan {
  int id;
  String ten;
  String? moTa;
  String? cachCheBien;
  int luotXem = 0;
  double diemDanhGia;
  int luotDanhGia = 0;

  DacSan({
    required this.id,
    required this.ten,
    this.moTa,
    this.cachCheBien,
    required this.luotXem,
    required this.diemDanhGia,
    required this.luotDanhGia,
  });

  factory DacSan.fromJson(Map<String, dynamic> json) {
    return DacSan(
      id: json['id'],
      ten: json['ten'],
      moTa: json['mo_ta'],
      cachCheBien: json['cach_che_bien'],
      luotXem: json['luot_xem'],
      diemDanhGia: json['diem_danh_gia'],
      luotDanhGia: json['luot_danh_gia'],
    );
  }
}
