import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Stream<User?> authStateChanges();
  Future<User> signInWithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._client, this._googleSignIn);

  final SupabaseClient _client;
  final GoogleSignIn _googleSignIn;

  @override
  Stream<User?> authStateChanges() {
    return _client.auth.onAuthStateChange.map((state) => state.session?.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleUser = await _googleSignIn.authenticate();

    const scopes = ['email', 'profile'];
    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
            await googleUser.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw const AuthException('No ID Token found.');
    }

    final response = await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );

    final user = response.user;
    if (user == null) throw const AuthException('Unable to sign in with Google.');
    return user;
  }
}