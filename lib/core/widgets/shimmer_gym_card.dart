import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGymCard extends StatelessWidget {
  const ShimmerGymCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Shimmer.fromColors(
      baseColor: colorScheme.surfaceContainer,
      highlightColor: colorScheme.surfaceContainerHighest,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.onSurface.withValues(alpha: 0.06),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 180,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 24,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 220,
                    height: 16,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 150,
                    height: 14,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(
                      3,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 8),
                        width: 60,
                        height: 28,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerGymList extends StatelessWidget {
  final int itemCount;

  const ShimmerGymList({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => const ShimmerGymCard(),
          childCount: itemCount,
        ),
      ),
    );
  }
}
