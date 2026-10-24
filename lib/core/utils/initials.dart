/// Builds short initials for avatars, e.g. "Ada Lovelace" → "AL".
abstract final class Initials {
  static final RegExp _whitespace = RegExp(r'\s+');

  static String from({String? name, String? email}) {
    final cleanName = name?.trim() ?? '';
    if (cleanName.isNotEmpty) {
      final parts = cleanName.split(_whitespace);
      final buffer = StringBuffer(_firstChar(parts.first));
      if (parts.length > 1) buffer.write(_firstChar(parts.last));
      return buffer.toString().toUpperCase();
    }
    final cleanEmail = email?.trim() ?? '';
    if (cleanEmail.isNotEmpty) return _firstChar(cleanEmail).toUpperCase();
    return '?';
  }

  static String _firstChar(String value) =>
      String.fromCharCode(value.runes.first);
}
