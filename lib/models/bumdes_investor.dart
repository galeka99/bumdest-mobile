class BumdesInvestorModel {
  final int userId;
  final String userName;
  final String userProvince;
  final String userCity;
  final String userDistrict;
  final int investAmount;

  BumdesInvestorModel({
    required this.userId,
    required this.userName,
    required this.userProvince,
    required this.userCity,
    required this.userDistrict,
    required this.investAmount,
  });

  factory BumdesInvestorModel.parse(dynamic json) {
    return BumdesInvestorModel(
      userId: json['user_id'],
      userName: json['user_name'],
      userProvince: json['user_province'],
      userCity: json['user_city'],
      userDistrict: json['user_district'],
      investAmount: json['total_invest'],
    );
  }
}
