import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModulesScreen extends StatelessWidget {
  const ModulesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    // placeholder list of modules
    final modules = [
      strings.calendar,
      strings.journal,
      strings.tasks,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(strings.modules)),
      body: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(modules[index]),
            trailing: Switch(value: true, onChanged: (v) {}),
          );
        },
      ),
    );
  }
}
