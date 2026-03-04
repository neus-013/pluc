import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/domain/enums/preset_type.dart';
import 'package:pluc/presentation/providers/preset_providers.dart';
import 'views/structured_journal_view.dart';
import 'views/flexible_journal_view.dart';
import 'views/minimal_journal_view.dart';

/// Journal module root widget.
///
/// Reads the current journal preset and delegates to the appropriate
/// preset-specific view. Business logic (repos, providers) is shared —
/// only the layout structure, feature exposure, and interaction complexity
/// differ between presets.
class JournalModule extends ConsumerWidget {
  const JournalModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(journalPresetConfigProvider);

    return switch (config.type) {
      PresetType.structured => const StructuredJournalView(),
      PresetType.flexible => const FlexibleJournalView(),
      PresetType.minimal => const MinimalJournalView(),
    };
  }
}
