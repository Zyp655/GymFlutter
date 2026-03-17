import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/preferences_service.dart';
import 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final PreferencesService _preferencesService;

  ThemeCubit({required PreferencesService preferencesService})
    : _preferencesService = preferencesService,
      super(const ThemeState(themeMode: ThemeMode.light));

  void loadTheme() {
    final savedMode = _preferencesService.getThemeMode();
    emit(ThemeState(themeMode: savedMode));
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _preferencesService.setThemeMode(mode);
    emit(ThemeState(themeMode: mode));
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }
}
