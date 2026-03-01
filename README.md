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

1. Install Flutter (latest stable) on your machine.
2. Run `flutter pub get` to install dependencies.
3. To generate localized messages: `flutter gen-l10n`.
4. Launch the app with `flutter run`.

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
