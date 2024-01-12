class MuaDacSan {
  int id;
  String ten;

  MuaDacSan({
    required this.id,
    required this.ten,
  });

  factory MuaDacSan.fromJson(Map<String, dynamic> json) {
    return MuaDacSan(
      id: json["id"],
      ten: json["ten"],
    );
  }
}
