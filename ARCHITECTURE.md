# Clean Architecture: Repository Layer Refactoring

## Overview

The repository layer has been refactored to enforce strict clean architecture boundaries. Each feature module now follows a consistent pattern:

```
Domain Layer (Interfaces)
    ↓
Data Layer (Implementations)
    ↓
Database (Drift)
```

## Architecture Structure

### 1. Domain Layer (UI-Independent)

**Location**: `lib/[module]/domain/repositories/`

Contains repository **interfaces** that define contracts:

```dart
// lib/features/journal/domain/repositories/journal_repository.dart
abstract class JournalRepository {
  Future<List<JournalEntry>> getAllEntries();
  Future<JournalEntry?> getEntryById(String id);
  Future<void> saveEntry(JournalEntry entry);
  Future<List<JournalEntry>> getEntriesByDateRange(DateTime start, DateTime end);
}
```

**Key Benefits:**

- UI layer depends on abstractions, not implementations
- Modules are decoupled from database technology
- Easy to mock for testing

### 2. Data Layer (Implementation)

**Location**: `lib/[module]/data/repositories/`

Contains **implementations** that use Drift:

```dart
// lib/features/journal/data/repositories/journal_repository_impl.dart
class JournalRepositoryImpl implements JournalRepository {
  final AppDatabase db;

  @override
  Future<List<JournalEntry>> getEntriesByDateRange(...) async {
    final entries = await (db.select(db.journalEntries)
          ..where((t) => t.date.isBetween(start, end)))
        .get();
    return entries.map(_mapToDomain).toList();
  }
}
```

**Key Benefits:**

- Drift encapsulated; domain layer never knows about it
- Mappers convert database rows to domain entities
- All database logic isolated here

### 3. Entities (Immutable, Type-Safe)

**Location**: `lib/[module]/domain/entities/`

Each module defines entities implementing `SchedulableEntity`:

```dart
class JournalEntry extends BaseEntity implements SchedulableEntity {
  final String content;

  @override
  final DateTime? startDate;

  // Immutable with copyWith pattern
}
```

**Key Benefits:**

- Type-safe across modules
- Entities are immutable (Riverpod-friendly)
- Can be linked via `EntityRelation` with type safety

## Dependency Injection with Riverpod

### Provider Structure

**Location**: `lib/core/providers.dart`

All repositories are instantiated through Riverpod providers:

```dart
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db = ref.read(databaseProvider);
  return TaskRepositoryImpl(db);
});

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  final db = ref.read(databaseProvider);
  return JournalRepositoryImpl(db);
});
```

### Dependency Flow

```
UI Screen
  ↓
ref.read(taskRepositoryProvider)  [from Riverpod]
  ↓
TaskRepository [interface]
  ↓
TaskRepositoryImpl [concrete]
  ↓
AppDatabase [Drift]
```

## Calendar Module: Aggregation Without Direct DB Access

### The Problem (Before)

Calendar would query multiple tables directly → tight coupling → hard to extend

### The Solution (After)

Calendar only depends on repository abstractions:

```dart
class CalendarRepositoryImpl implements CalendarRepository {
  final TaskRepository taskRepository;
  final JournalRepository journalRepository;

  @override
  Future<List<SchedulableItem>> getSchedulableItems(
    DateTime start,
    DateTime end,
  ) async {
    // Delegate to other repositories
    final tasks = await taskRepository.getTasksByDateRange(start, end);
    final entries = await journalRepository.getEntriesByDateRange(start, end);

    // Combine and sort
    return [...tasks, ...entries];
  }
}
```

**Key Benefits:**

- Calendar never touches database
- Adding new modules (Habits, Health, etc.) = just add more repositories
- Each module can implement its own storage strategy later

## Dependency Injection Flow

### From UI to Database

```
LoginScreen
  ↓ (ref.read)
authRepositoryProvider [Riverpod]
  ↓
AuthRepository [interface]
  ↓
LocalAuthRepository [data layer]
  ↓
AppDatabase

CalendarScreen
  ↓ (ref.read)
calendarRepositoryProvider [Riverpod]
  ↓
CalendarRepository [interface]
  ↓
CalendarRepositoryImpl [data layer]
  ↓ (depends on)
TaskRepository + JournalRepository [interfaces]
  ↓
Implementations → Database
```

## Scalability Pattern

Adding a new module (e.g., Habits) follows the same pattern:

1. **Domain**: `lib/features/habits/domain/repositories/habit_repository.dart`

   ```dart
   abstract class HabitRepository {
     Future<List<Habit>> getHabitsByDateRange(DateTime start, DateTime end);
   }
   ```

2. **Data**: `lib/features/habits/data/repositories/habit_repository_impl.dart`

   ```dart
   class HabitRepositoryImpl implements HabitRepository { ... }
   ```

3. **Provider**: Add to `lib/core/providers.dart`

   ```dart
   final habitRepositoryProvider = Provider<HabitRepository>((ref) {
     final db = ref.read(databaseProvider);
     return HabitRepositoryImpl(db);
   });
   ```

4. **Calendar Integration**: Add to calendar aggregator
   ```dart
   class CalendarRepositoryImpl {
     final HabitRepository habitRepository;

     @override
     Future<List<SchedulableItem>> getSchedulableItems(...) async {
       final habits = await habitRepository.getHabitsByDateRange(...);
       // Add to items list
     }
   }
   ```

## What the UI Cannot Do (Enforced by Architecture)

❌ **Forbidden**:

```dart
// UI directly importing Drift
import 'package:pluc/core/database.dart';

// UI directly querying database
final tasks = await appDb.select(appDb.tasks).get();
```

✅ **Correct**:

```dart
// UI only knows about repositories
final tasks = await ref.read(taskRepositoryProvider).getAllTasks();
```

## Testing Benefits

With this architecture, testing is straightforward:

```dart
// Mock repository for testing
class MockTaskRepository implements TaskRepository {
  @override
  Future<List<Task>> getTasksByDateRange(...) async {
    return [Task(...), Task(...)];
  }
}

// In test
ref.read(taskRepositoryProvider).overrideWithValue(MockTaskRepository());
```

## Summary: Improvements

| Aspect                  | Before                       | After                          |
| ----------------------- | ---------------------------- | ------------------------------ |
| **UI Database Access**  | Direct to Drift tables       | Only through repositories      |
| **Module Coupling**     | Tightly coupled via DB       | Loosely coupled via interfaces |
| **Calendar DB Queries** | Direct multi-table queries   | Delegates to modules           |
| **Adding Modules**      | Modify Calendar & DB schema  | Just add repository            |
| **Testing**             | Requires database mocks      | Simple interface mocks         |
| **Future Support**      | Hard to add new data sources | Trivial (new implementation)   |

This architecture makes scaling to iOS, macOS, and sync layers straightforward—each can have its own data layer implementation while domain logic remains unchanged.
