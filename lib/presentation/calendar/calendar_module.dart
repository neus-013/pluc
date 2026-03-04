import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/domain/enums/preset_type.dart';
import 'package:pluc/presentation/providers/preset_providers.dart';
import 'views/structured_calendar_view.dart';
import 'views/flexible_calendar_view.dart';
import 'views/minimal_calendar_view.dart';

/// Calendar module root widget.
///
/// Reads the current calendar preset and delegates to the appropriate
/// preset-specific view. Business logic (repos, providers) is shared —
/// only the layout structure, feature exposure, and interaction complexity
/// differ between presets.
class CalendarModule extends ConsumerWidget {
  const CalendarModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(calendarPresetConfigProvider);

    return switch (config.type) {
      PresetType.structured => const StructuredCalendarView(),
      PresetType.flexible => const FlexibleCalendarView(),
      PresetType.minimal => const MinimalCalendarView(),
    };
  }
}
