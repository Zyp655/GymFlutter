import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/favorites_local_datasource.dart';
import '../../../data/services/openai_service.dart';
import '../../../domain/usecases/gym_queries.dart';
import 'recommendation_state.dart';

class RecommendationCubit extends Cubit<RecommendationState> {
  final OpenAIService _openAIService;
  final GetAllGyms _getAllGyms;
  final FavoritesLocalDataSource _favoritesDataSource;

  RecommendationCubit({
    required OpenAIService openAIService,
    required GetAllGyms getAllGyms,
    required FavoritesLocalDataSource favoritesDataSource,
  }) : _openAIService = openAIService,
       _getAllGyms = getAllGyms,
       _favoritesDataSource = favoritesDataSource,
       super(const RecommendationInitial());

  Future<void> loadRecommendations() async {
    emit(const RecommendationLoading());

    try {
      final allGyms = await _getAllGyms();
      final favoriteIds = await _favoritesDataSource.getFavoriteIds();
      final favoriteGyms = allGyms
          .where((g) => favoriteIds.contains(g.id))
          .toList();

      final result = await _openAIService.getRecommendations(
        allGyms: allGyms,
        favoriteGyms: favoriteGyms,
      );

      emit(RecommendationLoaded(recommendations: result));
    } catch (e) {
      emit(RecommendationError(message: e.toString()));
    }
  }
}
