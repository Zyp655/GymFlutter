import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off, size: 18, color: colorScheme.onErrorContainer),
          const SizedBox(width: 8),
          Text(
            'You are offline',
            style: TextStyle(
              color: colorScheme.onErrorContainer,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
