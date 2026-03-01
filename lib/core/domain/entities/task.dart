import 'package:pluc/core/entities.dart';

/// Task entity for the Tasks module.
class Task extends BaseEntity implements SchedulableEntity {
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

  const Task({
    required String id,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String userId,
    required String moduleSource,
    required this.title,
    this.description,
    Visibility visibility = Visibility.normal,
    this.startDate,
    this.endDate,
    this.recurrenceRule,
    this.reminderSettings,
    this.status = 'pending',
    this.linkedEntityId,
  }) : super(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
    userId: userId,
    moduleSource: moduleSource,
    visibility: visibility,
  );

  @override
  Task copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
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
    return Task(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
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
