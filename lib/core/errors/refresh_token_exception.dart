class RefreshTokenExpiredException implements Exception {
  RefreshTokenExpiredException();

  @override
  String toString() => 'Refresh token has expired';
}

class ConnectionException implements Exception {
  ConnectionException();
  @override
  String toString() => 'No internet connection';
}
