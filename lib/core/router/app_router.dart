import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../domain/entities/gym.dart';
import '../../presentation/screens/ai_chat_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/signup_screen.dart';
import '../../presentation/screens/discovery_screen.dart';
import '../../presentation/screens/favorites_screen.dart';
import '../../presentation/screens/gym_detail_screen.dart';
import '../../presentation/screens/gym_form_screen.dart';
import '../../presentation/screens/main_shell.dart';
import '../../presentation/screens/onboarding_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/screens/recommendation_screen.dart';
import '../di/injection_container.dart';
import '../services/preferences_service.dart';
import '../../domain/usecases/gym_queries.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final prefsService = sl<PreferencesService>();
      final isOnboardingComplete = prefsService.isOnboardingComplete();
      final currentUser = FirebaseAuth.instance.currentUser;
      final location = state.matchedLocation;

      if (!isOnboardingComplete && location != '/onboarding') {
        return '/onboarding';
      }

      final protectedRoutes = ['/gym/new'];
      final isProtected =
          protectedRoutes.contains(location) || location.endsWith('/edit');

      if (isProtected && currentUser == null) {
        return '/login';
      }

      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'discovery',
                builder: (context, state) => const DiscoveryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                name: 'favorites',
                builder: (context, state) => const FavoritesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/ai-chat',
                name: 'ai-chat',
                builder: (context, state) => const AiChatScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/recommendations',
        name: 'recommendations',
        builder: (context, state) => const RecommendationScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/gym/new',
        name: 'gym-new',
        builder: (context, state) => const GymFormScreen(),
      ),
      GoRoute(
        path: '/gym/:id',
        name: 'gym-detail',
        builder: (context, state) {
          final gym = state.extra as Gym?;
          if (gym != null) {
            return GymDetailScreen(gym: gym);
          }
          final gymId = int.tryParse(state.pathParameters['id'] ?? '');
          if (gymId == null) {
            return Scaffold(
              appBar: AppBar(title: Text(AppLocalizations.of(context)!.error)),
              body: Center(
                child: Text(AppLocalizations.of(context)!.gymDataNotAvailable),
              ),
            );
          }
          return FutureBuilder<Gym?>(
            future: sl<GetGymById>()(gymId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              final fetchedGym = snapshot.data;
              if (fetchedGym != null) {
                return GymDetailScreen(gym: fetchedGym);
              }
              return Scaffold(
                appBar: AppBar(
                  title: Text(AppLocalizations.of(context)!.error),
                ),
                body: Center(
                  child: Text(
                    AppLocalizations.of(context)!.gymDataNotAvailable,
                  ),
                ),
              );
            },
          );
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'gym-edit',
            builder: (context, state) {
              final gymId = int.parse(state.pathParameters['id']!);
              return GymFormScreen(gymId: gymId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          '${AppLocalizations.of(context)!.pageNotFound}: ${state.error}',
        ),
      ),
    ),
  );
}
