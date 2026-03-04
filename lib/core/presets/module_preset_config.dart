import '../domain/enums/preset_type.dart';

/// Base contract for all module preset configurations.
///
/// Each module must have a concrete implementation of this interface
/// for each [PresetType]. The config defines BEHAVIORAL and STRUCTURAL
/// properties — never visual styling (that's the theme's job).
///
/// Preset configs are immutable value objects that describe what a module
/// CAN do in a given preset mode. They are consumed by preset-specific
/// view widgets to decide what UI structure to build.
abstract class ModulePresetConfig {
  /// The preset type this config represents.
  PresetType get type;

  /// Data density for layouts (affects theme spacing decisions).
  DataDensity get dataDensity;

  /// Module identifier key (e.g. 'calendar', 'tasks', 'journal').
  String get moduleId;
}
