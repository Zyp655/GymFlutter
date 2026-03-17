import '../../core/widgets/gym_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/gym.dart';
import '../cubits/favorites/favorites_cubit.dart';
import '../cubits/favorites/favorites_state.dart';

class GymCard extends StatelessWidget {
  final Gym gym;
  final VoidCallback onTap;

  const GymCard({super.key, required this.gym, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(context, colorScheme),
              _buildContent(context, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context, ColorScheme colorScheme) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: GymImage(imageUrl: gym.imageUrl),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: _buildFavoriteButton(context, colorScheme),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton(BuildContext context, ColorScheme colorScheme) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favState) {
        final isFav = favState.isFavorite(gym.id ?? -1);
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface.withValues(alpha: 0.8),
            shape: BoxShape.circle,
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () {
              HapticFeedback.lightImpact();
              context.read<FavoritesCubit>().toggleFavorite(gym.id ?? -1);
            },
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: isFav ? 1.2 : 1.0),
              duration: const Duration(milliseconds: 200),
              curve: Curves.elasticOut,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav
                          ? colorScheme.error
                          : colorScheme.onSurfaceVariant,
                      size: 22,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  gym.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildRatingBadge(colorScheme),
            ],
          ),
          const SizedBox(height: 8),
          _buildInfoRow(Icons.location_on, gym.address, colorScheme),
          const SizedBox(height: 6),
          _buildInfoRow(
            Icons.access_time,
            gym.openingHours,
            colorScheme,
            fontSize: 12,
          ),
          const SizedBox(height: 10),
          _buildFacilityChips(colorScheme),
        ],
      ),
    );
  }

  Widget _buildRatingBadge(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 14, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            gym.rating.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String text,
    ColorScheme colorScheme, {
    double fontSize = 13,
  }) {
    return Row(
      children: [
        Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: fontSize,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFacilityChips(ColorScheme colorScheme) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: gym.facilities.take(3).map((facility) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            facility,
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
        );
      }).toList(),
    );
  }
}
