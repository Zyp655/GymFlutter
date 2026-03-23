import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../core/di/injection_container.dart';
import '../../domain/entities/gym.dart';
import '../../domain/repositories/gym_repository.dart';
import '../../domain/repositories/review_repository.dart';
import '../cubits/gym_list/gym_list_cubit.dart';
import '../cubits/review/review_cubit.dart';
import '../widgets/gym_detail_widgets.dart';
import '../widgets/gym_location_card.dart';

class GymDetailScreen extends StatelessWidget {
  final Gym gym;

  const GymDetailScreen({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ReviewCubit(
            reviewRepository: sl<ReviewRepository>(),
            gymRepository: sl<GymRepository>(),
          )..loadReviews(gym.id!),
      child: _GymDetailBody(gym: gym),
    );
  }
}

class _GymDetailBody extends StatelessWidget {
  final Gym gym;

  const _GymDetailBody({required this.gym});

  bool get _isOwner {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || gym.createdBy == null) return false;
    return currentUser.uid == gym.createdBy;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          GymDetailAppBar(gym: gym),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GymDetailHeader(gym: gym),
                  const SizedBox(height: 20),
                  GymContactCard(gym: gym),
                  const SizedBox(height: 16),
                  GymDescriptionCard(description: gym.description),
                  const SizedBox(height: 16),
                  GymFacilitiesCard(facilities: gym.facilities),
                  const SizedBox(height: 16),
                  GymLocationCard(gym: gym),
                  const SizedBox(height: 16),
                  const GymStatisticsChart(),
                  const SizedBox(height: 16),
                  GymReviewsSection(gym: gym),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isOwner
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
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
                    heroTag: 'edit',
                    onPressed: () => context.push('/gym/${gym.id}/edit'),
                    backgroundColor: Colors.transparent,
                    foregroundColor: colorScheme.onPrimary,
                    elevation: 0,
                    child: const Icon(Icons.edit),
                  ),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'delete',
                  backgroundColor: colorScheme.error,
                  foregroundColor: Colors.white,
                  onPressed: () => _showDeleteConfirmation(context),
                  child: const Icon(Icons.delete),
                ),
              ],
            )
          : null,
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.deleteConfirmTitle),
        content: Text(l10n.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<GymListCubit>().deleteGym(gym.id!);
              context.pop();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.gymDeletedSuccess)));
            },
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
