import 'package:bumdest/models/payment_method.dart';
import 'package:bumdest/models/status.dart';

class DepositHistoryModel {
  final int id;
  final int amount;
  final String paymentCode;
  final PaymentMethodModel method;
  final StatusModel status;
  final String createdAt;
  final String updatedAt;

  DepositHistoryModel({
    required this.id,
    required this.amount,
    required this.paymentCode,
    required this.method,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DepositHistoryModel.parse(dynamic json) {
    return DepositHistoryModel(
      id: json['id'],
      amount: json['amount'],
      paymentCode: json['payment_code'],
      method: PaymentMethodModel.parse(json['method']),
      status: StatusModel.parse(json['status']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
