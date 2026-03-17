import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btlmobile/data/datasources/favorites_local_datasource.dart';
import 'package:btlmobile/presentation/cubits/favorites/favorites_cubit.dart';
import 'package:btlmobile/presentation/cubits/favorites/favorites_state.dart';

class MockFavoritesDataSource extends Mock
    implements FavoritesLocalDataSource {}

void main() {
  late MockFavoritesDataSource mockDataSource;
  late FavoritesCubit cubit;

  setUp(() {
    mockDataSource = MockFavoritesDataSource();
    cubit = FavoritesCubit(dataSource: mockDataSource);
  });

  tearDown(() {
    cubit.close();
  });

  group('FavoritesCubit', () {
    test('initial state has empty favorites', () {
      expect(cubit.state.favoriteIds, isEmpty);
      expect(cubit.state.isLoading, isFalse);
    });

    blocTest<FavoritesCubit, FavoritesState>(
      'loadFavorites emits state with loaded IDs',
      build: () {
        when(
          () => mockDataSource.getFavoriteIds(),
        ).thenAnswer((_) async => [1, 2, 3]);
        return cubit;
      },
      act: (cubit) => cubit.loadFavorites(),
      expect: () => [
        const FavoritesState(isLoading: true),
        isA<FavoritesState>()
            .having((s) => s.favoriteIds, 'ids', {1, 2, 3})
            .having((s) => s.isLoading, 'loading', false),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'loadFavorites emits empty on error',
      build: () {
        when(
          () => mockDataSource.getFavoriteIds(),
        ).thenThrow(Exception('DB error'));
        return cubit;
      },
      act: (cubit) => cubit.loadFavorites(),
      expect: () => [
        const FavoritesState(isLoading: true),
        const FavoritesState(isLoading: false),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'toggleFavorite adds ID when not favorite',
      build: () {
        when(() => mockDataSource.toggleFavorite(1)).thenAnswer((_) async {});
        return cubit;
      },
      seed: () => const FavoritesState(favoriteIds: {}),
      act: (cubit) => cubit.toggleFavorite(1),
      expect: () => [
        isA<FavoritesState>().having((s) => s.favoriteIds, 'ids', {1}),
      ],
    );

    blocTest<FavoritesCubit, FavoritesState>(
      'toggleFavorite removes ID when already favorite',
      build: () {
        when(() => mockDataSource.toggleFavorite(1)).thenAnswer((_) async {});
        return cubit;
      },
      seed: () => const FavoritesState(favoriteIds: {1, 2}),
      act: (cubit) => cubit.toggleFavorite(1),
      expect: () => [
        isA<FavoritesState>().having((s) => s.favoriteIds, 'ids', {2}),
      ],
    );

    test('isFavorite returns correct result', () {
      cubit.emit(const FavoritesState(favoriteIds: {1, 3}));
      expect(cubit.isFavorite(1), isTrue);
      expect(cubit.isFavorite(2), isFalse);
      expect(cubit.isFavorite(3), isTrue);
    });
  });
}
