import '../domain/enums/preset_type.dart';
import 'module_preset_config.dart';

/// Defines the behavioral and structural capabilities of the Tasks module
/// for a given preset level.
///
/// STRUCTURED: Projects, subtasks, priorities, tags, due dates, filtering,
///   sorting, kanban/advanced list, bulk actions, detailed task screen.
/// FLEXIBLE: Tasks with optional due date, optional simple tags, basic sorting,
///   clean list UI, lightweight editor.
/// MINIMAL: Flat list, checkbox + title, optional due date, no projects,
///   no subtasks, very fast add interaction, large tappable rows.
abstract class TasksPresetConfig extends ModulePresetConfig {
  @override
  String get moduleId => 'tasks';

  /// Whether project grouping is available.
  bool get supportsProjects;

  /// Whether subtask nesting is available.
  bool get supportsSubtasks;

  /// Whether priority levels can be assigned.
  bool get supportsPriorities;

  /// Whether tags/labels can be attached to tasks.
  bool get supportsTags;

  /// Whether due dates are shown/settable.
  bool get supportsDueDates;

  /// Whether filter controls are available.
  bool get supportsFiltering;

  /// Whether sort controls are available.
  bool get supportsSorting;

  /// Whether a kanban/board view is available.
  bool get supportsKanban;

  /// Whether bulk-select actions are available.
  bool get supportsBulkActions;

  /// Whether a detailed full-screen task view is available.
  bool get supportsDetailedView;

  /// Whether quick inline-add (text field at top) is the primary creation mode.
  bool get usesQuickAdd;

  /// Factory that returns the correct config for the given [PresetType].
  factory TasksPresetConfig.fromType(PresetType type) {
    switch (type) {
      case PresetType.structured:
        return const StructuredTasksPreset();
      case PresetType.flexible:
        return const FlexibleTasksPreset();
      case PresetType.minimal:
        return const MinimalTasksPreset();
    }
  }
}

// ---------------------------------------------------------------------------
// Concrete implementations
// ---------------------------------------------------------------------------

class StructuredTasksPreset implements TasksPresetConfig {
  const StructuredTasksPreset();

  @override
  PresetType get type => PresetType.structured;

  @override
  String get moduleId => 'tasks';

  @override
  DataDensity get dataDensity => DataDensity.dense;

  @override
  bool get supportsProjects => true;

  @override
  bool get supportsSubtasks => true;

  @override
  bool get supportsPriorities => true;

  @override
  bool get supportsTags => true;

  @override
  bool get supportsDueDates => true;

  @override
  bool get supportsFiltering => true;

  @override
  bool get supportsSorting => true;

  @override
  bool get supportsKanban => true;

  @override
  bool get supportsBulkActions => true;

  @override
  bool get supportsDetailedView => true;

  @override
  bool get usesQuickAdd => false;
}

class FlexibleTasksPreset implements TasksPresetConfig {
  const FlexibleTasksPreset();

  @override
  PresetType get type => PresetType.flexible;

  @override
  String get moduleId => 'tasks';

  @override
  DataDensity get dataDensity => DataDensity.medium;

  @override
  bool get supportsProjects => false;

  @override
  bool get supportsSubtasks => false;

  @override
  bool get supportsPriorities => false;

  @override
  bool get supportsTags => true;

  @override
  bool get supportsDueDates => true;

  @override
  bool get supportsFiltering => false;

  @override
  bool get supportsSorting => true;

  @override
  bool get supportsKanban => false;

  @override
  bool get supportsBulkActions => false;

  @override
  bool get supportsDetailedView => false;

  @override
  bool get usesQuickAdd => false;
}

class MinimalTasksPreset implements TasksPresetConfig {
  const MinimalTasksPreset();

  @override
  PresetType get type => PresetType.minimal;

  @override
  String get moduleId => 'tasks';

  @override
  DataDensity get dataDensity => DataDensity.clean;

  @override
  bool get supportsProjects => false;

  @override
  bool get supportsSubtasks => false;

  @override
  bool get supportsPriorities => false;

  @override
  bool get supportsTags => false;

  @override
  bool get supportsDueDates => true;

  @override
  bool get supportsFiltering => false;

  @override
  bool get supportsSorting => false;

  @override
  bool get supportsKanban => false;

  @override
  bool get supportsBulkActions => false;

  @override
  bool get supportsDetailedView => false;

  @override
  bool get usesQuickAdd => true;
}
