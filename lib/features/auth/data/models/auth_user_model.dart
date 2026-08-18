import 'package:movix/features/auth/domain/entities/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthUserModel extends AppUser {
  const AuthUserModel({required super.id, super.email, super.name});

  factory AuthUserModel.fromSupabaseUser(User user) {
    return AuthUserModel(
      id: user.id,
      email: user.email,
      name: user.userMetadata?['name'] as String?,
    );
  }
}