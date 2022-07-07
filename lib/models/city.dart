class CityModel {
  final int id;
  final int provinceId;
  final String name;
  final String createdAt;
  final String updatedAt;

  CityModel({
    required this.id,
    required this.provinceId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CityModel.parse(dynamic json) {
    return CityModel(
      id: json['id'],
      provinceId: json['province_id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
