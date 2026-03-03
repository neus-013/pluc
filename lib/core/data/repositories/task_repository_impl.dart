import 'package:pluc/core/database.dart';
import 'package:pluc/core/domain/entities/task.dart' as domain;
import 'package:pluc/core/domain/repositories/task_repository.dart';
import 'package:drift/drift.dart';

/// Implementation of TaskRepository using Drift ORM.
/// All queries are filtered by ownerId for multi-user data isolation.
class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase db;

  TaskRepositoryImpl(this.db);

  @override
  Future<List<domain.Task>> getTasksForUser(String ownerId) async {
    try {
      final tasks = await (db.select(db.tasks)
            ..where((t) => t.ownerId.equals(ownerId)))
          .get();
      return tasks.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<domain.Task?> getTaskById(String id, String ownerId) async {
    try {
      final task = await (db.select(db.tasks)
            ..where((t) => t.id.equals(id) & t.ownerId.equals(ownerId)))
          .getSingleOrNull();
      return task != null ? _mapToDomain(task) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveTask(domain.Task task) async {
    try {
      print('DEBUG TaskRepository: Saving task ${task.id}');
      print(
          'DEBUG TaskRepository: ownerId=${task.ownerId}, title=${task.title}');

      await db.into(db.tasks).insertOnConflictUpdate(
            TasksCompanion(
              id: Value(task.id),
              ownerId: Value(task.ownerId),
              title: Value(task.title),
              description: Value(task.description),
              startDate: Value(task.startDate),
              endDate: Value(task.endDate),
              recurrenceRule: Value(task.recurrenceRule),
              reminderSettings: Value(task.reminderSettings != null
                  ? task.reminderSettings.toString()
                  : null),
              status: Value(task.status ?? 'pending'),
              linkedEntityId: Value(task.linkedEntityId),
              createdAt: Value(task.createdAt),
              updatedAt: Value(task.updatedAt),
            ),
          );

      print('DEBUG TaskRepository: Task saved successfully');
    } catch (e, stackTrace) {
      print('ERROR TaskRepository: Failed to save task: $e');
      print('STACK TRACE: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(String id, String ownerId) async {
    await (db.delete(db.tasks)
          ..where((t) => t.id.equals(id) & t.ownerId.equals(ownerId)))
        .go();
  }

  @override
  Future<List<domain.Task>> getTasksByDateRange(
      String ownerId, DateTime start, DateTime end) async {
    try {
      final tasks = await (db.select(db.tasks)
            ..where((t) =>
                t.ownerId.equals(ownerId) &
                (
                    // Tasks with a startDate in range
                    t.startDate.isBetweenValues(start, end) |
                        // Tasks without startDate — fall back to createdAt
                        (t.startDate.isNull() &
                            t.createdAt.isBetweenValues(start, end)))))
          .get();
      return tasks.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  @Deprecated('Use getTasksForUser instead')
  Future<List<domain.Task>> getAllTasks() async {
    // Legacy method - returns all tasks without filtering
    // This should not be used in production - only for migration
    try {
      final tasks = await db.select(db.tasks).get();
      return tasks.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  domain.Task _mapToDomain(Task row) {
    return domain.Task(
      id: row.id,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      ownerId: row.ownerId,
      moduleSource: 'tasks',
      title: row.title,
      description: row.description,
      startDate: row.startDate,
      endDate: row.endDate,
      recurrenceRule: row.recurrenceRule,
      reminderSettings: null, // TODO: Parse JSON if needed
      status: row.status,
      linkedEntityId: row.linkedEntityId,
    );
  }
}
