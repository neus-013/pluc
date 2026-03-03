// Core entity definitions used across modules

enum Visibility { normal, hidden, devOnly }

enum EntityType {
  task,
  journalEntry,
  habit,
  project,
  financeRecord,
  healthRecord,
  menstruationCycle,
  nutritionEntry,
  calendarEvent,
  custom,
}

/// Immutable base entity with common metadata fields.
/// All concrete entities must extend this and be immutable.
abstract class BaseEntity {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String ownerId; // User ID who owns this entity
  final String moduleSource;
  final Visibility visibility;

  const BaseEntity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.ownerId,
    required this.moduleSource,
    this.visibility = Visibility.normal,
  });

  /// Copy with method - must be implemented by concrete subclasses
  BaseEntity copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? ownerId,
    String? moduleSource,
    Visibility? visibility,
  });
}

/// Mixin interface for entities that support scheduling capabilities.
/// Modules implement this if they need time-based features.
abstract mixin class SchedulableEntity {
  DateTime? get startDate;
  DateTime? get endDate;
  String? get recurrenceRule;
  Map<String, dynamic>? get reminderSettings;
  String? get status;
  String? get linkedEntityId;
}

/// Represents relationships between entities across different modules.
/// Includes entityType to prevent ID collisions and enable type-safe operations.
class EntityRelation {
  final String id;
  final String fromEntityId;
  final EntityType fromEntityType;
  final String toEntityId;
  final EntityType toEntityType;
  final String relationType;
  final Map<String, dynamic>? metadata;

  const EntityRelation({
    required this.id,
    required this.fromEntityId,
    required this.fromEntityType,
    required this.toEntityId,
    required this.toEntityType,
    required this.relationType,
    this.metadata,
  });

  EntityRelation copyWith({
    String? id,
    String? fromEntityId,
    EntityType? fromEntityType,
    String? toEntityId,
    EntityType? toEntityType,
    String? relationType,
    Map<String, dynamic>? metadata,
  }) {
    return EntityRelation(
      id: id ?? this.id,
      fromEntityId: fromEntityId ?? this.fromEntityId,
      fromEntityType: fromEntityType ?? this.fromEntityType,
      toEntityId: toEntityId ?? this.toEntityId,
      toEntityType: toEntityType ?? this.toEntityType,
      relationType: relationType ?? this.relationType,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Immutable definition of a feature module (Calendar, Journal, Habits, etc.)
class ModuleDefinition {
  final String id;
  final String name;
  final bool enabled;
  final bool devOnly;
  final Map<String, bool> configurableFeatures;

  const ModuleDefinition({
    required this.id,
    required this.name,
    this.enabled = true,
    this.devOnly = false,
    this.configurableFeatures = const {},
  });

  ModuleDefinition copyWith({
    String? id,
    String? name,
    bool? enabled,
    bool? devOnly,
    Map<String, bool>? configurableFeatures,
  }) {
    return ModuleDefinition(
      id: id ?? this.id,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
      devOnly: devOnly ?? this.devOnly,
      configurableFeatures: configurableFeatures ?? this.configurableFeatures,
    );
  }
}

/// Immutable feature toggle for module configuration.
class FeatureToggle {
  final String id;
  final String moduleId;
  final String name;
  final bool enabled;

  const FeatureToggle({
    required this.id,
    required this.moduleId,
    required this.name,
    this.enabled = false,
  });

  FeatureToggle copyWith({
    String? id,
    String? moduleId,
    String? name,
    bool? enabled,
  }) {
    return FeatureToggle(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      name: name ?? this.name,
      enabled: enabled ?? this.enabled,
    );
  }
}

/// Immutable preset configuration combining feature toggles into named presets.
/// E.g., "structured", "flexible", "minimal" for different usage modes.
class PresetDefinition {
  final String id;
  final String moduleId;
  final List<String> enabledFeatures;
  final List<String> disabledFeatures;

  const PresetDefinition({
    required this.id,
    required this.moduleId,
    this.enabledFeatures = const [],
    this.disabledFeatures = const [],
  });

  PresetDefinition copyWith({
    String? id,
    String? moduleId,
    List<String>? enabledFeatures,
    List<String>? disabledFeatures,
  }) {
    return PresetDefinition(
      id: id ?? this.id,
      moduleId: moduleId ?? this.moduleId,
      enabledFeatures: enabledFeatures ?? this.enabledFeatures,
      disabledFeatures: disabledFeatures ?? this.disabledFeatures,
    );
  }
}
