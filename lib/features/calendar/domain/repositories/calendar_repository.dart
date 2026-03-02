import 'package:pluc/core/entities.dart';

/// Represents a schedulable entity from any module.
/// Used by Calendar for aggregation.
class SchedulableItem {
  final String id;
  final String title;
  final String moduleSource;
  final DateTime? startDate;
  final DateTime? endDate;
  final EntityType entityType;
  final Map<String, dynamic>? metadata;

  const SchedulableItem({
    required this.id,
    required this.title,
    required this.moduleSource,
    this.startDate,
    this.endDate,
    required this.entityType,
    this.metadata,
  });
}

/// Repository abstraction for the Calendar aggregator.
/// Delegates to other module repositories without knowing their internals.
/// All methods are scoped to a specific user (ownerId) for data isolation.
abstract class CalendarRepository {
  /// Get all schedulable items for a date range for a specific user
  Future<List<SchedulableItem>> getSchedulableItems(
    String ownerId,
    DateTime start,
    DateTime end,
  );

  /// Get items by module for a specific user
  Future<List<SchedulableItem>> getItemsByModule(
    String ownerId,
    String moduleName,
    DateTime start,
    DateTime end,
  );
}
