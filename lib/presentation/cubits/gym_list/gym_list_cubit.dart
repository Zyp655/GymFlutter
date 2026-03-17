import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/gym.dart';
import '../../../domain/usecases/gym_commands.dart';
import '../../../domain/usecases/gym_queries.dart';
import 'gym_list_state.dart';

class GymListCubit extends Cubit<GymListState> {
  final GetAllGyms _getAllGyms;
  final DeleteGym _deleteGym;
  static const int _pageSize = 20;
  bool _isLoadingMore = false;

  GymListCubit({required GetAllGyms getAllGyms, required DeleteGym deleteGym})
    : _getAllGyms = getAllGyms,
      _deleteGym = deleteGym,
      super(GymListInitial());

  Future<void> loadGyms() async {
    emit(GymListLoading());
    try {
      final gyms = await _getAllGyms();
      emit(
        GymListLoaded(
          gyms: gyms,
          filteredGyms: gyms,
          hasMore: gyms.length >= _pageSize,
          currentPage: 0,
        ),
      );
    } catch (e) {
      emit(GymListError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! GymListLoaded) return;
    if (_isLoadingMore || !currentState.hasMore) return;

    _isLoadingMore = true;
    try {
      final nextPage = currentState.currentPage + 1;
      final newGyms = await _getAllGyms();
      final allGyms = [...currentState.gyms, ...newGyms];
      emit(
        currentState.copyWith(
          gyms: allGyms,
          filteredGyms: _applyFilters(
            allGyms,
            currentState.minRatingFilter,
            currentState.facilityFilters,
          ),
          currentPage: nextPage,
          hasMore: newGyms.length >= _pageSize,
        ),
      );
    } catch (_) {
    } finally {
      _isLoadingMore = false;
    }
  }

  void searchGyms(String query) {
    final currentState = state;
    if (currentState is GymListLoaded) {
      if (query.isEmpty) {
        emit(
          currentState.copyWith(
            filteredGyms: _applyFilters(
              currentState.gyms,
              currentState.minRatingFilter,
              currentState.facilityFilters,
            ),
            searchQuery: '',
          ),
        );
      } else {
        final filtered = currentState.gyms.where((gym) {
          final searchLower = query.toLowerCase();
          return gym.name.toLowerCase().contains(searchLower) ||
              gym.address.toLowerCase().contains(searchLower) ||
              gym.description.toLowerCase().contains(searchLower);
        }).toList();

        emit(
          currentState.copyWith(
            filteredGyms: _applyFilters(
              filtered,
              currentState.minRatingFilter,
              currentState.facilityFilters,
            ),
            searchQuery: query,
          ),
        );
      }
    }
  }

  void filterByRating(double? minRating) {
    final currentState = state;
    if (currentState is GymListLoaded) {
      final baseList = currentState.searchQuery.isEmpty
          ? currentState.gyms
          : currentState.gyms.where((gym) {
              final searchLower = currentState.searchQuery.toLowerCase();
              return gym.name.toLowerCase().contains(searchLower) ||
                  gym.address.toLowerCase().contains(searchLower);
            }).toList();

      emit(
        currentState.copyWith(
          filteredGyms: _applyFilters(
            baseList,
            minRating,
            currentState.facilityFilters,
          ),
          minRatingFilter: minRating,
          clearMinRating: minRating == null,
        ),
      );
    }
  }

  void filterByFacilities(List<String> facilities) {
    final currentState = state;
    if (currentState is GymListLoaded) {
      final baseList = currentState.searchQuery.isEmpty
          ? currentState.gyms
          : currentState.gyms.where((gym) {
              final searchLower = currentState.searchQuery.toLowerCase();
              return gym.name.toLowerCase().contains(searchLower) ||
                  gym.address.toLowerCase().contains(searchLower);
            }).toList();

      emit(
        currentState.copyWith(
          filteredGyms: _applyFilters(
            baseList,
            currentState.minRatingFilter,
            facilities,
          ),
          facilityFilters: facilities,
        ),
      );
    }
  }

  List<Gym> _applyFilters(
    List<Gym> gyms,
    double? minRating,
    List<String> facilities,
  ) {
    var filtered = gyms;

    if (minRating != null) {
      filtered = filtered.where((gym) => gym.rating >= minRating).toList();
    }

    if (facilities.isNotEmpty) {
      filtered = filtered.where((gym) {
        return facilities.every(
          (facility) => gym.facilities.any(
            (f) => f.toLowerCase().contains(facility.toLowerCase()),
          ),
        );
      }).toList();
    }

    return filtered;
  }

  Future<void> deleteGym(int id) async {
    final currentState = state;
    if (currentState is GymListLoaded) {
      try {
        await _deleteGym(id);
        final updatedGyms = currentState.gyms
            .where((gym) => gym.id != id)
            .toList();
        final updatedFiltered = currentState.filteredGyms
            .where((gym) => gym.id != id)
            .toList();
        emit(
          currentState.copyWith(
            gyms: updatedGyms,
            filteredGyms: updatedFiltered,
          ),
        );
      } catch (e) {
        emit(GymListError(e.toString()));
      }
    }
  }

  Future<void> refreshAfterUpdate() async {
    await loadGyms();
  }
}
