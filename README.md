# PostFlow

Plan, schedule and publish social-media content across every platform.

> **Milestone:** Step 1 — project foundation (theme, navigation, dashboard,
> placeholder screens). No auth, backend or platform integrations yet.

## First-time setup

The repository contains the Dart sources, tests and config. Generate the
native platform folders once (this does **not** overwrite existing files):

```bash
flutter create --org com.postflow --project-name postflow --platforms android,ios,web .
```

Then verify:

```bash
flutter pub get
dart format .
flutter analyze
flutter test
flutter run            # Android device/emulator
```

> `flutter create .` also adds a default `test/widget_test.dart` only if one
> doesn't exist — ours is kept.

## Project structure

```text
lib/
├── app/                      # App root + navigation shell (wires features together)
│   ├── postflow_app.dart
│   └── app_shell.dart        # Bottom bar on phones, side rail ≥ 840 px
├── core/                     # Shared, feature-agnostic code
│   ├── constants/            # App constants, spacing scale, platform metadata
│   ├── theme/                # Colors + light/dark Material 3 themes
│   ├── utils/                # Date formatting helpers
│   ├── services/             # (later) API clients, storage, schedulers
│   └── widgets/              # Logo, section header, badges, placeholders
├── features/
│   ├── auth/                 # (later)
│   ├── dashboard/            # data/ (placeholder models) + presentation/
│   ├── composer/
│   ├── calendar/
│   ├── social_accounts/
│   └── settings/
└── main.dart
```

Dependency rule: `features/*` may import `core/`; `core/` never imports
`features/`. Only `app/` knows about every feature.
