import 'package:postflow/features/profile/domain/profile_repository.dart';
import 'package:postflow/features/profile/domain/user_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;

/// [ProfileRepository] backed by the Supabase `profiles` table.
class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository(this._client);

  final supa.SupabaseClient _client;

  static const String _table = 'profiles';

  @override
  Future<UserProfile?> fetchProfile(String userId) async {
    try {
      final row = await _client
          .from(_table)
          .select()
          .eq('id', userId)
          .maybeSingle();
      return row == null ? null : UserProfile.fromJson(row);
    } on supa.PostgrestException catch (error) {
      throw ProfileFailure(error.message);
    } on Exception {
      throw const ProfileFailure(
        'Could not load your profile. Check your connection and try again.',
      );
    }
  }

  @override
  Future<UserProfile> updateFullName(String userId, String fullName) async {
    try {
      // Upsert so users created before the profiles trigger still work.
      final row = await _client
          .from(_table)
          .upsert({'id': userId, 'full_name': fullName})
          .select()
          .single();
      return UserProfile.fromJson(row);
    } on supa.PostgrestException catch (error) {
      throw ProfileFailure(error.message);
    } on Exception {
      throw const ProfileFailure(
        'Could not save your profile. Check your connection and try again.',
      );
    }
  }
}
