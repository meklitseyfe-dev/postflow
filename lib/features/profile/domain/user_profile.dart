/// A row of the `profiles` table.
class UserProfile {
  const UserProfile({required this.id, this.fullName, this.avatarUrl});

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    fullName: json['full_name'] as String?,
    avatarUrl: json['avatar_url'] as String?,
  );

  final String id;
  final String? fullName;
  final String? avatarUrl;
}

/// A profile error with a message that is safe to show to the user.
class ProfileFailure implements Exception {
  const ProfileFailure(this.message);

  final String message;

  @override
  String toString() => 'ProfileFailure: $message';
}
