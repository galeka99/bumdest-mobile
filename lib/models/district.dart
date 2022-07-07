class DistrictModel {
  final int id;
  final int cityId;
  final String name;
  final String createdAt;
  final String updatedAt;

  DistrictModel({
    required this.id,
    required this.cityId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DistrictModel.parse(dynamic json) {
    return DistrictModel(
      id: json['id'],
      cityId: json['city_id'],
      name: json['name'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
