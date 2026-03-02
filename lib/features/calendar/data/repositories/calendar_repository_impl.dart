import 'package:pluc/core/domain/repositories/task_repository.dart';
import 'package:pluc/core/entities.dart';
import 'package:pluc/features/journal/domain/repositories/journal_repository.dart';
import 'package:pluc/features/calendar/domain/repositories/calendar_repository.dart';

/// Implementation of CalendarRepository that aggregates from other module repositories.
/// Never accesses the database directly; uses abstractions.
/// All queries are filtered by ownerId for multi-user data isolation.
class CalendarRepositoryImpl implements CalendarRepository {
  final TaskRepository taskRepository;
  final JournalRepository journalRepository;

  CalendarRepositoryImpl({
    required this.taskRepository,
    required this.journalRepository,
  });

  @override
  Future<List<SchedulableItem>> getSchedulableItems(
    String ownerId,
    DateTime start,
    DateTime end,
  ) async {
    final items = <SchedulableItem>[];

    // Aggregate tasks
    final tasks = await taskRepository.getTasksByDateRange(ownerId, start, end);
    items.addAll(
      tasks.map((task) => SchedulableItem(
            id: task.id,
            title: task.title,
            moduleSource: 'tasks',
            startDate: task.startDate,
            endDate: task.endDate,
            entityType: EntityType.task,
            metadata: {'description': task.description, 'status': task.status},
          )),
    );

    // Aggregate journal entries
    final entries =
        await journalRepository.getEntriesByDateRange(ownerId, start, end);
    items.addAll(
      entries.map((entry) => SchedulableItem(
            id: entry.id,
            title: 'Journal Entry',
            moduleSource: 'journal',
            startDate: entry.startDate,
            endDate: entry.endDate,
            entityType: EntityType.journalEntry,
            metadata: {'content': entry.content, 'status': entry.status},
          )),
    );

    // Sort by date
    items.sort((a, b) {
      final dateA = a.startDate ?? a.endDate;
      final dateB = b.startDate ?? b.endDate;
      if (dateA == null || dateB == null) return 0;
      return dateA.compareTo(dateB);
    });

    return items;
  }

  @override
  Future<List<SchedulableItem>> getItemsByModule(
    String ownerId,
    String moduleName,
    DateTime start,
    DateTime end,
  ) async {
    if (moduleName == 'tasks') {
      final tasks =
          await taskRepository.getTasksByDateRange(ownerId, start, end);
      return tasks
          .map((task) => SchedulableItem(
                id: task.id,
                title: task.title,
                moduleSource: 'tasks',
                startDate: task.startDate,
                endDate: task.endDate,
                entityType: EntityType.task,
                metadata: {
                  'description': task.description,
                  'status': task.status
                },
              ))
          .toList();
    } else if (moduleName == 'journal') {
      final entries =
          await journalRepository.getEntriesByDateRange(ownerId, start, end);
      return entries
          .map((entry) => SchedulableItem(
                id: entry.id,
                title: 'Journal Entry',
                moduleSource: 'journal',
                startDate: entry.startDate,
                endDate: entry.endDate,
                entityType: EntityType.journalEntry,
                metadata: {'content': entry.content, 'status': entry.status},
              ))
          .toList();
    }

    return [];
  }
}
