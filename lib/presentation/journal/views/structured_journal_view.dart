import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/features/journal/domain/entities/journal_entry.dart';
import 'package:pluc/core/events/app_events.dart';
import 'package:pluc/core/providers.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:pluc/presentation/providers/app_providers.dart';
import 'package:pluc/presentation/theme/app_theme_config.dart';

/// STRUCTURED journal view — full featured.
///
/// Search bar, full journal cards with metadata, tags, mood tracking,
/// templates, structured sections, FAB with full dialog.
class StructuredJournalView extends ConsumerStatefulWidget {
  const StructuredJournalView({super.key});

  @override
  ConsumerState<StructuredJournalView> createState() =>
      _StructuredJournalViewState();
}

class _StructuredJournalViewState extends ConsumerState<StructuredJournalView> {
  int _refreshKey = 0;
  String _searchQuery = '';

  void _refreshEntries() => setState(() => _refreshKey++);

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final journalRepo = ref.read(journalRepositoryProvider);
    final eventBus = ref.read(eventBusProvider);
    final userId = ref.read(currentUserIdProvider);
    final theme = ref.watch(currentThemeProvider);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(theme.spacingMd),
          child: Column(
            children: [
              // Section header with refresh
              theme.buildSectionHeader(
                icon: Icons.book,
                title: strings.journal,
                iconColor: theme.colorScheme.primary,
                onRefresh: _refreshEntries,
              ),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              SizedBox(height: theme.spacingSm),
              // Search bar
              _StructuredSearchBar(
                theme: theme,
                hintText: strings.searchEntries,
                onChanged: (q) => setState(() => _searchQuery = q),
              ),
              SizedBox(height: theme.spacingSm),
              // Entries list
              Expanded(
                child: FutureBuilder<List<JournalEntry>>(
                  key: ValueKey(_refreshKey),
                  future: journalRepo.getEntriesForUser(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return theme.buildLoadingIndicator();
                    }
                    if (snapshot.hasError) {
                      return theme.buildErrorState(
                          error: snapshot.error.toString());
                    }

                    var entries = snapshot.data ?? [];
                    if (entries.isEmpty) {
                      return theme.buildEmptyState(
                        icon: Icons.auto_stories,
                        label: strings.noEntriesYet,
                        color: theme.colorScheme.outline,
                      );
                    }

                    // Apply search filter
                    if (_searchQuery.isNotEmpty) {
                      entries = entries
                          .where((e) => e.content
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                          .toList();
                    }

                    // Sort by date (newest first)
                    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                    return ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return theme.buildJournalCard(
                          entry,
                          onTap: () =>
                              _editEntry(entry, journalRepo, theme, strings),
                          onDelete: () => _deleteEntry(
                              entry, journalRepo, userId, theme, strings),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // FAB — full journal dialog
        Positioned(
          right: theme.spacingMd,
          bottom: theme.spacingMd,
          child: theme.buildCreateFab(
            onPressed: () =>
                _createEntry(journalRepo, eventBus, userId, theme, strings),
          ),
        ),
      ],
    );
  }

  Future<void> _createEntry(
    dynamic journalRepo,
    dynamic eventBus,
    String userId,
    AppThemeConfig theme,
    AppLocalizations strings,
  ) async {
    final newEntry = await theme.showJournalDialog(context: context);
    if (newEntry != null) {
      try {
        final now = DateTime.now();
        final entryId = 'entry_${now.millisecondsSinceEpoch}';
        final entry = newEntry.copyWith(
          id: entryId,
          createdAt: now,
          updatedAt: now,
          ownerId: userId,
          moduleSource: 'journal',
          startDate: now,
        );
        await journalRepo.saveEntry(entry);
        await eventBus.emit(JournalEntryCreatedEvent(
          entryId: entryId,
          userId: userId,
          date: now,
        ));
        _refreshEntries();
        ref.read(calendarRefreshKeyProvider.notifier).state++;
        if (mounted) {
          theme.showSuccessSnackbar(context, strings.journalEntrySaved);
        }
      } catch (e) {
        if (mounted) {
          theme.showErrorSnackbar(context, '${strings.error}: $e');
        }
      }
    }
  }

  Future<void> _editEntry(
    JournalEntry entry,
    dynamic journalRepo,
    AppThemeConfig theme,
    AppLocalizations strings,
  ) async {
    final edited = await theme.showJournalDialog(
      context: context,
      existingEntry: entry,
    );
    if (edited != null) {
      try {
        await journalRepo.saveEntry(edited);
        _refreshEntries();
        ref.read(calendarRefreshKeyProvider.notifier).state++;
        if (mounted) {
          theme.showSuccessSnackbar(context, strings.journalEntryUpdated);
        }
      } catch (e) {
        if (mounted) {
          theme.showErrorSnackbar(context, '${strings.error}: $e');
        }
      }
    }
  }

  Future<void> _deleteEntry(
    JournalEntry entry,
    dynamic journalRepo,
    String userId,
    AppThemeConfig theme,
    AppLocalizations strings,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => theme.buildConfirmDialog(
        context: ctx,
        title: strings.delete,
        content: strings.delete,
        confirmLabel: strings.delete,
        cancelLabel: strings.cancel,
        onConfirm: () {},
      ),
    );
    if (confirmed == true) {
      try {
        await journalRepo.deleteEntry(entry.id, userId);
        _refreshEntries();
        ref.read(calendarRefreshKeyProvider.notifier).state++;
        if (mounted) {
          theme.showSuccessSnackbar(context, strings.delete);
        }
      } catch (e) {
        if (mounted) {
          theme.showErrorSnackbar(context, '${strings.error}: $e');
        }
      }
    }
  }
}

/// Search bar for filtering journal entries.
class _StructuredSearchBar extends StatelessWidget {
  final AppThemeConfig theme;
  final String hintText;
  final ValueChanged<String> onChanged;

  const _StructuredSearchBar({
    required this.theme,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: theme.textTheme.bodyMedium,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodySmall,
        prefixIcon: Icon(Icons.search, color: theme.colorScheme.outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(theme.borderRadiusSm),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: theme.spacingSm,
          vertical: theme.spacingSm,
        ),
        isDense: true,
      ),
      onChanged: onChanged,
    );
  }
}
