class NguyenLieu {
  int id;
  String ten;

  NguyenLieu({
    required this.id,
    required this.ten,
  });

  factory NguyenLieu.fromJson(Map<String, dynamic> json) {
    return NguyenLieu(
      id: json["id"],
      ten: json["ten"],
    );
  }
}
