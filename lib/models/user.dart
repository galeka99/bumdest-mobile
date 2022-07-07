import 'package:bumdest/models/location.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final int balance;
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
      address: json['address'],
      postalCode: json['postalCode'],
      location: LocationModel.parse(json['location']),
      verified: json['verified'],
      gender: json['gender'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}