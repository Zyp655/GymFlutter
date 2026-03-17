import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Icon(
                icon,
                size: 60,
                color: colorScheme.primary.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: 12),
              Text(
                description!,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onAction,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add, color: colorScheme.onPrimary),
                          const SizedBox(width: 8),
                          Text(
                            actionLabel!,
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
