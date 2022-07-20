import 'package:bumdest/models/location.dart';

class ReportDetailModel {
  final int id;
  final int parentId;
  final int userId;
  final double percentage;
  final double amount;
  final int month;
  final int year;
  final int profit;
  final String? reportFile;
  final int productId;
  final String productTitle;
  final int bumdesId;
  final String bumdesName;
  final LocationModel bumdesLocation;
  final String createdAt;
  final String updatedAt;

  ReportDetailModel({
    required this.id,
    required this.parentId,
    required this.userId,
    required this.percentage,
    required this.amount,
    required this.month,
    required this.year,
    required this.profit,
    required this.reportFile,
    required this.productId,
    required this.productTitle,
    required this.bumdesId,
    required this.bumdesName,
    required this.bumdesLocation,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReportDetailModel.parse(dynamic json) {
    return ReportDetailModel(
      id: json['id'],
      parentId: json['parent']['id'],
      userId: json['user_id'],
      percentage: (json['percentage'] is int) ? (json['percentage'] as int).toDouble() : json['percentage'],
      amount: (json['amount'] is int) ? (json['amount'] as int).toDouble() : json['amount'],
      month: json['parent']['month'],
      year: int.parse(json['parent']['year']),
      profit: json['parent']['profit'],
      reportFile: json['parent']['report_file'],
      productId: json['parent']['project']['id'],
      productTitle: json['parent']['project']['title'],
      bumdesId: json['parent']['project']['bumdes']['id'],
      bumdesName: json['parent']['project']['bumdes']['name'],
      bumdesLocation: LocationModel.parse(json['parent']['project']['bumdes']['location']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
