class ReviewModel {
  final int id;
  final int rating;
  final String description;
  final int visitorId;
  final String visitorName;
  final String visitorImage;
  final String createdAt;
  final String updatedAt;

  ReviewModel({
    required this.id,
    required this.rating,
    required this.description,
    required this.visitorId,
    required this.visitorName,
    required this.visitorImage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewModel.parse(dynamic json) {
    return ReviewModel(
      id: json['id'],
      rating: json['rating'],
      description: json['description'],
      visitorId: json['visitor']['id'],
      visitorName: json['visitor']['name'],
      visitorImage: json['visitor']['image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
