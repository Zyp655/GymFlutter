import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';


import '../cubits/auth/auth_cubit.dart';
import '../cubits/auth/auth_state.dart';
import '../cubits/favorites/favorites_cubit.dart';
import '../cubits/favorites/favorites_state.dart';
import '../cubits/locale/locale_cubit.dart';
import '../cubits/sync/sync_cubit.dart';
import '../cubits/sync/sync_state.dart';
import '../cubits/theme/theme_cubit.dart';
import '../cubits/theme/theme_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    context.read<AuthCubit>().checkAuthState();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.profile,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(l10n.signedOutSuccess)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }
          if (state is Authenticated) {
            return _buildAuthenticatedProfile(
              context,
              state.user,
              colorScheme,
            );
          }
          return _buildUnauthenticatedProfile(context, colorScheme);
        },
      ),
    );
  }

  Widget _buildAuthenticatedProfile(
    BuildContext context,
    User user,
    ColorScheme colorScheme,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final initial = (user.email ?? 'U')[0].toUpperCase();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 104,
            height: 104,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: colorScheme.primary, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.2),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            user.email ?? l10n.noEmail,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.memberSince(_formatDate(user.metadata.creationTime)),
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 28),

          _buildStatsSection(context, colorScheme),
          const SizedBox(height: 20),

          _buildSettingsSection(context, colorScheme),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.read<AuthCubit>().signOut();
              },
              icon: const Icon(Icons.logout),
              label: Text(l10n.signOut),
              style: OutlinedButton.styleFrom(
                foregroundColor: colorScheme.error,
                side: BorderSide(color: colorScheme.error),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnauthenticatedProfile(
    BuildContext context,
    ColorScheme colorScheme,
  ) {
    final l10n = AppLocalizations.of(context)!;
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
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                Icons.person_outline,
                size: 60,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.signInToAccount,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.syncFavorites,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: Container(
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
                    onTap: () => context.push('/login'),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: colorScheme.onPrimary),
                          const SizedBox(width: 8),
                          Text(
                            l10n.signIn,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => context.push('/signup'),
                icon: const Icon(Icons.person_add),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    l10n.createAccount,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              return _StatCard(
                icon: Icons.favorite,
                label: l10n.favoritesCount,
                value: '${state.favoriteIds.length}',
                color: colorScheme.error,
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: BlocBuilder<SyncCubit, SyncState>(
            builder: (context, state) {
              String status = l10n.synced;
              Color color = Colors.green;
              if (state is SyncInProgress) {
                status = l10n.syncing;
                color = Colors.orange;
              } else if (state is SyncError) {
                status = 'Error';
                color = colorScheme.error;
              }
              return _StatCard(
                icon: Icons.sync,
                label: l10n.syncStatus,
                value: status,
                color: color,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context, ColorScheme colorScheme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return ListTile(
                leading: Icon(
                  _getThemeIcon(state.themeMode),
                  color: colorScheme.primary,
                ),
                title: Text(
                  l10n.theme,
                  style: TextStyle(color: colorScheme.onSurface),
                ),
                subtitle: Text(
                  _getThemeLabel(state.themeMode),
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurfaceVariant,
                ),
                onTap: () {
                  HapticFeedback.selectionClick();
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
          Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.2)),
          BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, state) {
              final isVi = state.locale.languageCode == 'vi';
              return Semantics(
                label:
                    'Language setting. Currently ${isVi ? "Vietnamese" : "English"}',
                button: true,
                child: ListTile(
                  leading: Icon(Icons.language, color: colorScheme.primary),
                  title: Text(
                    l10n.languageName,
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  subtitle: Text(
                    isVi ? l10n.vietnamese : l10n.english,
                    style: TextStyle(color: colorScheme.onSurfaceVariant),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    final newLocale = isVi
                        ? const Locale('en')
                        : const Locale('vi');
                    context.read<LocaleCubit>().changeLocale(newLocale);
                  },
                ),
              );
            },
          ),
          Divider(height: 1, color: colorScheme.outline.withValues(alpha: 0.2)),
          ListTile(
            leading: Icon(Icons.info_outline, color: colorScheme.primary),
            title: Text(
              l10n.appVersion,
              style: TextStyle(color: colorScheme.onSurface),
            ),
            subtitle: Text(
              '1.0.0',
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getThemeIcon(ThemeMode mode) {
    return mode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode;
  }

  String _getThemeLabel(ThemeMode mode) {
    return mode == ThemeMode.dark ? 'Dark' : 'Light';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
