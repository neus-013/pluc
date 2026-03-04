import '../domain/enums/preset_type.dart';
import 'module_preset_config.dart';

/// Defines the behavioral and structural capabilities of the Journal module
/// for a given preset level.
///
/// STRUCTURED: Rich text, mood tracking, tags, templates, search,
///   entry metadata, structured sections.
/// FLEXIBLE: Simplified rich text, optional mood, basic list, clean editor.
/// MINIMAL: Plain text, one entry per day, no tags, no mood tracking,
///   focused writing UI, ultra minimal layout.
abstract class JournalPresetConfig extends ModulePresetConfig {
  @override
  String get moduleId => 'journal';

  /// Whether the rich-text editor is available (vs plain text).
  bool get supportsRichText;

  /// Whether mood tracking is available on entries.
  bool get supportsMoodTracking;

  /// Whether tags can be attached to entries.
  bool get supportsTags;

  /// Whether entry templates are available.
  bool get supportsTemplates;

  /// Whether a search bar is shown for entries.
  bool get supportsSearch;

  /// Whether metadata (word count, reading time, etc.) is displayed.
  bool get supportsMetadata;

  /// Whether entries have structured sections/headings.
  bool get supportsStructuredSections;

  /// Whether the UI enforces one entry per day.
  bool get enforcesOneEntryPerDay;

  /// Factory that returns the correct config for the given [PresetType].
  factory JournalPresetConfig.fromType(PresetType type) {
    switch (type) {
      case PresetType.structured:
        return const StructuredJournalPreset();
      case PresetType.flexible:
        return const FlexibleJournalPreset();
      case PresetType.minimal:
        return const MinimalJournalPreset();
    }
  }
}

// ---------------------------------------------------------------------------
// Concrete implementations
// ---------------------------------------------------------------------------

class StructuredJournalPreset implements JournalPresetConfig {
  const StructuredJournalPreset();

  @override
  PresetType get type => PresetType.structured;

  @override
  String get moduleId => 'journal';

  @override
  DataDensity get dataDensity => DataDensity.dense;

  @override
  bool get supportsRichText => true;

  @override
  bool get supportsMoodTracking => true;

  @override
  bool get supportsTags => true;

  @override
  bool get supportsTemplates => true;

  @override
  bool get supportsSearch => true;

  @override
  bool get supportsMetadata => true;

  @override
  bool get supportsStructuredSections => true;

  @override
  bool get enforcesOneEntryPerDay => false;
}

class FlexibleJournalPreset implements JournalPresetConfig {
  const FlexibleJournalPreset();

  @override
  PresetType get type => PresetType.flexible;

  @override
  String get moduleId => 'journal';

  @override
  DataDensity get dataDensity => DataDensity.medium;

  @override
  bool get supportsRichText => true;

  @override
  bool get supportsMoodTracking => true;

  @override
  bool get supportsTags => false;

  @override
  bool get supportsTemplates => false;

  @override
  bool get supportsSearch => false;

  @override
  bool get supportsMetadata => false;

  @override
  bool get supportsStructuredSections => false;

  @override
  bool get enforcesOneEntryPerDay => false;
}

class MinimalJournalPreset implements JournalPresetConfig {
  const MinimalJournalPreset();

  @override
  PresetType get type => PresetType.minimal;

  @override
  String get moduleId => 'journal';

  @override
  DataDensity get dataDensity => DataDensity.clean;

  @override
  bool get supportsRichText => false;

  @override
  bool get supportsMoodTracking => false;

  @override
  bool get supportsTags => false;

  @override
  bool get supportsTemplates => false;

  @override
  bool get supportsSearch => false;

  @override
  bool get supportsMetadata => false;

  @override
  bool get supportsStructuredSections => false;

  @override
  bool get enforcesOneEntryPerDay => true;
}
