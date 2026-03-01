# Setup Instructions (For Windows Users)

Since Flutter is not installed on your system, follow these steps:

1. **Install Flutter SDK**
   - Download from: https://docs.flutter.dev/get-started/install/windows
   - Extract and add Flutter to your PATH
   - Run `flutter doctor` to verify installation

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Database Code**
   ```bash
   dart run build_runner build
   ```

4. **Generate Localization Files**
   ```bash
   flutter gen-l10n
   ```

5. **Run the App**
   ```bash
   flutter run -d <device>
   ```

   Use `flutter devices` to list available devices.

---

**GitHub Repository**

The GitHub CLI (`gh`) is not installed. To push this repository to GitHub:

1. Create a repository on GitHub at: https://github.com/new
2. Name it `pluc`
3. Then run:
   ```bash
   git remote add origin https://github.com/<your-username>/pluc.git
   git push -u origin master
   ```

---

**Project Summary**

- **Clean Architecture**: Core domain with BaseEntity, SchedulableEntity, and module definitions
- **Feature Modules**: Calendar (aggregator), Journal, Tasks, Habits, Projects, Finance, Health, Menstruation, Nutrition
- **Riverpod**: State management with providers for database and authentication
- **Drift**: Local SQLite persistence with comprehensive schema
- **i18n**: English, Spanish, Catalan localization with ARB files
- **Event Bus**: Internal communication between modules
- **Auth**: Local username/password authentication with extensible AuthRepository

The initial commit is ready. Complete the setup instructions above to run the app.
