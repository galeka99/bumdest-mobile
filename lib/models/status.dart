class StatusModel {
  final int id;
  final String label;

  StatusModel({
    required this.id,
    required this.label,
  });

  factory StatusModel.parse(dynamic json) {
    return StatusModel(
      id: json['id'],
      label: json['label'],
    );
  }
}