class TinhThanh {
  int id;
  String ten;

  TinhThanh({
    required this.id,
    required this.ten,
  });

  factory TinhThanh.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'ten': String ten,
      } =>
        TinhThanh(
          id: id,
          ten: ten,
        ),
      _ => throw const FormatException('Failed to load album.'),
    };
  }
}
