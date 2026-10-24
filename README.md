# PostFlow

Plan, schedule and publish social-media content across every platform.

> **Milestone:** Step 2 — authentication (sign up, log in, log out, forgot
> password) and user profiles, backed by Supabase. Social platforms,
> scheduling and publishing come in later milestones.

## 1. Supabase setup (once)

1. Create a project at [supabase.com](https://supabase.com/dashboard)
   (suggested name `postflow`, region close to your users).
2. Create the `profiles` table: open **SQL Editor**, paste the contents of
   `supabase/migrations/20261025000000_create_profiles.sql` and run it.
   (With the Supabase CLI: `supabase link` then `supabase db push`.)
3. **Authentication → Providers → Email**: keep Email enabled. "Confirm email"
   is on by default — the app handles both on and off.
4. **Project Settings → API Keys**: copy the Project URL and the
   publishable key (`sb_publishable_…`). A legacy anon key also works.

## 2. App setup

```bash
cp env.example.json env.json        # then paste your URL and key into env.json
flutter create --org com.postflow --project-name postflow --platforms android,ios,web .
flutter pub get
flutter run --dart-define-from-file=env.json
```

`env.json` is git-ignored — never commit real keys. Without it the app opens a
"Supabase is not configured" screen instead of crashing.

`flutter create .` only adds the missing platform folders; it does not
overwrite `lib/` or `test/`.

### Known limitations (Step 2)

- **Password reset links** open the Supabase project's Site URL. Setting a new
  password inside the app needs a deep link (Android intent filter + Supabase
  redirect URL), planned once the platform folders are committed.
- **Release APKs** need `<uses-permission android:name="android.permission.INTERNET"/>`
  in `android/app/src/main/AndroidManifest.xml`; Flutter only adds it to debug
  builds by default.

## Verification

GitHub Actions (`.github/workflows/flutter.yml`) runs on every push and pull
request: `pub get`, format check, `flutter analyze`, `flutter test` and a debug
APK build. Tests use in-memory fake repositories, so CI needs no Supabase
project or secrets.

No local Flutter? Run **Actions → Apply dart format** on your branch to format
the code, then **Actions → Flutter CI → Run workflow**.

## Project structure

```text
lib/
├── app/                      # App root, navigation shell, missing-config screen
├── core/                     # Shared, feature-agnostic code
│   ├── config/               # Build-time Supabase settings
│   ├── constants/            # App constants, spacing scale, platform metadata
│   ├── theme/                # Colors, light/dark themes, input styling
│   ├── utils/                # Dates, validators, initials
│   ├── services/             # (later) API clients, storage, schedulers
│   └── widgets/              # Logo, avatar, badges, placeholders
├── features/
│   ├── auth/                 # domain/ · data/ (Supabase) · presentation/
│   ├── profile/              # domain/ · data/ (Supabase) · presentation/
│   ├── dashboard/
│   ├── composer/
│   ├── calendar/
│   ├── social_accounts/
│   └── settings/
└── main.dart                 # Initializes Supabase and injects repositories
supabase/migrations/          # Database schema (SQL)
```

Dependency rules: `core/` never imports `features/`. Screens depend on the
`domain/` interfaces (`AuthRepository`, `ProfileRepository`); only `main.dart`
creates the Supabase implementations.
