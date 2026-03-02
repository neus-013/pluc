import '../entities/task.dart';

/// Repository abstraction for Task module.
/// Domain layer exposes this; data layer implements.
/// All methods are scoped to a specific user (ownerId) for data isolation.
abstract class TaskRepository {
  /// Get all tasks for a specific user
  Future<List<Task>> getTasksForUser(String ownerId);

  /// Get a task by ID (verifies ownership)
  Future<Task?> getTaskById(String id, String ownerId);

  /// Save a task (create or update) - ownerId is assigned from the task entity
  Future<void> saveTask(Task task);

  /// Delete a task (verifies ownership)
  Future<void> deleteTask(String id, String ownerId);

  /// Get tasks within a date range for a specific user
  Future<List<Task>> getTasksByDateRange(
      String ownerId, DateTime start, DateTime end);

  // Legacy method for backward compatibility
  @Deprecated('Use getTasksForUser instead')
  Future<List<Task>> getAllTasks();
}
