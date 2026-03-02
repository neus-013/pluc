/// Authentication provider types for user authentication.
/// Supports local authentication and OAuth providers.
enum AuthProvider {
  /// Local username/password authentication
  local,

  /// Google OAuth authentication
  google,

  /// Apple OAuth authentication
  apple,

  /// Meta (Facebook) OAuth authentication
  meta,
}
