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
    return DiaChi(
      id: json['id'],
      soNha: json['so_nha'],
      tenDuong: json['ten_duong'],
      phuongXa: json['phuong_xa'],
      quanHuyen: json['quan_huyen'],
      tinhThanh: TinhThanh.fromJson(json['tinh_thanh']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'so_nha': soNha,
        'ten_duong': tenDuong,
        'phuong_xa': phuongXa,
        'quan_huyen': quanHuyen,
        'tinh_thanh': tinhThanh.toJson(),
      };
  @override
  String toString() {
    return "$soNha $tenDuong, $phuongXa, $quanHuyen, ${tinhThanh.ten}";
  }
}
