abstract class AuthRepository {
  /// Authenticate with username and password
  Future<bool> signIn(String username, String password);

  /// Register a new user
  Future<bool> register(String username, String password);

  /// Sign out current user
  Future<void> signOut();

  /// Current user identifier, null if not signed in
  String? getCurrentUserId();
}
