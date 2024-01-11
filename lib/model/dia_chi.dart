import 'package:app_dac_san/model/tinh_thanh.dart';

class DiaChi {
  int id;
  String soNha;
  String tenDuong;
  String phuongXa;
  String quanHuyen;
  TinhThanh tinhThanh;

  DiaChi({
    required this.id,
    required this.soNha,
    required this.tenDuong,
    required this.phuongXa,
    required this.quanHuyen,
    required this.tinhThanh,
  });

  factory DiaChi.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'soNha': String soNha,
        'tenDuong': String tenDuong,
        'phuongXa': String phuongXa,
        'quanHuyen': String quanHuyen,
        'tinhThanh': TinhThanh tinhThanh,
      } =>
        DiaChi(
          id: id,
          soNha: soNha,
          tenDuong: tenDuong,
          phuongXa: phuongXa,
          quanHuyen: quanHuyen,
          tinhThanh: tinhThanh,
        ),
      _ => throw const FormatException('Đọc địa chỉ thất bại.'),
    };
  }
}
