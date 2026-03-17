import 'package:equatable/equatable.dart';

import '../../../domain/entities/review.dart';

abstract class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<Review> reviews;
  final double averageRating;
  final int reviewCount;

  const ReviewLoaded({
    required this.reviews,
    required this.averageRating,
    required this.reviewCount,
  });

  @override
  List<Object?> get props => [reviews, averageRating, reviewCount];
}

class ReviewError extends ReviewState {
  final String message;

  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
