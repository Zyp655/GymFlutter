import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/widgets/gym_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

import '../../domain/entities/gym.dart';
import '../cubits/review/review_cubit.dart';
import '../cubits/review/review_state.dart';

class GymDetailAppBar extends StatelessWidget {
  final Gym gym;

  const GymDetailAppBar({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          gym.name,
          style: const TextStyle(
            shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            GymImage(imageUrl: gym.imageUrl),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    colorScheme.surface.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GymDetailHeader extends StatelessWidget {
  final Gym gym;

  const GymDetailHeader({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildBadge(
                    colorScheme: colorScheme,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 18, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          gym.rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  _buildBadge(
                    colorScheme: colorScheme,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          gym.openingHours,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      gym.address,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBadge({
    required ColorScheme colorScheme,
    required Widget child,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? colorScheme.surfaceContainerHigh).withValues(
          alpha: color != null ? 0.15 : 0.6,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (color ?? colorScheme.outline).withValues(
            alpha: color != null ? 0.3 : 0.2,
          ),
        ),
      ),
      child: child,
    );
  }
}

class GymGlassCard extends StatelessWidget {
  final Widget child;

  const GymGlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: child,
    );
  }
}

class GymSectionTitle extends StatelessWidget {
  final String title;

  const GymSectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: colorScheme.primary,
        fontSize: 13,
        letterSpacing: 1.2,
      ),
    );
  }
}

class GymContactCard extends StatelessWidget {
  final Gym gym;

  const GymContactCard({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GymGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GymSectionTitle(
            title: AppLocalizations.of(context)!.contactInformation,
          ),
          const SizedBox(height: 16),
          _buildContactRow(
            Icons.phone,
            AppLocalizations.of(context)!.phone,
            gym.phoneNumber,
            colorScheme,
          ),
          const SizedBox(height: 12),
          _buildContactRow(
            Icons.email,
            AppLocalizations.of(context)!.email,
            gym.email,
            colorScheme,
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    IconData icon,
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: colorScheme.outline, fontSize: 11),
            ),
            Text(
              value,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }
}

class GymDescriptionCard extends StatelessWidget {
  final String description;

