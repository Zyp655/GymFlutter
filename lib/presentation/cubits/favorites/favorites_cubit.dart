import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/app_logger.dart';
import '../../../data/datasources/favorites_local_datasource.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesLocalDataSource _dataSource;

  FavoritesCubit({FavoritesLocalDataSource? dataSource})
    : _dataSource = dataSource ?? FavoritesLocalDataSource(),
      super(const FavoritesState());

  Future<void> loadFavorites() async {
    emit(state.copyWith(isLoading: true));
    try {
      final ids = await _dataSource.getFavoriteIds();
      emit(state.copyWith(favoriteIds: ids.toSet(), isLoading: false));
    } catch (e, stackTrace) {
      AppLogger.e('Failed to load favorites', e, stackTrace);
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> toggleFavorite(int gymId) async {
    try {
      await _dataSource.toggleFavorite(gymId);
      final updatedIds = Set<int>.from(state.favoriteIds);
      if (updatedIds.contains(gymId)) {
        updatedIds.remove(gymId);
      } else {
        updatedIds.add(gymId);
      }
      emit(state.copyWith(favoriteIds: updatedIds));
    } catch (e, stackTrace) {
      AppLogger.e('Failed to toggle favorite for gym $gymId', e, stackTrace);
    }
  }

  bool isFavorite(int gymId) => state.isFavorite(gymId);
}
