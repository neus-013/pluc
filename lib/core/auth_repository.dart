import 'package:pluc/core/domain/entities/user.dart';

/// Abstract authentication repository supporting multiple providers.
/// Implementations provide local auth and OAuth integrations.
abstract class AuthRepository {
  /// Authenticate with local username and password
  Future<User?> signInLocal(String username, String password);

  /// Authenticate with Google OAuth
  Future<User?> signInWithGoogle();

  /// Authenticate with Apple OAuth
  Future<User?> signInWithApple();

  /// Authenticate with Meta (Facebook) OAuth
  Future<User?> signInWithMeta();

  /// Register a new local user
  Future<User?> registerLocal(String username, String password);

  /// Sign out current user
  Future<void> signOut();

  /// Current authenticated user, null if not signed in
  User? getCurrentUser();

  // Legacy methods for backward compatibility - to be removed
  @Deprecated('Use signInLocal instead')
  Future<bool> signIn(String username, String password);

  @Deprecated('Use registerLocal instead')
  Future<bool> register(String username, String password);

  @Deprecated('Use getCurrentUser instead')
  String? getCurrentUserId();
}
