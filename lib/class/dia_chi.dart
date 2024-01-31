import 'package:app_dac_san/class/phuong_xa.dart';

import '../core/json_helper.dart';

class DiaChi {
  int id;
  String soNha;
  String tenDuong;
  PhuongXa phuongXa;
  static const String url = "${ApiHelper.baseUrl}diachi";

  DiaChi({
    required this.id,
    required this.soNha,
    required this.tenDuong,
    required this.phuongXa,
  });

  factory DiaChi.fromJson(Map<String, dynamic> json) {
    return DiaChi(
      id: json['id'],
      soNha: json['so_nha'],
      tenDuong: json['ten_duong'],
      phuongXa: PhuongXa.fromJson(json['phuong_xa']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'so_nha': soNha,
        'ten_duong': tenDuong,
        'phuong_xa': phuongXa.toJson(),
      };

  @override
  String toString() {
    return "$soNha $tenDuong, ${phuongXa.ten}, ${phuongXa.quanHuyen.ten}, ${phuongXa.quanHuyen.tinhThanh.ten}";
  }
}
