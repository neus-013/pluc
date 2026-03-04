import 'package:pluc/presentation/providers/app_providers.dart'
    show CalendarViewMode;

import '../domain/enums/preset_type.dart';
import 'module_preset_config.dart';

/// Defines the behavioral and structural capabilities of the Calendar module
/// for a given preset level.
///
/// STRUCTURED: Month/Week/Day, time-blocking, recurring events, filters,
///   categories, dense layout, advanced event form.
/// FLEXIBLE: Month + simple day view, basic event creation, optional color tag,
///   medium density, simple editing.
/// MINIMAL: Single month overview, tap-to-add simple event, no recurrence,
///   no filters, no categories, very clean layout, small event modal.
abstract class CalendarPresetConfig extends ModulePresetConfig {
  @override
  String get moduleId => 'calendar';

  /// Which calendar view modes are available to the user.
  List<CalendarViewMode> get availableViewModes;

  /// Whether time-blocking interactions are enabled.
  bool get supportsTimeBlocking;

  /// Whether recurring events can be created.
  bool get supportsRecurringEvents;

  /// Whether filter controls are shown.
  bool get supportsFilters;

  /// Whether category assignment is available.
  bool get supportsCategories;

  /// Whether color-tag picking is available on events.
  bool get supportsColorTags;

  /// Whether the full advanced event form is used (vs. a simplified modal).
  bool get supportsAdvancedEventForm;

  /// Maximum number of fields in the event creation/edit form.
  /// -1 means unlimited (all fields shown).
  int get maxEventFormFields;

  /// Factory that returns the correct config for the given [PresetType].
  factory CalendarPresetConfig.fromType(PresetType type) {
    switch (type) {
      case PresetType.structured:
        return const StructuredCalendarPreset();
      case PresetType.flexible:
        return const FlexibleCalendarPreset();
      case PresetType.minimal:
        return const MinimalCalendarPreset();
    }
  }
}

// ---------------------------------------------------------------------------
// Concrete implementations
// ---------------------------------------------------------------------------

class StructuredCalendarPreset implements CalendarPresetConfig {
  const StructuredCalendarPreset();

  @override
  PresetType get type => PresetType.structured;

  @override
  String get moduleId => 'calendar';

  @override
  DataDensity get dataDensity => DataDensity.dense;

  @override
  List<CalendarViewMode> get availableViewModes => CalendarViewMode.values;

  @override
  bool get supportsTimeBlocking => true;

  @override
  bool get supportsRecurringEvents => true;

  @override
  bool get supportsFilters => true;

  @override
  bool get supportsCategories => true;

  @override
  bool get supportsColorTags => true;

  @override
  bool get supportsAdvancedEventForm => true;

  @override
  int get maxEventFormFields => -1;
}

class FlexibleCalendarPreset implements CalendarPresetConfig {
  const FlexibleCalendarPreset();

  @override
  PresetType get type => PresetType.flexible;

  @override
  String get moduleId => 'calendar';

  @override
  DataDensity get dataDensity => DataDensity.medium;

  @override
  List<CalendarViewMode> get availableViewModes =>
      [CalendarViewMode.month, CalendarViewMode.day];

  @override
  bool get supportsTimeBlocking => false;

  @override
  bool get supportsRecurringEvents => false;

  @override
  bool get supportsFilters => false;

  @override
  bool get supportsCategories => false;

  @override
  bool get supportsColorTags => true;

  @override
  bool get supportsAdvancedEventForm => false;

  @override
  int get maxEventFormFields => 5;
}

class MinimalCalendarPreset implements CalendarPresetConfig {
  const MinimalCalendarPreset();

  @override
  PresetType get type => PresetType.minimal;

  @override
  String get moduleId => 'calendar';

  @override
  DataDensity get dataDensity => DataDensity.clean;

  @override
  List<CalendarViewMode> get availableViewModes => [CalendarViewMode.month];

  @override
  bool get supportsTimeBlocking => false;

  @override
  bool get supportsRecurringEvents => false;

  @override
  bool get supportsFilters => false;

  @override
  bool get supportsCategories => false;

  @override
  bool get supportsColorTags => false;

  @override
  bool get supportsAdvancedEventForm => false;

  @override
  int get maxEventFormFields => 3;
}
