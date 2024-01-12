import 'package:app_dac_san/model/dia_chi.dart';

class NoiBan {
  int id;
  String ten;
  String? moTa;
  DiaChi diaChi;
  int luotXem = 0;
  double diemDanhGia;
  int luotDanhGia = 0;

  NoiBan({
    required this.id,
    required this.ten,
    this.moTa,
    required this.diaChi,
    required this.luotXem,
    required this.diemDanhGia,
    required this.luotDanhGia,
  });

  factory NoiBan.fromJson(Map<String, dynamic> json) {
    return NoiBan(
      id: json['id'],
      ten: json['ten'],
      moTa: json['mo_ta'],
      diaChi: DiaChi.fromJson(json['dia_chi']),
      luotXem: json['luot_xem'],
      diemDanhGia: json['diem_danh_gia'],
      luotDanhGia: json['luot_danh_gia'],
    );
  }
}
