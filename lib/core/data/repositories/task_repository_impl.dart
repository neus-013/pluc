import 'package:pluc/core/database.dart';
import 'package:pluc/core/domain/entities/task.dart';
import 'package:pluc/core/domain/repositories/task_repository.dart';

/// Implementation of TaskRepository using Drift ORM.
class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase db;

  TaskRepositoryImpl(this.db);

  @override
  Future<List<Task>> getAllTasks() async {
    try {
      final tasks = await db.select(db.tasks).get();
      return tasks.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<Task?> getTaskById(String id) async {
    try {
      final task = await (db.select(db.tasks)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      return task != null ? _mapToDomain(task) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveTask(Task task) async {
    await db.into(db.tasks).insertOnConflictUpdate(
      TasksCompanion(
        id: Value(task.id),
        userId: Value(task.userId),
        title: Value(task.title),
        description: Value(task.description),
        dueDate: Value(task.startDate),
        completed: Value(task.status == 'completed'),
      ),
    );
  }

  @override
  Future<void> deleteTask(String id) async {
    await (db.delete(db.tasks)..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<Task>> getTasksByDateRange(DateTime start, DateTime end) async {
    try {
      final tasks = await (db.select(db.tasks)
            ..where((t) => t.dueDate.isBetweenValues(start, end)))
          .get();
      return tasks.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  Task _mapToDomain(TasksData row) {
    return Task(
      id: row.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: row.userId,
      moduleSource: 'tasks',
      title: row.title,
      description: row.description,
      startDate: row.dueDate,
      status: row.completed ? 'completed' : 'pending',
    );
  }
}
