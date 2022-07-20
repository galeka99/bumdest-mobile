class ReportHistoryModel {
  final int id;
  final int parentId;
  final int userId;
  final double percentage;
  final double amount;
  final int month;
  final int year;
  final int productId;
  final String productTitle;
  final String createdAt;
  final String updatedAt;

  ReportHistoryModel({
    required this.id,
    required this.parentId,
    required this.userId,
    required this.percentage,
    required this.amount,
    required this.month,
    required this.year,
    required this.productId,
    required this.productTitle,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReportHistoryModel.parse(dynamic json) {
    return ReportHistoryModel(
      id: json['id'],
      parentId: json['parent']['id'],
      userId: json['user_id'],
      percentage: (json['percentage'] is int) ? (json['percentage'] as int).toDouble() : json['percentage'],
      amount: (json['amount'] is int) ? (json['amount'] as int).toDouble() : json['amount'],
      month: json['parent']['month'],
      year: int.parse(json['parent']['year']),
      productId: json['parent']['project']['id'],
      productTitle: json['parent']['project']['title'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
