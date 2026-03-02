import 'package:pluc/core/domain/enums/auth_provider.dart';

/// User entity representing an authenticated user.
/// Immutable class following the same pattern as other domain entities.
class User {
  final String id;
  final String username;
  final String? passwordHash;
  final AuthProvider authProvider;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.username,
    this.passwordHash,
    required this.authProvider,
    required this.createdAt,
  });

  /// Creates a copy with the specified fields updated
  User copyWith({
    String? id,
    String? username,
    String? passwordHash,
    AuthProvider? authProvider,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      authProvider: authProvider ?? this.authProvider,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          username == other.username &&
          passwordHash == other.passwordHash &&
          authProvider == other.authProvider &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      username.hashCode ^
      passwordHash.hashCode ^
      authProvider.hashCode ^
      createdAt.hashCode;

  @override
  String toString() {
    return 'User{id: $id, username: $username, authProvider: $authProvider, createdAt: $createdAt}';
  }
}
