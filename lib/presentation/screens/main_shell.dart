import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: Icon(
              Icons.fitness_center_outlined,
              semanticLabel: l10n.discover,
            ),
            selectedIcon: Icon(
              Icons.fitness_center,
              color: colorScheme.primary,
              semanticLabel: l10n.discover,
            ),
            label: l10n.discover,
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline, semanticLabel: l10n.favorites),
            selectedIcon: Icon(
              Icons.favorite,
              color: colorScheme.primary,
              semanticLabel: l10n.favorites,
            ),
            label: l10n.favorites,
          ),
          NavigationDestination(
            icon: Icon(
              Icons.auto_awesome_outlined,
              semanticLabel: l10n.aiAssistant,
            ),
            selectedIcon: Icon(
              Icons.auto_awesome,
              color: colorScheme.primary,
              semanticLabel: l10n.aiAssistant,
            ),
            label: l10n.aiAssistant,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, semanticLabel: l10n.profile),
            selectedIcon: Icon(
              Icons.person,
              color: colorScheme.primary,
              semanticLabel: l10n.profile,
            ),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}
