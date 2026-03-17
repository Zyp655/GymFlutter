import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    super.id,
    required super.gymId,
    required super.userId,
    required super.userName,
    required super.rating,
    required super.comment,
    super.photoUrls,
    required super.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    final photosRaw = map['photo_urls'] as String?;
    final photoUrls = (photosRaw != null && photosRaw.isNotEmpty)
        ? photosRaw.split(',')
        : <String>[];

    return ReviewModel(
      id: map['id'] as int?,
      gymId: map['gym_id'] as int,
      userId: map['user_id'] as String,
      userName: map['user_name'] as String,
      rating: (map['rating'] as num).toDouble(),
      comment: map['comment'] as String,
      photoUrls: photoUrls,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'gym_id': gymId,
      'user_id': userId,
      'user_name': userName,
      'rating': rating,
      'comment': comment,
      'photo_urls': photoUrls.join(','),
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory ReviewModel.fromEntity(Review review) {
    return ReviewModel(
      id: review.id,
      gymId: review.gymId,
      userId: review.userId,
      userName: review.userName,
      rating: review.rating,
      comment: review.comment,
      photoUrls: review.photoUrls,
      createdAt: review.createdAt,
    );
  }
}
