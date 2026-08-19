import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/utils/app_strings.dart';
import 'package:movix/features/auth/domain/entities/auth_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../datasources/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._remote, this._local);
  final SettingsRemoteDataSource _remote;
  final SettingsLocalDataSource _local;

  @override
  AppUser? getCurrentUser() {
    final user = _remote.getCurrentUser();
    if (user == null) return null;
    return AppUser(id: user.id, email: user.email, name: user.userMetadata?['name'] as String?);
  }

  @override
  Future<String> getRegion() => _local.getRegion();

  @override
  Future<void> setRegion(String regionCode) => _local.setRegion(regionCode);

  @override
  Future<Either<GenericException, void>> logout() async {
    try {
      await _remote.logout();
      return const Right(null);
    } on AuthException catch (exception) {
      return Left(GenericException(message: exception.message));
    } catch (_) {
      return const Left(GenericException(message: AppStrings.unexpectedError));
    }
  }
}