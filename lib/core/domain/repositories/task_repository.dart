import '../entities/task.dart';

/// Repository abstraction for Task module.
/// Domain layer exposes this; data layer implements.
abstract class TaskRepository {
  Future<List<Task>> getAllTasks();
  Future<Task?> getTaskById(String id);
  Future<void> saveTask(Task task);
  Future<void> deleteTask(String id);
  Future<List<Task>> getTasksByDateRange(DateTime start, DateTime end);
}
