import 'package:pluc/core/entities.dart';

/// Calendar event entity for the Calendar module.
/// Represents user-created events (meetings, appointments, etc.)
class CalendarEvent extends BaseEntity implements SchedulableEntity {
  final String title;
  final String? description;

  @override
  final DateTime? startDate;

  @override
  final DateTime? endDate;

  @override
  final String? recurrenceRule;

  @override
  final Map<String, dynamic>? reminderSettings;

  @override
  final String? status;

  @override
  final String? linkedEntityId;

  const CalendarEvent({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String ownerId,
    required String moduleSource,
    required this.title,
    this.description,
    Visibility visibility = Visibility.normal,
    this.startDate,
    this.endDate,
    this.recurrenceRule,
    this.reminderSettings,
    this.status = 'active',
    this.linkedEntityId,
  }) : super(
          id: id,
          createdAt: createdAt,
          updatedAt: updatedAt,
          ownerId: ownerId,
          moduleSource: moduleSource,
          visibility: visibility,
        );

  @override
  CalendarEvent copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerId,
    String? moduleSource,
    Visibility? visibility,
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? recurrenceRule,
    Map<String, dynamic>? reminderSettings,
    String? status,
    String? linkedEntityId,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerId: ownerId ?? this.ownerId,
      moduleSource: moduleSource ?? this.moduleSource,
      visibility: visibility ?? this.visibility,
      title: title ?? this.title,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      reminderSettings: reminderSettings ?? this.reminderSettings,
      status: status ?? this.status,
      linkedEntityId: linkedEntityId ?? this.linkedEntityId,
    );
  }
}
