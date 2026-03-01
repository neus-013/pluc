import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'presentation/modules_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers.dart';
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
    return ProviderScope(
      child: MaterialApp(
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

class LoginScreen extends ConsumerStatefulWidget {
  final void Function(Locale) onLocaleChanged;
  const LoginScreen({Key? key, required this.onLocaleChanged}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final auth = ref.read(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.loginTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: strings.username),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: strings.password),
                obscureText: true,
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 16),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                          _error = null;
                        });
                        final success = await auth.signIn(
                          _usernameController.text,
                          _passwordController.text,
                        );
                        setState(() {
                          _loading = false;
                        });
                        if (success) {
                          Navigator.pushReplacementNamed(context, '/modules');
                        } else {
                          setState(() {
                            _error = 'Invalid credentials';
                          });
                        }
                      },
                      child: Text(strings.signIn),
                    ),
              const SizedBox(height: 16),
              DropdownButton<Locale>(
                value: Localizations.localeOf(context),
                onChanged: (locale) {
                  if (locale != null) widget.onLocaleChanged(locale);
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
      ),
    );
  }
}
