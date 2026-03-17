import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final int? id;
  final int gymId;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final List<String> photoUrls;
  final DateTime createdAt;

  const Review({
    this.id,
    required this.gymId,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    this.photoUrls = const [],
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    gymId,
    userId,
    rating,
    comment,
    photoUrls,
    createdAt,
  ];
}
