class AppException implements Exception {
  final String message;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException(this.message, [this.originalError, this.stackTrace]);

  @override
  String toString() => 'AppException: $message';
}

class NetworkException extends AppException {
  const NetworkException(
    super.message, [
    super.originalError,
    super.stackTrace,
  ]);

  @override
  String toString() => 'NetworkException: $message';
}

class DatabaseException extends AppException {
  const DatabaseException(
    super.message, [
    super.originalError,
    super.stackTrace,
  ]);

  @override
  String toString() => 'DatabaseException: $message';
}

class AuthException extends AppException {
  final String? errorCode;

  const AuthException(
    String message, {
    this.errorCode,
    dynamic originalError,
    StackTrace? stackTrace,
  }) : super(message, originalError, stackTrace);

  @override
  String toString() => 'AuthException($errorCode): $message';
}
