import 'package:equatable/equatable.dart';

import '../../../domain/entities/gym.dart';

abstract class GymListState extends Equatable {
  const GymListState();

  @override
  List<Object?> get props => [];
}

class GymListInitial extends GymListState {}

class GymListLoading extends GymListState {}

class GymListLoaded extends GymListState {
  final List<Gym> gyms;
  final List<Gym> filteredGyms;
  final String searchQuery;
  final double? minRatingFilter;
  final List<String> facilityFilters;
  final bool hasMore;
  final int currentPage;

  const GymListLoaded({
    required this.gyms,
    required this.filteredGyms,
    this.searchQuery = '',
    this.minRatingFilter,
    this.facilityFilters = const [],
    this.hasMore = true,
    this.currentPage = 0,
  });

  GymListLoaded copyWith({
    List<Gym>? gyms,
    List<Gym>? filteredGyms,
    String? searchQuery,
    double? minRatingFilter,
    List<String>? facilityFilters,
    bool clearMinRating = false,
    bool? hasMore,
    int? currentPage,
  }) {
    return GymListLoaded(
      gyms: gyms ?? this.gyms,
      filteredGyms: filteredGyms ?? this.filteredGyms,
      searchQuery: searchQuery ?? this.searchQuery,
      minRatingFilter: clearMinRating
          ? null
          : (minRatingFilter ?? this.minRatingFilter),
      facilityFilters: facilityFilters ?? this.facilityFilters,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [
    gyms,
    filteredGyms,
    searchQuery,
    minRatingFilter,
    facilityFilters,
    hasMore,
    currentPage,
  ];
}

class GymListError extends GymListState {
  final String message;

  const GymListError(this.message);

  @override
  List<Object?> get props => [message];
}
