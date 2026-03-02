import 'package:pluc/core/entities.dart';

/// Journal entry entity for the Journal module.
class JournalEntry extends BaseEntity implements SchedulableEntity {
  final String content;

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

  const JournalEntry({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String ownerId,
    required String moduleSource,
    required this.content,
    Visibility visibility = Visibility.normal,
    this.startDate,
    this.endDate,
    this.recurrenceRule,
    this.reminderSettings,
    this.status,
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
  JournalEntry copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerId,
    String? moduleSource,
    Visibility? visibility,
    String? content,
    DateTime? startDate,
    DateTime? endDate,
    String? recurrenceRule,
    Map<String, dynamic>? reminderSettings,
    String? status,
    String? linkedEntityId,
  }) {
    return JournalEntry(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ownerId: ownerId ?? this.ownerId,
      moduleSource: moduleSource ?? this.moduleSource,
      visibility: visibility ?? this.visibility,
      content: content ?? this.content,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      recurrenceRule: recurrenceRule ?? this.recurrenceRule,
      reminderSettings: reminderSettings ?? this.reminderSettings,
      status: status ?? this.status,
      linkedEntityId: linkedEntityId ?? this.linkedEntityId,
    );
  }
}
