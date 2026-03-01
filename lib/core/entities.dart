// Core entity definitions used across modules

import 'package:flutter/foundation.dart';

/// Base fields shared by all entities
abstract class BaseEntity {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;
  final String moduleSource;
  final Visibility visibility;

  BaseEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.moduleSource,
    this.visibility = Visibility.normal,
  });
}

enum Visibility { normal, hidden, devOnly }

mixin SchedulableEntity {
  DateTime? startDate;
  DateTime? endDate;
  String? recurrenceRule;
  Map<String, dynamic>? reminderSettings;
  String? status;
  String? linkedEntityId;
}

class EntityRelation {
  final String id;
  final String fromEntityId;
  final String toEntityId;
  final String relationType;

  EntityRelation({
    required this.id,
    required this.fromEntityId,
    required this.toEntityId,
    required this.relationType,
  });
}

class ModuleDefinition {
  final String id;
  final String name;
  bool enabled;
  bool devOnly;
  Map<String, bool> configurableFeatures;

  ModuleDefinition({
    required this.id,
    required this.name,
    this.enabled = true,
    this.devOnly = false,
    Map<String, bool>? configurableFeatures,
  }) : configurableFeatures = configurableFeatures ?? {};
}

class FeatureToggle {
  final String id;
  final String moduleId;
  final String name;
  bool enabled;

  FeatureToggle({
    required this.id,
    required this.moduleId,
    required this.name,
    this.enabled = false,
  });
}

class PresetDefinition {
  final String id;
  final String moduleId;
  final List<String> enabledFeatures;
  final List<String> disabledFeatures;

  PresetDefinition({
    required this.id,
    required this.moduleId,
    this.enabledFeatures = const [],
    this.disabledFeatures = const [],
  });
}
