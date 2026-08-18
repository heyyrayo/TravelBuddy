class SupabaseConfig {
  const SupabaseConfig._();

  static const url = String.fromEnvironment(
    'SUPABASE_URL',
  );

  static const publishableKey = String.fromEnvironment(
    'SUPABASE_PUBLISHABLE_KEY',
  );

  static bool get isConfigured {
    return url.isNotEmpty && publishableKey.isNotEmpty;
  }

  static void validate() {
    if (!isConfigured) {
      throw StateError(
        'Supabase is not configured. '
        'Run Flutter with --dart-define=SUPABASE_URL=... '
        'and --dart-define=SUPABASE_PUBLISHABLE_KEY=...',
      );
    }
  }
}
