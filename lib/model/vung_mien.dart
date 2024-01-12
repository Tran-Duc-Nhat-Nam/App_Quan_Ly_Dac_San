class VungMien {
  int id;
  String ten;

  VungMien({
    required this.id,
    required this.ten,
  });

  factory VungMien.fromJson(Map<String, dynamic> json) {
    return VungMien(
      id: json["id"],
      ten: json["ten"],
    );
  }
}
