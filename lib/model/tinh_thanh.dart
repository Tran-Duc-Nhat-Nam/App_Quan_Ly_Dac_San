class TinhThanh {
  int id;
  String ten;

  TinhThanh({
    required this.id,
    required this.ten,
  });

  factory TinhThanh.fromJson(Map<String, dynamic> json) {
    return TinhThanh(
      id: json["id"],
      ten: json["ten"],
    );
  }
}
