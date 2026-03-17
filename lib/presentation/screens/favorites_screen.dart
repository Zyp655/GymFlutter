import '../../core/widgets/gym_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../core/widgets/empty_state_widget.dart';
import '../../domain/entities/gym.dart';
import '../cubits/favorites/favorites_cubit.dart';
import '../cubits/favorites/favorites_state.dart';
import '../cubits/gym_list/gym_list_cubit.dart';
import '../cubits/gym_list/gym_list_state.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.favorites,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, favoritesState) {
          return BlocBuilder<GymListCubit, GymListState>(
            builder: (context, gymListState) {
              if (gymListState is GymListLoading) {
                return Center(
                  child: CircularProgressIndicator(color: colorScheme.primary),
                );
              }

              if (gymListState is GymListLoaded) {
                final favoriteGyms = gymListState.gyms
                    .where((gym) => favoritesState.isFavorite(gym.id ?? -1))
                    .toList();

                if (favoriteGyms.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.favorite_border,
                    title: l10n.noFavorites,
                    description: l10n.noFavoritesDescription,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoriteGyms.length,
                  itemBuilder: (context, index) {
                    return _buildFavoriteCard(
                      context,
                      favoriteGyms[index],
                      colorScheme,
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    Gym gym,
    ColorScheme colorScheme,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('/gym/\${gym.id}', extra: gym);
          },
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: GymImage(
                    imageUrl: gym.imageUrl,
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        gym.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            gym.rating.toStringAsFixed(1),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: colorScheme.primary,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        gym.address,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  final isFav = state.isFavorite(gym.id ?? -1);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      context.read<FavoritesCubit>().toggleFavorite(
                        gym.id ?? -1,
                      );
                    },
                  );
                },
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
