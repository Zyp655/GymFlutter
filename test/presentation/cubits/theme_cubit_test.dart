import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:btlmobile/core/services/preferences_service.dart';
import 'package:btlmobile/presentation/cubits/theme/theme_cubit.dart';

class MockPreferencesService extends Mock implements PreferencesService {}

void main() {
  late MockPreferencesService mockPrefsService;
  late ThemeCubit cubit;

  setUp(() {
    mockPrefsService = MockPreferencesService();
    cubit = ThemeCubit(preferencesService: mockPrefsService);
  });

  tearDown(() {
    cubit.close();
  });

  group('ThemeCubit', () {
    test('initial state is system theme', () {
      expect(cubit.state.themeMode, ThemeMode.system);
    });

    test('loadTheme loads saved theme from preferences', () {
      when(() => mockPrefsService.getThemeMode()).thenReturn(ThemeMode.dark);

      cubit.loadTheme();

      expect(cubit.state.themeMode, ThemeMode.dark);
    });

    test('setThemeMode saves and emits new theme', () async {
      when(
        () => mockPrefsService.setThemeMode(ThemeMode.light),
      ).thenAnswer((_) async {});

      await cubit.setThemeMode(ThemeMode.light);

      expect(cubit.state.themeMode, ThemeMode.light);
      verify(() => mockPrefsService.setThemeMode(ThemeMode.light)).called(1);
    });

    test('toggleTheme cycles light -> dark -> system -> light', () async {
      when(
        () => mockPrefsService.setThemeMode(ThemeMode.light),
      ).thenAnswer((_) async {});
      when(
        () => mockPrefsService.setThemeMode(ThemeMode.dark),
      ).thenAnswer((_) async {});
      when(
        () => mockPrefsService.setThemeMode(ThemeMode.system),
      ).thenAnswer((_) async {});
      when(() => mockPrefsService.getThemeMode()).thenReturn(ThemeMode.system);

      // system -> light
      cubit.loadTheme();
      await cubit.toggleTheme();
      expect(cubit.state.themeMode, ThemeMode.light);

      // light -> dark
      await cubit.toggleTheme();
      expect(cubit.state.themeMode, ThemeMode.dark);

      // dark -> system
      await cubit.toggleTheme();
      expect(cubit.state.themeMode, ThemeMode.system);
    });
  });
}
