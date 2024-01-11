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
    return switch (json) {
      {
        'id': int id,
        'ten': String ten,
        'moTa': String moTa,
        'cachCheBien': String cachCheBien,
        'luotXem': int luotXem,
        'diemDanhGia': double diemDanhGia,
        'luotDanhGia': int luotDanhGia,
      } =>
        DacSan(
          id: id,
          ten: ten,
          moTa: moTa,
          cachCheBien: cachCheBien,
          luotXem: luotXem,
          diemDanhGia: diemDanhGia,
          luotDanhGia: luotDanhGia,
        ),
      _ => throw const FormatException('Đọc địa chỉ thất bại.'),
    };
  }
}
