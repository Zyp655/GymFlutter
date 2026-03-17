import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/preferences_service.dart';

class LocaleState {
  final Locale locale;
  const LocaleState(this.locale);
}

class LocaleCubit extends Cubit<LocaleState> {
  final PreferencesService _prefs;
  static const String _localeKey = 'app_locale';

  LocaleCubit({required PreferencesService preferencesService})
    : _prefs = preferencesService,
      super(const LocaleState(Locale('en')));

  void loadLocale() {
    final saved = _prefs.getString(_localeKey);
    if (saved != null && saved.isNotEmpty) {
      emit(LocaleState(Locale(saved)));
    }
  }

  void changeLocale(Locale locale) {
    _prefs.setString(_localeKey, locale.languageCode);
    emit(LocaleState(locale));
  }
}
