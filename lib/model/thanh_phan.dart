import 'package:app_dac_san/model/nguyen_lieu.dart';

import '../json_helper.dart';

class ThanhPhan {
  NguyenLieu nguyenLieu;
  double soLuong;
  String donViTinh;
  static const String url = "${ApiHelper.baseUrl}thanhphan";
  ThanhPhan({
    required this.nguyenLieu,
    required this.soLuong,
    required this.donViTinh,
  });

  factory ThanhPhan.fromJson(Map<String, dynamic> json) {
    return ThanhPhan(
      nguyenLieu: NguyenLieu.fromJson(json['nguyen_lieu']),
      soLuong: json['so_luong'],
      donViTinh: json['don_vi_tinh'],
    );
  }

  @override
  String toString() {
    return "$soLuong $donViTinh ${nguyenLieu.ten}";
  }
}
