import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'presentation/modules_screen.dart';
import 'presentation/calendar_screen.dart';
import 'presentation/journal_entry_screen.dart';
import 'presentation/task_screen.dart';

void main() {
  runApp(const PlucApp());
}

class PlucApp extends StatefulWidget {
  const PlucApp({Key? key}) : super(key: key);

  @override
  State<PlucApp> createState() => _PlucAppState();
}

class _PlucAppState extends State<PlucApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pluc',
      locale: _locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: LoginScreen(onLocaleChanged: setLocale),
      routes: {
        '/modules': (_) => const ModulesScreen(),
        '/calendar': (_) => const CalendarScreen(),
        '/journal_entry': (_) => const JournalEntryScreen(),
        '/tasks': (_) => const TaskScreen(),
      },
    );
  }
}

class LoginScreen extends StatelessWidget {
  final void Function(Locale) onLocaleChanged;
  const LoginScreen({Key? key, required this.onLocaleChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(strings.loginTitle)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(strings.username),
            // TODO: implement text fields and login logic
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: perform authentication
                Navigator.pushReplacementNamed(context, '/modules');
              },
              child: Text(strings.signIn),
            ),
            const SizedBox(height: 16),
            DropdownButton<Locale>(
              value: Localizations.localeOf(context),
              onChanged: (locale) {
                if (locale != null) onLocaleChanged(locale);
              },
              items: AppLocalizations.supportedLocales
                  .map((loc) => DropdownMenuItem(
                        value: loc,
                        child: Text(loc.languageCode.toUpperCase()),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