  const GymDescriptionCard({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GymGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GymSectionTitle(title: AppLocalizations.of(context)!.about),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class GymFacilitiesCard extends StatelessWidget {
  final List<String> facilities;

  const GymFacilitiesCard({super.key, required this.facilities});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GymGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GymSectionTitle(
            title: AppLocalizations.of(context)!.premiumFacilities,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: facilities.map((facility) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getFacilityIcon(facility),
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      facility,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  IconData _getFacilityIcon(String facility) {
    final lower = facility.toLowerCase();
    if (lower.contains('pool') || lower.contains('swim')) return Icons.pool;
    if (lower.contains('sauna') || lower.contains('spa')) return Icons.spa;
    if (lower.contains('parking')) return Icons.local_parking;
    if (lower.contains('wifi')) return Icons.wifi;
    if (lower.contains('locker')) return Icons.lock;
    if (lower.contains('yoga') || lower.contains('meditation')) {
      return Icons.self_improvement;
    }
    if (lower.contains('boxing')) return Icons.sports_mma;
    if (lower.contains('crossfit') || lower.contains('training')) {
      return Icons.fitness_center;
    }
    if (lower.contains('juice') || lower.contains('bar')) {
      return Icons.local_drink;
    }
    if (lower.contains('weight') || lower.contains('lift')) {
      return Icons.fitness_center;
    }
    if (lower.contains('kid') || lower.contains('child')) {
      return Icons.child_care;
    }
    return Icons.check_circle;
  }
}

class GymStatisticsChart extends StatelessWidget {
  const GymStatisticsChart({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GymGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GymSectionTitle(
            title: AppLocalizations.of(context)!.peakHoursAnalytics,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      const hours = ['6AM', '9AM', '12PM', '3PM', '6PM', '9PM'];
                      return BarTooltipItem(
                        '${hours[groupIndex]}\n${rod.toY.toInt()}%',
                        TextStyle(color: colorScheme.primary),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const hours = [
                          '6AM',
                          '9AM',
                          '12PM',
                          '3PM',
                          '6PM',
                          '9PM',
                        ];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            hours[value.toInt()],
                            style: TextStyle(
                              fontSize: 10,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\${value.toInt()}%',
                          style: TextStyle(
                            fontSize: 10,
                            color: colorScheme.outline,
                          ),
                        );
                      },
                      reservedSize: 35,
                      interval: 25,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: colorScheme.outline.withValues(alpha: 0.15),
                    strokeWidth: 1,
                  ),
                ),
                barGroups: _generateBarGroups(colorScheme),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(ColorScheme colorScheme) {
    final data = [35, 75, 60, 45, 90, 55];
    return List.generate(6, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index].toDouble(),
            gradient: LinearGradient(
              colors: [
                colorScheme.primary.withValues(alpha: 0.6),
                colorScheme.primary,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 20,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    });
  }
}

class GymReviewsSection extends StatelessWidget {
  final Gym gym;

  const GymReviewsSection({super.key, required this.gym});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<ReviewCubit, ReviewState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(state, colorScheme),
              const SizedBox(height: 16),
              _buildContent(context, state, colorScheme),
              _buildAddReviewButton(context, colorScheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(ReviewState state, ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.rate_review,
                color: colorScheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        if (state is ReviewLoaded)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: colorScheme.primary, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${state.averageRating.toStringAsFixed(1)} (${state.reviewCount})',
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildContent(
    BuildContext context,
    ReviewState state,
    ColorScheme colorScheme,
  ) {
    if (state is ReviewLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CircularProgressIndicator(color: colorScheme.primary),
        ),
      );
    }

    if (state is ReviewLoaded) {
      if (state.reviews.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              'No reviews yet. Be the first!',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        );
      }

      return Column(
        children: [
          ...state.reviews.take(5).map((review) {
            final currentUser = FirebaseAuth.instance.currentUser;
            final isOwner = currentUser?.uid == review.userId;
            return _ReviewCard(
              review: review,
              isOwner: isOwner,
              gymId: gym.id!,
            );
          }),
          const SizedBox(height: 8),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildAddReviewButton(BuildContext context, ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          final user = FirebaseAuth.instance.currentUser;
          if (user == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.pleaseSignInToReview,
                ),
                action: SnackBarAction(
                  label: AppLocalizations.of(context)!.signIn,
                  onPressed: () => context.push('/login'),
                ),
              ),
            );
            return;
          }
          _showWriteReviewDialog(context, user);
        },
        icon: const Icon(Icons.edit, size: 18),
        label: Text(AppLocalizations.of(context)!.writeReview),
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.5)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  void _showWriteReviewDialog(BuildContext context, User user) {
    double selectedRating = 5.0;
    final commentController = TextEditingController();
    final reviewCubit = context.read<ReviewCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.writeReview),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () {
                      setDialogState(() {
                        selectedRating = i + 1.0;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        i < selectedRating ? Icons.star : Icons.star_border,
                        color: colorScheme.primary,
                        size: 36,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.shareExperience,
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHigh,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            FilledButton(
              onPressed: () {
                reviewCubit.addReview(
                  gymId: gym.id!,
                  userId: user.uid,
                  userName: user.displayName ?? user.email ?? 'User',
                  rating: selectedRating,
                  comment: commentController.text.trim(),
                );
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.reviewAdded),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context)!.submit),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final dynamic review;
  final bool isOwner;
  final int gymId;

  const _ReviewCard({
    required this.review,
    required this.isOwner,
    required this.gymId,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: colorScheme.primary.withValues(
                          alpha: 0.2,
                        ),
                        child: Text(
                          review.userName.isNotEmpty
                              ? review.userName[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.userName,
                              style: TextStyle(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy').format(review.createdAt),
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List.generate(5, (i) {
                      if (i < review.rating.floor()) {
                        return Icon(
                          Icons.star,
                          color: colorScheme.primary,
                          size: 14,
                        );
                      } else if (i < review.rating) {
                        return Icon(
                          Icons.star_half,
                          color: colorScheme.primary,
                          size: 14,
                        );
                      }
                      return Icon(
                        Icons.star_border,
                        color: colorScheme.primary.withValues(alpha: 0.3),
                        size: 14,
                      );
                    }),
                    if (isOwner) ...[
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          context.read<ReviewCubit>().deleteReview(
                            review.id!,
                            gymId,
                          );
                        },
                        child: Icon(
                          Icons.delete_outline,
                          color: colorScheme.error,
                          size: 16,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                review.comment,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
