import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class PreferencesService {
  final SharedPreferences _sharedPreferences;

  PreferencesService({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  Future<void> setThemeMode(ThemeMode mode) async {
    await _sharedPreferences.setString(AppConstants.keyThemeMode, mode.name);
  }

  ThemeMode getThemeMode() {
    final modeString = _sharedPreferences.getString(AppConstants.keyThemeMode);
    if (modeString == null) return ThemeMode.system;

    return ThemeMode.values.firstWhere(
      (mode) => mode.name == modeString,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setOnboardingComplete(bool complete) async {
    await _sharedPreferences.setBool(
      AppConstants.keyOnboardingComplete,
      complete,
    );
  }

  bool isOnboardingComplete() {
    return _sharedPreferences.getBool(AppConstants.keyOnboardingComplete) ??
        false;
  }

  Future<void> setUserId(String? userId) async {
    if (userId == null) {
      await _sharedPreferences.remove(AppConstants.keyUserId);
    } else {
      await _sharedPreferences.setString(AppConstants.keyUserId, userId);
    }
  }

  String? getUserId() {
    return _sharedPreferences.getString(AppConstants.keyUserId);
  }

  String? getString(String key) => _sharedPreferences.getString(key);
  Future<void> setString(String key, String value) =>
      _sharedPreferences.setString(key, value);
}
