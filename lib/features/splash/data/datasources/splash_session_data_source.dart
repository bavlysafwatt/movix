import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SplashSessionDataSource {
  Future<bool> hasActiveSession();
}

class SplashSessionDataSourceImpl implements SplashSessionDataSource {
  const SplashSessionDataSourceImpl(this._client);

  final SupabaseClient _client;

  @override
  Future<bool> hasActiveSession() async {
    return _client.auth.currentSession != null;
  }
}
