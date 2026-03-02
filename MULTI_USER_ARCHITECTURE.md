# Multi-User Data Isolation Architecture

## Overview

The application has been refactored to support true multi-user data isolation with local authentication and preparation for future OAuth providers (Google, Apple, Meta).

## Key Changes

### 1. User Domain Entity

**File:** `lib/core/domain/entities/user.dart`

- Created immutable `User` entity with:
  - `id`: Unique identifier (UUID)
  - `username`: Display username
  - `passwordHash`: Hashed password (nullable for OAuth users)
  - `authProvider`: Enum (local, google, apple, meta)
  - `createdAt`: Registration timestamp

### 2. Authentication Provider Enum

**File:** `lib/core/domain/enums/auth_provider.dart`

- Defines authentication methods:
  - `AuthProvider.local` - Username/password
  - `AuthProvider.google` - Google OAuth
  - `AuthProvider.apple` - Apple OAuth
  - `AuthProvider.meta` - Meta (Facebook) OAuth

### 3. Entity Changes: userId → ownerId

**Files:**

- `lib/core/entities.dart` (BaseEntity)
- `lib/core/domain/entities/task.dart`
- `lib/features/journal/domain/entities/journal_entry.dart`

- Renamed `userId` field to `ownerId` in all domain entities
- Updated `copyWith` methods
- All entities now explicitly track ownership

### 4. Database Schema Updates

**File:** `lib/core/database.dart`

- **Users Table:** Added `authProvider` and `createdAt` columns
- **All Data Tables:** Renamed `userId` columns to `ownerId`:
  - Tasks
  - JournalEntries
  - Habits
  - Projects
  - FinanceRecords
  - HealthRecords
  - MenstruationCycles
  - NutritionEntries
- **Schema Version:** Updated to 2 for migration tracking

### 5. Repository Interface Refactoring

**Files:**

- `lib/core/domain/repositories/task_repository.dart`
- `lib/features/journal/domain/repositories/journal_repository.dart`
- `lib/features/calendar/domain/repositories/calendar_repository.dart`

**Changes:**

- All methods now require `ownerId` parameter
- New methods:
  - `getTasksForUser(String ownerId)` instead of `getAllTasks()`
  - `getEntriesForUser(String ownerId)` instead of `getAllEntries()`
  - `getTaskById(String id, String ownerId)` - verifies ownership
  - `deleteTask(String id, String ownerId)` - verifies ownership
- Legacy methods marked as `@Deprecated` for backward compatibility

### 6. Repository Implementation Updates

**Files:**

- `lib/core/data/repositories/task_repository_impl.dart`
- `lib/features/journal/data/repositories/journal_repository_impl.dart`
- `lib/features/calendar/data/repositories/calendar_repository_impl.dart`

**Changes:**

- All database queries filtered by `ownerId`
- WHERE clauses: `t.ownerId.equals(ownerId)`
- Combined conditions: `t.id.equals(id) & t.ownerId.equals(ownerId)`
- Automatic `ownerId` assignment from entity on save
- Calendar aggregation passes `ownerId` to all sub-repositories

### 7. Authentication Repository Refactoring

**File:** `lib/core/auth_repository.dart`

**New Methods:**

- `Future<User?> signInLocal(username, password)` - Local auth
- `Future<User?> signInWithGoogle()` - Google OAuth (stub)
- `Future<User?> signInWithApple()` - Apple OAuth (stub)
- `Future<User?> signInWithMeta()` - Meta OAuth (stub)
- `Future<User?> registerLocal(username, password)` - Local registration
- `User? getCurrentUser()` - Returns full User entity

**Legacy Methods (Deprecated):**

- `Future<bool> signIn()` - Use `signInLocal()` instead
- `Future<bool> register()` - Use `registerLocal()` instead
- `String? getCurrentUserId()` - Use `getCurrentUser()` instead

### 8. Local Auth Implementation

**File:** `lib/core/auth/local_auth_repository.dart`

**Changes:**

- Returns `User` entities instead of `bool`
- Generates UUIDs for user IDs
- Hashes passwords with SHA-256
- Stores authProvider as 'local' in database
- Tracks `_currentUser` in memory
- Implements placeholder OAuth methods (throw `UnimplementedError`)

### 9. State Management

**File:** `lib/presentation/providers/app_providers.dart`

**Changes:**

- `currentUserProvider`: Changed from `StateProvider<String>` to `StateProvider<User?>`
  - Now holds full User entity
  - `null` when logged out
- `currentUserIdProvider`: Updated to extract ID from `currentUserProvider`
  - Returns `user?.id ?? 'user_default'`
- `passwordLengthProvider`: Kept for UI display purposes

### 10. UI Updates

**Files:**

- `lib/main.dart` (LoginScreen)
- `lib/presentation/settings_screen.dart`
- `lib/presentation/task_screen.dart`
- `lib/presentation/journal_entry_screen.dart`

**Changes:**

- **Login:** Calls `signInLocal()`, stores User entity in `currentUserProvider`
- **Registration:** Calls `registerLocal()`, stores User entity
- **Settings:** Displays `currentUser?.username`, logout sets provider to `null`
- **Task/Journal Creation:** Uses `currentUserIdProvider` to get `ownerId`
- All entity constructors use `ownerId` parameter

## Data Isolation Benefits

### Security

