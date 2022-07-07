class PaymentMethodModel {
  final int id;
  final String label;

  PaymentMethodModel({
    required this.id,
    required this.label,
  });

  factory PaymentMethodModel.parse(dynamic json) {
    return PaymentMethodModel(
      id: json['id'],
      label: json['label'],
    );
  }
}