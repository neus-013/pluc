import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    // final strings = AppLocalizations.of(context)!;
    final journalRepo = ref.read(journalRepositoryProvider);
    final eventBus = ref.read(eventBusProvider);
    final userId = ref.read(currentUserIdProvider);
    final modulePresets = ref.watch(modulePresetsProvider);
    final selectedPreset = modulePresets['journal'] ?? 'flexible';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Preset: ${_capitalize(selectedPreset)}',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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
              hintText: 'Write something...',
              border: OutlineInputBorder(),
              labelText: 'Entry',
            ),
          ),
          SizedBox(height: 16),
          if (_saving)
            CircularProgressIndicator()
          else
            ElevatedButton.icon(
              onPressed: () async {
                if (_contentController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please write something')),
                  );
                  return;
                }

                setState(() {
                  _saving = true;
                });

                try {
                  final now = DateTime.now();
                  final entryId = 'entry_${now.millisecondsSinceEpoch}';

                  // Create entry
                  final entry = JournalEntry(
                    id: entryId,
                    createdAt: now,
                    updatedAt: now,
                    userId: userId,
                    moduleSource: 'journal',
                    content: _contentController.text,
                    startDate: now,
                  );

                  // Save via repository
                  await journalRepo.saveEntry(entry);

                  // Emit event
                  await eventBus.emit(
                    JournalEntryCreatedEvent(
                      entryId: entryId,
                      userId: userId,
                      date: now,
                    ),
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Journal entry saved!')),
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } finally {
                  setState(() {
                    _saving = false;
                  });
                }
              },
              icon: Icon(Icons.check),
              label: const Text('Save'),
            ),
        ],
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }
}
