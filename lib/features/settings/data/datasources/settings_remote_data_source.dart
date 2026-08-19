import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SettingsRemoteDataSource {
  User? getCurrentUser();
  Future<void> logout();
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  const SettingsRemoteDataSourceImpl(this._client);
  final SupabaseClient _client;

  @override
  User? getCurrentUser() => _client.auth.currentUser;

  @override
  Future<void> logout() => _client.auth.signOut();
}