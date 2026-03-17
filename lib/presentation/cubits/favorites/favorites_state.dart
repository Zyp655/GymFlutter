import 'package:equatable/equatable.dart';

class FavoritesState extends Equatable {
  final Set<int> favoriteIds;
  final bool isLoading;

  const FavoritesState({this.favoriteIds = const {}, this.isLoading = false});

  FavoritesState copyWith({Set<int>? favoriteIds, bool? isLoading}) {
    return FavoritesState(
      favoriteIds: favoriteIds ?? this.favoriteIds,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  bool isFavorite(int gymId) => favoriteIds.contains(gymId);

  @override
  List<Object?> get props => [favoriteIds, isLoading];
}
