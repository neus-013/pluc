import 'package:flutter/material.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/features/journal/domain/entities/journal_entry.dart';
import 'package:pluc/core/events/app_events.dart';
import 'package:pluc/core/providers.dart';
import 'providers/app_providers.dart';

class JournalEntryScreen extends ConsumerStatefulWidget {
  const JournalEntryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  int _refreshKey = 0;

  void _refreshEntries() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final journalRepo = ref.read(journalRepositoryProvider);
    final eventBus = ref.read(eventBusProvider);
    final userId = ref.read(currentUserIdProvider);
    final theme = ref.watch(currentThemeProvider);

    return Stack(
      children: [
        // Journal entries list
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              theme.buildSectionHeader(
                icon: Icons.book,
                title: strings.journal,
                iconColor: Colors.blue,
                onRefresh: _refreshEntries,
              ),
              const Divider(height: 1),
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

                    final entries = snapshot.data ?? [];

                    if (entries.isEmpty) {
                      return theme.buildEmptyState(
                        icon: Icons.auto_stories,
                        label: strings.journal,
                        color: Colors.grey,
                      );
                    }

                    // Sort entries by date (newest first)
                    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                    return ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return theme.buildJournalCard(
                          entry,
                          onTap: () async {
                            final edited = await theme.showJournalDialog(
                              context: context,
                              existingEntry: entry,
                            );
                            if (edited != null) {
                              try {
                                await journalRepo.saveEntry(edited);
                                _refreshEntries();
                                ref
                                    .read(calendarRefreshKeyProvider.notifier)
                                    .state++;
                                if (mounted) {
                                  theme.showSuccessSnackbar(
                                      context, strings.journalEntryUpdated);
                                }
                              } catch (e) {
                                if (mounted) {
                                  theme.showErrorSnackbar(
                                      context, '${strings.error}: $e');
                                }
                              }
                            }
                          },
                          onDelete: () async {
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
                                ref
                                    .read(calendarRefreshKeyProvider.notifier)
                                    .state++;
                                if (mounted) {
                                  theme.showSuccessSnackbar(
                                      context, strings.delete);
                                }
                              } catch (e) {
                                if (mounted) {
                                  theme.showErrorSnackbar(
                                      context, '${strings.error}: $e');
                                }
                              }
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // FAB – create new journal entry via dialog
        Positioned(
          right: 16,
          bottom: 16,
          child: theme.buildCreateFab(
            onPressed: () async {
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

                  await eventBus.emit(
                    JournalEntryCreatedEvent(
                      entryId: entryId,
                      userId: userId,
                      date: now,
                    ),
                  );

                  _refreshEntries();
                  ref.read(calendarRefreshKeyProvider.notifier).state++;

                  if (mounted) {
                    theme.showSuccessSnackbar(
                        context, strings.journalEntrySaved);
                  }
                } catch (e) {
                  if (mounted) {
                    theme.showErrorSnackbar(context, '${strings.error}: $e');
                  }
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
