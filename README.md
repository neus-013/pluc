# Pluc

A modular cross-platform life management application built with Flutter, Dart, and Clean Architecture.

## Features

- Modular structure (Calendar, Journal, Habits, Projects, Finance, Health, Menstruation, Nutrition)
- Riverpod for state management
- Drift (SQLite) for local persistence
- Internal event bus for cross-module communication
- Feature toggles and preset modes (structured, flexible, minimal)
- Local user authentication with extensible auth repository
- i18n support (English, Spanish, Catalan)

## Getting Started

⚠️ **Note**: Flutter SDK is required to run this project.

See [SETUP.md](SETUP.md) for detailed setup instructions including:

- Installing Flutter SDK
- Configuring dependencies
- Generating database and localization code
- Creating a GitHub remote repository

Quick start (if Flutter is already installed):

1. `flutter pub get`
2. `dart run build_runner build`
3. `flutter gen-l10n`
4. `flutter run`

## Project Structure

The project is organized by features under `lib/`:

```
lib/
  core/
  features/
    calendar/
    journal/
    habits/
    projects/
    finance/
    health/
    menstruation/
    nutrition/
```

Localization files are located under `lib/l10n`.

## Repository

This repository is initialized with a clean commit history and a Flutter-style `.gitignore`.

---

_Initial commit_
