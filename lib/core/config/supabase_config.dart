/// Supabase connection settings, supplied at build time:
///
/// ```bash
/// flutter run --dart-define-from-file=env.json
/// ```
///
/// See `env.example.json`. Never commit real keys.
abstract final class SupabaseConfig {
  static const String url = String.fromEnvironment('SUPABASE_URL');

  /// The project's publishable key (`sb_publishable_…`). The legacy anon key
  /// is accepted too, under either setting name.
  static const String publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
    defaultValue: String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  static bool get isConfigured => url.isNotEmpty && publishableKey.isNotEmpty;
}
