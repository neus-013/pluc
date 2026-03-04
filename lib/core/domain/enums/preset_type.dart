/// Defines the behavioral and structural complexity level of a module.
///
/// This is NOT a visual theme — it controls layout structure,
/// feature availability, data density, and interaction complexity.
/// The visual theme ([AppThemeConfig]) remains responsible for all styling.
enum PresetType {
  /// Full-featured, complex layout with all capabilities enabled.
  /// Dense data display, advanced forms, rich interactions.
  structured,

  /// Balanced mode with commonly-used features enabled.
  /// Medium data density, clean UI, simple editing.
  flexible,

  /// Stripped-down mode with minimal features.
  /// Very clean layout, fast interactions, essential fields only.
  minimal,
}

/// Data density level for module layouts.
/// Controls spacing, information density, and visual weight.
enum DataDensity {
  /// Packed information, compact spacing, more items visible.
  dense,

  /// Balanced spacing, moderate information per screen.
  medium,

  /// Generous spacing, fewer items visible, very clean.
  clean,
}

/// Converts a string preset name (e.g. from settings) to [PresetType].
PresetType presetTypeFromString(String name) {
  switch (name) {
    case 'structured':
      return PresetType.structured;
    case 'minimal':
      return PresetType.minimal;
    default:
      return PresetType.flexible;
  }
}

/// Converts a [PresetType] to its string key for persistence.
String presetTypeToString(PresetType type) {
  switch (type) {
    case PresetType.structured:
      return 'structured';
    case PresetType.flexible:
      return 'flexible';
    case PresetType.minimal:
      return 'minimal';
  }
}
