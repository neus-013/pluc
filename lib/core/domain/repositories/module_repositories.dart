import 'package:pluc/core/entities.dart';

/// Repository abstraction for Habits module.
abstract class HabitRepository {
  Future<List<dynamic>> getAllHabits();
  Future<void> saveHabit(dynamic habit);
  Future<void> deleteHabit(String id);
  Future<List<dynamic>> getHabitsByDateRange(DateTime start, DateTime end);
}

/// Repository abstraction for Health module.
abstract class HealthRepository {
  Future<List<dynamic>> getAllRecords();
  Future<void> saveRecord(dynamic record);
  Future<void> deleteRecord(String id);
  Future<List<dynamic>> getRecordsByDateRange(DateTime start, DateTime end);
}

/// Repository abstraction for Nutrition module.
abstract class NutritionRepository {
  Future<List<dynamic>> getAllEntries();
  Future<void> saveEntry(dynamic entry);
  Future<void> deleteEntry(String id);
  Future<List<dynamic>> getEntriesByDateRange(DateTime start, DateTime end);
}

/// Repository abstraction for Finance module.
abstract class FinanceRepository {
  Future<List<dynamic>> getAllRecords();
  Future<void> saveRecord(dynamic record);
  Future<void> deleteRecord(String id);
  Future<List<dynamic>> getRecordsByDateRange(DateTime start, DateTime end);
}
