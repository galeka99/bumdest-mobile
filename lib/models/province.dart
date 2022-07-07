class ProvinceModel {
  final int id;
  final String name;
  final String createdAt;
  final String updatedAt;

  ProvinceModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProvinceModel.parse(dynamic json) {
    return ProvinceModel(
      id: json['id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
