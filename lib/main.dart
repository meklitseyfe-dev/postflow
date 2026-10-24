import 'package:flutter/material.dart';
import 'package:postflow/app/missing_config_app.dart';
import 'package:postflow/app/postflow_app.dart';
import 'package:postflow/core/config/supabase_config.dart';
import 'package:postflow/features/auth/data/supabase_auth_repository.dart';
import 'package:postflow/features/profile/data/supabase_profile_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!SupabaseConfig.isConfigured) {
    runApp(const MissingConfigApp());
    return;
  }

  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );
  final client = Supabase.instance.client;

  runApp(
    PostFlowApp(
      authRepository: SupabaseAuthRepository(client),
      profileRepository: SupabaseProfileRepository(client),
    ),
  );
}
