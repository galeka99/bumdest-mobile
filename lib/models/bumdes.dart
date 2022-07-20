import 'package:bumdest/models/location.dart';

class BumdesModel {
  final int id;
  final String name;
  final String description;
  final String? address;
  final LocationModel location;
  final double voteAverage;
  final int voteCount;
  final String? createdAt;
  final String? updatedAt;

  BumdesModel({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.location,
    required this.voteAverage,
    required this.voteCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BumdesModel.parse(dynamic json) {
    return BumdesModel(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '-',
      address: json['address'],
      location: LocationModel.parse(json['location']),
      voteAverage: json['vote_average'] is int ? (json['vote_average'] as int).toDouble() : json['vote_average'],
      voteCount: json['vote_count'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
