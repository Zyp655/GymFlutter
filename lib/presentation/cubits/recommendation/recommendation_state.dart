import 'package:equatable/equatable.dart';

abstract class RecommendationState extends Equatable {
  const RecommendationState();

  @override
  List<Object?> get props => [];
}

class RecommendationInitial extends RecommendationState {
  const RecommendationInitial();
}

class RecommendationLoading extends RecommendationState {
  const RecommendationLoading();
}

class RecommendationLoaded extends RecommendationState {
  final String recommendations;

  const RecommendationLoaded({required this.recommendations});

  @override
  List<Object?> get props => [recommendations];
}

class RecommendationError extends RecommendationState {
  final String message;

  const RecommendationError({required this.message});

  @override
  List<Object?> get props => [message];
}
