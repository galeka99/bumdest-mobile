import 'package:bumdest/models/payment_method.dart';
import 'package:bumdest/models/status.dart';

class WithdrawHistoryModel {
  final int id;
  final int amount;
  final PaymentMethodModel method;
  final StatusModel status;
  final String createdAt;
  final String updatedAt;

  WithdrawHistoryModel({
    required this.id,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WithdrawHistoryModel.parse(dynamic json) {
    return WithdrawHistoryModel(
      id: json['id'],
      amount: json['amount'],
      method: PaymentMethodModel.parse(json['method']),
      status: StatusModel.parse(json['status']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
