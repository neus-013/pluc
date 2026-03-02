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
  final _contentController = TextEditingController();
  bool _saving = false;
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
    final modulePresets = ref.watch(modulePresetsProvider);
    final selectedPreset = modulePresets['journal'] ?? 'flexible';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Journal Entries List Section
          Expanded(
            flex: 3,
            child: Card(
              margin: EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.book, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          strings.journal,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: _refreshEntries,
                          tooltip: 'Refresh',
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  Expanded(
                    child: FutureBuilder<List<JournalEntry>>(
                      key: ValueKey(_refreshKey),
                      future: journalRepo.getEntriesForUser(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        final entries = snapshot.data ?? [];

                        if (entries.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.auto_stories,
                                  size: 64,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No entries yet',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        // Sort entries by date (newest first)
                        entries.sort(
                            (a, b) => b.startDate!.compareTo(a.startDate!));

                        return ListView.builder(
                          itemCount: entries.length,
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Icon(
                                    Icons.article,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                title: Text(
                                  entry.content,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: entry.startDate != null
                                    ? Text(
                                        '📅 ${_formatDate(entry.startDate!)}',
                                        style: TextStyle(fontSize: 12),
                                      )
                                    : null,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (entry.startDate != null)
                                      Text(
                                        _formatTime(entry.startDate!),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        final confirmed = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text('Delete Entry'),
                                            content: Text(
                                                'Are you sure you want to delete this journal entry?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, false),
                                                child: Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, true),
                                                child: Text('Delete',
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirmed == true) {
                                          try {
                                            await journalRepo.deleteEntry(
                                                entry.id, userId);
                                            _refreshEntries();
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text('Entry deleted'),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Error deleting entry: $e'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Create Entry Form Section
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.green),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'New Entry',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.info,
                                        color: Colors.blue, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      '${strings.preset}: ${_capitalize(selectedPreset)}',
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    controller: _contentController,
                    maxLines: 10,
                    decoration: InputDecoration(
                      hintText: strings.writeSomething,
                      border: OutlineInputBorder(),
                      labelText: strings.entry,
                    ),
                  ),
                  SizedBox(height: 16),
                  if (_saving)
                    CircularProgressIndicator()
                  else
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Validate required fields
                        if (_contentController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(strings.pleaseWriteSomething)),
                          );
                          return;
                        }

                        // Get userId and validate
                        final userId = ref.read(currentUserIdProvider);
                        if (userId.isEmpty || userId == 'user_default') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: No user logged in')),
                          );
                          return;
                        }

                        setState(() {
                          _saving = true;
                        });

                        try {
                          final now = DateTime.now();
                          final entryId = 'entry_${now.millisecondsSinceEpoch}';

                          print(
                              'DEBUG: Attempting to save journal entry: $entryId');
                          print('DEBUG: Entry ownerId: $userId');

                          // Create entry with proper null handling
                          final entry = JournalEntry(
                            id: entryId,
                            createdAt: now,
                            updatedAt: now,
                            ownerId: userId,
                            moduleSource: 'journal',
                            content: _contentController.text.trim(),
                            startDate: now,
                          );

                          // Save via repository
                          await journalRepo.saveEntry(entry);

                          print('DEBUG: Journal entry saved successfully');

                          // Emit event
                          await eventBus.emit(
                            JournalEntryCreatedEvent(
                              entryId: entryId,
                              userId: userId,
                              date: now,
                            ),
                          );

                          print('DEBUG: Event emitted');

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(strings.journalEntrySaved),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Clear the form for next entry
                            _contentController.clear();

                            // Refresh the entries list
                            _refreshEntries();
                          }
                        } catch (e, stackTrace) {
                          print('ERROR creating journal entry: $e');
                          print('STACK TRACE: $stackTrace');

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${strings.error}: $e'),
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _saving = false;
                            });
                          }
                        }
                      },
                      icon: Icon(Icons.check),
                      label: Text(strings.save),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
