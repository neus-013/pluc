import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';
import 'auth/local_auth_repository.dart';
import 'database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final db = ref.read(databaseProvider);
  return LocalAuthRepository(db);
});
