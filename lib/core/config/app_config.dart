import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/app_logger.dart';

enum Environment { dev, staging, prod }

class AppConfig {
  AppConfig._();

  static late Environment _environment;

  static Environment get environment => _environment;
  static bool get isDev => _environment == Environment.dev;
  static bool get isStaging => _environment == Environment.staging;
  static bool get isProd => _environment == Environment.prod;

  static String get appName => _safeGet('APP_NAME', 'GymFit Pro');
  static String get logLevel => _safeGet('LOG_LEVEL', 'info');

  static String _safeGet(String key, String defaultValue) {
    try {
      return dotenv.env[key] ?? defaultValue;
    } catch (_) {
      return defaultValue;
    }
  }

  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      AppLogger.w('.env file not found, using defaults');
    }

    final envString = _safeGet('ENVIRONMENT', 'dev');
    _environment = Environment.values.firstWhere(
      (e) => e.name == envString,
      orElse: () => Environment.dev,
    );
  }
}
