import 'package:postflow/features/profile/domain/user_profile.dart';

/// Reads and updates the signed-in user's profile.
///
/// Methods throw `ProfileFailure` with a user-facing message on error.
abstract interface class ProfileRepository {
  /// Returns `null` when no profile row exists yet.
  Future<UserProfile?> fetchProfile(String userId);

  Future<UserProfile> updateFullName(String userId, String fullName);
}
