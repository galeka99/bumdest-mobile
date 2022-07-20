import 'package:bumdest/models/product.dart';
import 'package:bumdest/models/status.dart';

class InvestmentModel {
  final int id;
  final int amount;
  final ProductModel product;
  final StatusModel status;
  final String createdAt;
  final String updatedAt;

  InvestmentModel({
    required this.id,
    required this.amount,
    required this.product,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InvestmentModel.parse(dynamic json) {
    return InvestmentModel(
      id: json['id'],
      amount: json['amount'],
      product: ProductModel.parse(json['project']),
      status: StatusModel.parse(json['status']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
