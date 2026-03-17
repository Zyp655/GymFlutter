import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection_container.dart';
import '../../core/theme/app_colors.dart';
import '../../data/datasources/favorites_local_datasource.dart';
import '../../data/services/openai_service.dart';
import '../../domain/usecases/gym_queries.dart';
import '../../l10n/app_localizations.dart';
import '../cubits/recommendation/recommendation_cubit.dart';
import '../cubits/recommendation/recommendation_state.dart';

class RecommendationScreen extends StatelessWidget {
  const RecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecommendationCubit(
        openAIService: sl<OpenAIService>(),
        getAllGyms: sl<GetAllGyms>(),
        favoritesDataSource: FavoritesLocalDataSource(),
      )..loadRecommendations(),
      child: const _RecommendationView(),
    );
  }
}

class _RecommendationView extends StatelessWidget {
  const _RecommendationView();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.recommendations),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: colorScheme.primary),
            onPressed: () {
              HapticFeedback.mediumImpact();
              context.read<RecommendationCubit>().loadRecommendations();
            },
          ),
        ],
      ),
      body: BlocBuilder<RecommendationCubit, RecommendationState>(
        builder: (context, state) {
          if (state is RecommendationLoading) {
            return _buildLoading(colorScheme, l10n);
          }

          if (state is RecommendationError) {
            return _buildError(context, colorScheme, state.message, l10n);
          }

          if (state is RecommendationLoaded) {
            return _buildLoaded(colorScheme, state.recommendations);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoading(ColorScheme colorScheme, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppColors.goldGlowDecoration(borderRadius: 24),
            child: const Icon(
              Icons.auto_awesome,
              size: 40,
              color: AppColors.navyDark,
            ),
          ),
          const SizedBox(height: 24),
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            l10n.aiThinking,
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildError(
    BuildContext context,
    ColorScheme colorScheme,
    String message,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              l10n.oopsError,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                context.read<RecommendationCubit>().loadRecommendations();
              },
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoaded(ColorScheme colorScheme, String recommendations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppColors.glassmorphismDecoration(
          borderRadius: 20,
          withGoldBorder: true,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.stars_rounded,
                    color: AppColors.navyDark,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI Recommendations',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: colorScheme.outline.withValues(alpha: 0.15)),
            const SizedBox(height: 12),
            Text(
              recommendations,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 14,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
