import '../database.dart';
import '../auth_repository.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class LocalAuthRepository implements AuthRepository {
  final AppDatabase db;

  LocalAuthRepository(this.db);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  @override
  Future<bool> register(String username, String password) async {
    final id = username; // simple primary key
    final hash = _hashPassword(password);
    try {
      await db.into(db.users).insert(
        UsersCompanion(
          id: Value(id),
          username: Value(username),
          passwordHash: Value(hash),
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signIn(String username, String password) async {
    final hash = _hashPassword(password);
    final result = await db.select(db.users)
        .where((u) => u.username.equals(username) & u.passwordHash.equals(hash))
        .get();
    return result.isNotEmpty;
  }

  @override
  Future<void> signOut() async {
    // nothing for local
  }

  @override
  String? getCurrentUserId() {
    // not tracked yet
    return null;
  }
}
