import 'package:bumdest/models/location.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int balance;
  final int totalInvest;
  final int totalIncome;
  final String address;
  final String postalCode;
  final LocationModel location;
  final bool verified;
  final String gender;
  final String createdAt;
  final String updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.balance,
    required this.totalInvest,
    required this.totalIncome,
    required this.address,
    required this.postalCode,
    required this.location,
    required this.verified,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory UserModel.parse(dynamic json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      balance: json['balance'],
      totalInvest: json['total_invest'] ?? 0,
      totalIncome: json['total_income'] ?? 0,
      address: json['address'],
      postalCode: json['postal_code'],
      location: LocationModel.parse(json['location']),
      verified: json['verified'] == 1,
      gender: json['gender'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}