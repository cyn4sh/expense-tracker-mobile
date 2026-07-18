# Expense Tracker — Mobile App

A Flutter mobile application for tracking personal expenses and budgets, built with a production-grade, feature-first architecture using Riverpod code generation throughout.

## Features

- **Authentication**: Registration, login, persistent session (`AuthGate`), logout
- **Categories**: Full CRUD — create, edit (tap to open pre-filled form), delete (swipe with confirmation)
- **Expenses**: Full CRUD with category selection, date picker, offline-first local caching
- **Budgets**: Full CRUD with category, month, and year selection. Duplicate entries (same category + month + year) are prevented and surfaced with a clear, human-readable error message
- **Profile**: Dark mode toggle, notification preference toggle (server-synced), logout
- **Offline support**: Categories, Expenses, and Budgets all use a cache-first pattern — cached data displays immediately, with a background refresh from the network updating the UI silently when available

## Tech Stack

- **State management**: Riverpod (code generation via `@riverpod` exclusively — no manual providers)
- **Networking**: Dio, with a token-refresh interceptor and typed exception handling
- **Local storage**: sqflite (offline cache), flutter_secure_storage (auth tokens)
- **UI**: Material 3, edge-to-edge/immersive display, Manrope typeface via `google_fonts`

## Architecture

Every feature follows the same three-folder structure:

```
lib/features/<feature>/
  data/            # Models, DTOs, remote datasource, local datasource, repository
  providers/       # Riverpod providers (repository provider + Notifier)
  presentation/    # Screens and widgets
```

**Repository pattern**: Each feature's repository exposes a `watchXxx()` stream that yields cached data immediately, then fetches fresh data from the network in the background, re-caches it, and yields the update — all without surfacing network errors to the UI (cached data stays visible on failure).

**Provider pattern**: Each feature has an `AsyncNotifier` whose `build()` subscribes to the repository's stream. Mutations (create/update/delete) call `ref.invalidateSelf()` to trigger a refresh.

This structure is intentionally identical across Categories, Expenses, and Budgets — new features are built by mirroring the existing pattern, not inventing a new one.

## Authentication

Uses JWT access/refresh tokens stored securely on-device. `AuthGate` checks for a valid session on app launch and routes to either the authenticated `MainNavScreen` or the auth flow. Backend auth is built on an identity/auth-method separation model (`AuthIdentity`), meaning new login providers (e.g. Google Sign-In, in progress) can be added without restructuring existing auth code.

## Navigation

Four-tab bottom navigation: Categories, Expenses, Budgets, Profile. Profile handles both account-level info and app settings (theme, notifications, logout) rather than splitting settings into a separate tab.

## Setup

```bash
git clone <repo-url>
cd expense_tracker_mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Requires a running instance of the [Expense Tracker API](#) (Django backend). Update the API base URL in the network configuration to point to your backend (`10.0.2.2` for the Android emulator talking to `localhost`; a real network IP or `--dart-define` value for physical devices).

## Roadmap

- [ ] Google Sign-In
- [ ] `integration_test` / Patrol end-to-end test suite
- [ ] Per-build base URL configuration for physical device testing
- [ ] Push notification delivery (Celery/Redis background jobs) — deferred to a later roadmap phase; the preference toggle is already built and synced with the backend

## Companion API

This app consumes the [Expense Tracker API](#) (Django DRF). A React web client is planned for a later phase, consuming the same backend.