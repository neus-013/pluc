import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'presentation/home_screen.dart';
import 'presentation/settings_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers.dart';

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
          '/home': (_) => const HomeScreen(),
          '/settings': (_) => const SettingsScreen(),
        },
      ),
    );
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  final void Function(Locale) onLocaleChanged;
  const LoginScreen({Key? key, required this.onLocaleChanged})
      : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _isSignUpMode = false;
  String? _error;
  String? _successMessage;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final auth = ref.read(authRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isSignUpMode ? strings.signUpTitle : strings.loginTitle),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: strings.username),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: strings.password),
                obscureText: true,
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              if (_successMessage != null) ...[
                const SizedBox(height: 8),
                Text(_successMessage!,
                    style: const TextStyle(color: Colors.green)),
              ],
              const SizedBox(height: 24),
              _loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          _loading = true;
                          _error = null;
                          _successMessage = null;
                        });

                        if (_isSignUpMode) {
                          // Sign up mode
                          final success = await auth.register(
                            _usernameController.text,
                            _passwordController.text,
                          );

                          setState(() {
                            _loading = false;
                          });

                          if (success) {
                            setState(() {
                              _successMessage = strings.registrationSuccess;
                              _isSignUpMode = false;
                              _usernameController.clear();
                              _passwordController.clear();
                            });
                          } else {
                            setState(() {
                              _error = strings.usernameTaken;
                            });
                          }
                        } else {
                          // Sign in mode
                          final success = await auth.signIn(
                            _usernameController.text,
                            _passwordController.text,
                          );

                          setState(() {
                            _loading = false;
                          });

                          if (success) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            setState(() {
                              _error = strings.invalidCredentials;
                            });
                          }
                        }
                      },
                      child: Text(_isSignUpMode
                          ? strings.createAccount
                          : strings.signIn),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSignUpMode = !_isSignUpMode;
                    _error = null;
                    _successMessage = null;
                  });
                },
                child: Text(
                  _isSignUpMode
                      ? strings.alreadyHaveAccount
                      : strings.dontHaveAccount,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.language, size: 20),
                  const SizedBox(width: 8),
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
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
