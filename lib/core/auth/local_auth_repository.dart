import '../database.dart' as db;
import '../auth_repository.dart';
import '../domain/entities/user.dart' as domain;
import '../domain/enums/auth_provider.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Local authentication implementation using database storage.
/// Hashes passwords and returns User entities.
class LocalAuthRepository implements AuthRepository {
  final db.AppDatabase database;
  final Uuid _uuid = const Uuid();
  domain.User? _currentUser;

  LocalAuthRepository(this.database);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  @override
  Future<domain.User?> registerLocal(String username, String password) async {
    final id = _uuid.v4();
    final hash = _hashPassword(password);
    final now = DateTime.now();

    try {
      await database.into(database.users).insert(
            db.UsersCompanion(
              id: Value(id),
              username: Value(username),
              passwordHash: Value(hash),
              authProvider: Value('local'),
              createdAt: Value(now),
            ),
          );

      final user = domain.User(
        id: id,
        username: username,
        passwordHash: hash,
        authProvider: AuthProvider.local,
        createdAt: now,
      );
      _currentUser = user;
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<domain.User?> signInLocal(String username, String password) async {
    final hash = _hashPassword(password);
    final result = await (database.select(database.users)
          ..where(
              (u) => u.username.equals(username) & u.passwordHash.equals(hash)))
        .getSingleOrNull();

    if (result == null) return null;

    final user = domain.User(
      id: result.id,
      username: result.username,
      passwordHash: result.passwordHash,
      authProvider: _parseAuthProvider(result.authProvider),
      createdAt: result.createdAt,
    );
    _currentUser = user;
    return user;
  }

  @override
  Future<domain.User?> signInWithGoogle() async {
    // TODO: Implement Google OAuth
    throw UnimplementedError('Google OAuth not yet implemented');
  }

  @override
  Future<domain.User?> signInWithApple() async {
    // TODO: Implement Apple OAuth
    throw UnimplementedError('Apple OAuth not yet implemented');
  }

  @override
  Future<domain.User?> signInWithMeta() async {
    // TODO: Implement Meta OAuth
    throw UnimplementedError('Meta OAuth not yet implemented');
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }

  @override
  domain.User? getCurrentUser() {
    return _currentUser;
  }

  // Legacy methods for backward compatibility
  @override
  @Deprecated('Use registerLocal instead')
  Future<bool> register(String username, String password) async {
    final user = await registerLocal(username, password);
    return user != null;
  }

  @override
  @Deprecated('Use signInLocal instead')
  Future<bool> signIn(String username, String password) async {
    final user = await signInLocal(username, password);
    return user != null;
  }

  @override
  @Deprecated('Use getCurrentUser instead')
  String? getCurrentUserId() {
    return _currentUser?.id;
  }

  AuthProvider _parseAuthProvider(String provider) {
    switch (provider.toLowerCase()) {
      case 'google':
        return AuthProvider.google;
      case 'apple':
        return AuthProvider.apple;
      case 'meta':
        return AuthProvider.meta;
      default:
        return AuthProvider.local;
    }
  }
}