- **Ownership Verification:** All repository methods verify `ownerId` matches
- **Query Filtering:** Database queries enforce `WHERE ownerId = ?`
- **No Cross-User Access:** Users cannot accidentally access other users' data

### Multi-User Support

- **Local Users:** Multiple users can use the app locally with separate data
- **OAuth Ready:** Architecture prepared for Google, Apple, Meta authentication
- **Session Management:** `currentUserProvider` tracks authenticated user

### Performance

- **Indexed Queries:** Database queries filtered by `ownerId` (future: add indexes)
- **Efficient Filtering:** Drift ORM optimizes WHERE clauses

## OAuth Integration Guide

To add a new OAuth provider (e.g., Google):

1. **Add OAuth Package:**

   ```yaml
   dependencies:
     google_sign_in: ^6.0.0
   ```

2. **Implement in LocalAuthRepository:**

   ```dart
   @override
   Future<User?> signInWithGoogle() async {
     final googleUser = await _googleSignIn.signIn();
     if (googleUser == null) return null;

     // Store user in database
     final user = User(
       id: _uuid.v4(),
       username: googleUser.displayName ?? googleUser.email,
       passwordHash: null, // No password for OAuth
       authProvider: AuthProvider.google,
       createdAt: DateTime.now(),
     );

     // Save to database
     await database.into(database.users).insertOnConflictUpdate(...);

     _currentUser = user;
     return user;
   }
   ```

3. **Add UI Button:**
   ```dart
   ElevatedButton.icon(
     onPressed: () async {
       final user = await auth.signInWithGoogle();
       if (user != null) {
         ref.read(currentUserProvider.notifier).state = user;
         Navigator.pushNamed(context, '/home');
       }
     },
     icon: Icon(Icons.login),
     label: Text('Sign in with Google'),
   )
   ```

## Migration Notes

### Existing Data

- Old data with `userId` fields needs migration to `ownerId`
- Run migration script to rename columns (Drift handles schema updates)

### Backward Compatibility

- Legacy repository methods kept as `@Deprecated`
- Old code will continue to work but should be updated

### Testing

- Test multi-user scenarios: create user A, add data, log out, create user B, verify isolation
- Verify ownership checks prevent cross-user access
- Test calendar aggregation with multiple users' data

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Layer                    │
│  (LoginScreen, SettingsScreen, TaskScreen, etc.)        │
│                                                           │
│  Providers:                                              │
│  - currentUserProvider: StateProvider<User?>            │
│  - currentUserIdProvider: Provider<String>              │
└───────────────────────┬───────────────────────────────┘
                        │
┌───────────────────────▼───────────────────────────────┐
│                   Domain Layer                         │
│  Entities:                                             │
│  - User (id, username, authProvider, createdAt)       │
│  - Task (id, ownerId, title, ...)                     │
│  - JournalEntry (id, ownerId, content, ...)           │
│                                                         │
│  Repository Interfaces:                                │
│  - TaskRepository.getTasksForUser(ownerId)            │
│  - JournalRepository.getEntriesForUser(ownerId)       │
│  - AuthRepository.signInLocal()/signInWithGoogle()    │
└───────────────────────┬───────────────────────────────┘
                        │
┌───────────────────────▼───────────────────────────────┐
│                    Data Layer                          │
│  Repository Implementations:                           │
│  - TaskRepositoryImpl                                  │
│    → WHERE ownerId = ?                                 │
│  - JournalRepositoryImpl                               │
│    → WHERE ownerId = ?                                 │
│  - LocalAuthRepository                                 │
│    → Hashes passwords, returns User entities          │
└───────────────────────┬───────────────────────────────┘
                        │
┌───────────────────────▼───────────────────────────────┐
│                  Database (Drift)                      │
│  Tables:                                               │
│  - users (id, username, passwordHash, authProvider)   │
│  - tasks (id, ownerId, title, ...)                    │
│  - journal_entries (id, ownerId, content, ...)        │
│                                                         │
│  All data tables have ownerId for isolation            │
└─────────────────────────────────────────────────────────┘
```

## Security Considerations

1. **Password Hashing:** SHA-256 (consider upgrading to bcrypt/Argon2)
2. **Session Management:** User stored in memory, clears on logout
3. **Ownership Verification:** All queries verify `ownerId`
4. **No Plain Text Passwords:** Database stores hashes only

## Future Enhancements

1. **Database Indexes:** Add indexes on `ownerId` columns for performance
2. **OAuth Implementation:** Complete Google, Apple, Meta sign-in
3. **Token Storage:** Add refresh tokens for OAuth providers
4. **Biometric Auth:** Add fingerprint/face unlock
5. **Data Encryption:** Encrypt sensitive data at rest
6. **Multi-Device Sync:** Sync user data across devices
7. **Password Reset:** Implement secure password recovery

## Commit Message

```
feat: implement multi-user data isolation with OAuth preparation

- Create User entity with authProvider enum (local, google, apple, meta)
- Rename userId to ownerId in all domain entities
- Update database schema: add ownerId columns, authProvider field
- Refactor repository interfaces for user-scoped queries
- Implement ownership verification in all repository methods
- Update AuthRepository to return User entities
- Add OAuth method stubs (signInWithGoogle, signInWithApple, signInWithMeta)
- Update state management: currentUserProvider now holds User entity
- Update UI: login, logout, settings, task/journal creation
- Maintain backward compatibility with deprecated methods

BREAKING CHANGE: Database schema updated to v2 (ownerId migration)
```
