class LocationModel {
  final int provinceId;
  final int cityId;
  final int districtId;
  final String provinceName;
  final String cityName;
  final String districtName;

  LocationModel({
    required this.provinceId,
    required this.cityId,
    required this.districtId,
    required this.provinceName,
    required this.cityName,
    required this.districtName,
  });

  factory LocationModel.parse(dynamic json) {
    return LocationModel(
      provinceId: json['province_id'],
      cityId: json['city_id'],
      districtId: json['district_id'],
      provinceName: json['province_name'],
      cityName: json['city_name'],
      districtName: json['district_name'],
    );
  }
}