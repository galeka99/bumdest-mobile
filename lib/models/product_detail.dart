import 'package:bumdest/models/bumdes.dart';
import 'package:bumdest/models/status.dart';

class ProductDetailModel {
  final int id;
  final String title;
  final String description;
  final int currentInvest;
  final int investTarget;
  final String offerStartDate;
  final String offerEndDate;
  final double voteAverage;
  final int voteCount;
  final String? proposal;
  final List<ProductImageModel> images;
  final BumdesModel bumdes;
  final StatusModel status;
  final String createdAt;
  final String updatedAt;

  ProductDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.currentInvest,
    required this.investTarget,
    required this.offerStartDate,
    required this.offerEndDate,
    required this.voteAverage,
    required this.voteCount,
    required this.proposal,
    required this.images,
    required this.bumdes,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductDetailModel.parse(dynamic json) {
    return ProductDetailModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      currentInvest: json['current_invest'],
      investTarget: json['invest_target'],
      offerStartDate: json['offer_start_date'],
      offerEndDate: json['offer_end_date'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
      proposal: json['proposal'],
      images: (json['images'] as List).map((e) => ProductImageModel.parse(e)).toList(),
      bumdes: BumdesModel.parse(json['bumdes']),
      status: StatusModel.parse(json['status']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class ProductImageModel {
  final int id;
  final String url;
  final String createdAt;
  final String updatedAt;

  ProductImageModel({
    required this.id,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductImageModel.parse(dynamic json) {
    return ProductImageModel(
      id: json['id'],
      url: json['url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
