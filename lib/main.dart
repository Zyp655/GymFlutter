import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'l10n/app_localizations.dart';

import 'core/config/app_config.dart';
import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/services/app_logger.dart';
import 'core/services/notification_service.dart';
import 'core/services/preferences_service.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/offline_banner.dart';
import 'data/datasources/favorites_local_datasource.dart';
import 'data/services/openai_service.dart';
import 'domain/usecases/gym_commands.dart';
import 'domain/usecases/gym_queries.dart';
import 'presentation/cubits/auth/auth_cubit.dart';
import 'presentation/cubits/auth/auth_state.dart';
import 'presentation/cubits/ai_chat/ai_chat_cubit.dart';
import 'presentation/cubits/connectivity/connectivity_cubit.dart';
import 'presentation/cubits/connectivity/connectivity_state.dart';
import 'presentation/cubits/favorites/favorites_cubit.dart';
import 'presentation/cubits/gym_list/gym_list_cubit.dart';
import 'presentation/cubits/locale/locale_cubit.dart';
import 'presentation/cubits/sync/sync_cubit.dart';
import 'presentation/cubits/theme/theme_cubit.dart';
import 'presentation/cubits/theme/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await AppConfig.initialize();
  await initializeDependencies();
  await NotificationService.instance.initialize();

  AppLogger.i('App starting in ${AppConfig.environment.name} mode');

  runApp(const GymDiscoveryApp());
}

class GymDiscoveryApp extends StatelessWidget {
  const GymDiscoveryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ThemeCubit(preferencesService: sl<PreferencesService>())
                ..loadTheme(),
        ),
        BlocProvider(create: (_) => ConnectivityCubit()..startMonitoring()),
        BlocProvider(
          create: (_) => GymListCubit(
            getAllGyms: sl<GetAllGyms>(),
            deleteGym: sl<DeleteGym>(),
          )..loadGyms(),
        ),
        BlocProvider(
          create: (_) =>
              FavoritesCubit(dataSource: FavoritesLocalDataSource())
                ..loadFavorites(),
        ),
        BlocProvider(create: (_) => SyncCubit()..startAutoSync()),
        BlocProvider(
          create: (_) =>
              AuthCubit(preferencesService: sl<PreferencesService>())
                ..listenToAuthChanges(),
        ),
        BlocProvider(
          create: (_) =>
              LocaleCubit(preferencesService: sl<PreferencesService>())
                ..loadLocale(),
        ),
        BlocProvider(
          create: (_) => AiChatCubit(openAIService: sl<OpenAIService>()),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return BlocBuilder<ConnectivityCubit, ConnectivityState>(
            builder: (context, connectivityState) {
              return BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, localeState) {
                  return BlocListener<AuthCubit, AuthState>(
                    listener: (context, authState) {
                      if (authState is Authenticated) {
                        AppLogger.i('Auth restored: ${authState.user.email}');
                      }
                    },
                    child: MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      title: AppConfig.appName,
                      theme: AppTheme.lightTheme,
                      darkTheme: AppTheme.darkTheme,
                      themeMode: themeState.themeMode,
                      locale: localeState.locale,
                      supportedLocales: AppLocalizations.supportedLocales,
                      localizationsDelegates:
                          AppLocalizations.localizationsDelegates,
                      routerConfig: AppRouter.router,
                      builder: (context, child) {
                        return Column(
                          children: [
                            if (connectivityState is DisconnectedState)
                              const OfflineBanner(),
                            Expanded(child: child ?? const SizedBox.shrink()),
                          ],
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
