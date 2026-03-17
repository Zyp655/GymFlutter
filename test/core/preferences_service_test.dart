import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:btlmobile/core/services/preferences_service.dart';

void main() {
  late PreferencesService service;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    service = PreferencesService(sharedPreferences: prefs);
  });

  group('PreferencesService', () {
    group('ThemeMode', () {
      test('default theme mode is system', () {
        expect(service.getThemeMode(), ThemeMode.system);
      });

      test('setThemeMode and getThemeMode round-trip', () async {
        await service.setThemeMode(ThemeMode.dark);
        expect(service.getThemeMode(), ThemeMode.dark);

        await service.setThemeMode(ThemeMode.light);
        expect(service.getThemeMode(), ThemeMode.light);
      });
    });

    group('Onboarding', () {
      test('default onboarding is not complete', () {
        expect(service.isOnboardingComplete(), isFalse);
      });

      test('setOnboardingComplete persists value', () async {
        await service.setOnboardingComplete(true);
        expect(service.isOnboardingComplete(), isTrue);

        await service.setOnboardingComplete(false);
        expect(service.isOnboardingComplete(), isFalse);
      });
    });

    group('UserId', () {
      test('default userId is null', () {
        expect(service.getUserId(), isNull);
      });

      test('setUserId persists value', () async {
        await service.setUserId('user123');
        expect(service.getUserId(), 'user123');
      });

      test('setUserId null removes value', () async {
        await service.setUserId('user123');
        await service.setUserId(null);
        expect(service.getUserId(), isNull);
      });
    });
  });
}
