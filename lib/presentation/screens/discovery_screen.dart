import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../l10n/app_localizations.dart';
import '../../core/widgets/animated_list_item.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../core/widgets/shimmer_gym_card.dart';
import '../../domain/entities/gym.dart';
import '../cubits/favorites/favorites_cubit.dart';
import '../cubits/gym_list/gym_list_cubit.dart';
import '../cubits/gym_list/gym_list_state.dart';
import '../widgets/gym_card.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSearching = false;
  bool _isFabVisible = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse && _isFabVisible) {
      setState(() => _isFabVisible = false);
    } else if (direction == ScrollDirection.forward && !_isFabVisible) {
      setState(() => _isFabVisible = true);
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<GymListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        color: colorScheme.primary,
        onRefresh: () async {
          HapticFeedback.mediumImpact();
          context.read<GymListCubit>().loadGyms();
          context.read<FavoritesCubit>().loadFavorites();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            _buildAppBar(colorScheme),
            if (_isSearching) _buildSearchBar(),
            _buildFilterChips(colorScheme),
            _buildGymList(),
          ],
        ),
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 200),
        offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isFabVisible ? 1 : 0,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.secondary],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () => _navigateToForm(context),
              backgroundColor: Colors.transparent,
              foregroundColor: colorScheme.onPrimary,
              elevation: 0,
              child: const Icon(Icons.add, size: 28),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(ColorScheme colorScheme) {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      pinned: true,
      backgroundColor: colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          AppConstants.appName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        background: Container(color: colorScheme.surface),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isSearching ? Icons.close : Icons.search,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                context.read<GymListCubit>().searchGyms('');
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.4),
            ),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: TextStyle(color: colorScheme.onSurface),
            decoration: InputDecoration(
              hintText: l10n.searchHint,
              hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              prefixIcon: Icon(Icons.search, color: colorScheme.primary),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              filled: false,
            ),
            onChanged: (value) {
              _debounce?.cancel();
              _debounce = Timer(const Duration(milliseconds: 300), () {
                context.read<GymListCubit>().searchGyms(value);
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(ColorScheme colorScheme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: BlocBuilder<GymListCubit, GymListState>(
          builder: (context, state) {
            final selectedRating = state is GymListLoaded
                ? state.minRatingFilter
                : null;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildRatingChip(
                    AppLocalizations.of(context)!.all,
                    null,
                    selectedRating,
                  ),
                  const SizedBox(width: 8),
                  _buildRatingChip('4+ ⭐', 4.0, selectedRating),
                  const SizedBox(width: 8),
                  _buildRatingChip('4.5+ ⭐', 4.5, selectedRating),
                  const SizedBox(width: 8),
                  _buildRatingChip('5 ⭐', 5.0, selectedRating),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRatingChip(
    String label,
    double? rating,
    double? selectedRating,
  ) {
    final isSelected = rating == selectedRating;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        context.read<GymListCubit>().filterByRating(isSelected ? null : rating);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                )
              : null,
          color: isSelected ? null : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildGymList() {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<GymListCubit, GymListState>(
      builder: (context, state) {
        if (state is GymListLoading) {
          return const ShimmerGymList(itemCount: 3);
        }

        if (state is GymListError) {
          return SliverFillRemaining(
            child: EmptyStateWidget(
              icon: Icons.error_outline,
              title: l10n.oopsError,
              description: state.message,
              actionLabel: l10n.retry,
              onAction: () => context.read<GymListCubit>().loadGyms(),
            ),
          );
        }

        if (state is GymListLoaded) {
          if (state.filteredGyms.isEmpty) {
            return SliverFillRemaining(
              child: EmptyStateWidget(
                icon: Icons.fitness_center,
                title: l10n.noGymsFound,
                description: l10n.noGymsDescription,
                actionLabel: l10n.addGym,
                onAction: () => _navigateToForm(context),
              ),
            );
          }

          final itemCount = state.filteredGyms.length + (state.hasMore ? 1 : 0);
          return SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index >= state.filteredGyms.length) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    ),
                  );
                }
                final gym = state.filteredGyms[index];
                return AnimatedListItem(
                  index: index,
                  child: GymCard(
                    gym: gym,
                    onTap: () => _navigateToDetail(context, gym),
                  ),
                );
              }, childCount: itemCount),
            ),
          );
        }

        return const SliverFillRemaining(child: SizedBox.shrink());
      },
    );
  }

  void _navigateToDetail(BuildContext context, Gym gym) {
    context.push('/gym/${gym.id}', extra: gym).then((_) {
      if (context.mounted) context.read<GymListCubit>().loadGyms();
    });
  }

  void _navigateToForm(BuildContext context) {
    context.push('/gym/new').then((_) {
      if (context.mounted) context.read<GymListCubit>().loadGyms();
    });
  }
}
