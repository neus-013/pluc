import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/features/journal/domain/entities/journal_entry.dart';
import 'package:pluc/core/events/app_events.dart';
import 'package:pluc/core/providers.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:pluc/presentation/providers/app_providers.dart';
import 'package:pluc/presentation/theme/app_theme_config.dart';

/// MINIMAL journal view — focused writing.
///
/// Shows only today's entry in a focused plain-text editor.
/// One entry per day enforced. No search, no tags, no mood.
/// Ultra minimal layout — just write and save.
class MinimalJournalView extends ConsumerStatefulWidget {
  const MinimalJournalView({super.key});

  @override
  ConsumerState<MinimalJournalView> createState() => _MinimalJournalViewState();
}

class _MinimalJournalViewState extends ConsumerState<MinimalJournalView> {
  final _contentController = TextEditingController();
  JournalEntry? _todayEntry;
  bool _isLoading = true;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _loadTodayEntry();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadTodayEntry() async {
    final journalRepo = ref.read(journalRepositoryProvider);
    final userId = ref.read(currentUserIdProvider);

    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final entries = await journalRepo.getEntriesByDateRange(
        userId,
        startOfDay,
        endOfDay,
      );

      if (mounted) {
        setState(() {
          if (entries.isNotEmpty) {
            _todayEntry = entries.first;
            _contentController.text = entries.first.content;
          }
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final theme = ref.watch(currentThemeProvider);

    if (_isLoading) {
      return theme.buildLoadingIndicator();
    }

    return Padding(
      padding: EdgeInsets.all(theme.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Date header — today's entry
          _MinimalDateHeader(
            theme: theme,
            title: strings.todayEntry,
            date: DateTime.now(),
          ),
          SizedBox(height: theme.spacingSm),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          SizedBox(height: theme.spacingMd),
          // Plain-text editor — full remaining space
          Expanded(
            child: TextField(
              controller: _contentController,
              style: theme.textTheme.bodyLarge,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: strings.writeEntry,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(theme.borderRadiusMd),
                  borderSide:
                      BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(theme.borderRadiusMd),
                  borderSide:
                      BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(theme.borderRadiusMd),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
                contentPadding: EdgeInsets.all(theme.spacingMd),
              ),
              onChanged: (_) {
                if (!_hasChanges) setState(() => _hasChanges = true);
              },
            ),
          ),
          SizedBox(height: theme.spacingMd),
          // Save button
          SizedBox(
            height: 48,
            child: FilledButton.icon(
              onPressed: _hasChanges ? _saveEntry : null,
              icon: const Icon(Icons.save_outlined),
              label: Text(strings.saveEntry),
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                disabledBackgroundColor:
                    theme.colorScheme.surfaceContainerHighest,
                disabledForegroundColor: theme.colorScheme.outline,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(theme.borderRadiusMd),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveEntry() async {
    final journalRepo = ref.read(journalRepositoryProvider);
    final eventBus = ref.read(eventBusProvider);
    final userId = ref.read(currentUserIdProvider);
    final theme = ref.read(currentThemeProvider);
    final strings = AppLocalizations.of(context)!;

    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    try {
      final now = DateTime.now();
      if (_todayEntry != null) {
        // Update existing entry
        final updated = _todayEntry!.copyWith(
          content: content,
          updatedAt: now,
        );
        await journalRepo.saveEntry(updated);
      } else {
        // Create new entry for today
        final entryId = 'entry_${now.millisecondsSinceEpoch}';
        final entry = JournalEntry(
          id: entryId,
          createdAt: now,
          updatedAt: now,
          ownerId: userId,
          moduleSource: 'journal',
          content: content,
          startDate: now,
        );
        await journalRepo.saveEntry(entry);
        await eventBus.emit(JournalEntryCreatedEvent(
          entryId: entryId,
          userId: userId,
          date: now,
        ));
        _todayEntry = entry;
      }

      ref.read(calendarRefreshKeyProvider.notifier).state++;
      if (mounted) {
        setState(() => _hasChanges = false);
        theme.showSuccessSnackbar(context, strings.journalEntrySaved);
      }
    } catch (e) {
      if (mounted) {
        theme.showErrorSnackbar(context, '${strings.error}: $e');
      }
    }
  }
}

/// Minimal date header showing today's date.
class _MinimalDateHeader extends StatelessWidget {
  final AppThemeConfig theme;
  final String title;
  final DateTime date;

  const _MinimalDateHeader({
    required this.theme,
    required this.title,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final dayStr =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    return Row(
      children: [
        Icon(
          Icons.edit_note,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        SizedBox(width: theme.spacingSm),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          dayStr,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}
