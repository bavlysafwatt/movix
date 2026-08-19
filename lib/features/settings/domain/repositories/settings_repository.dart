import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/features/auth/domain/entities/auth_user.dart';

abstract class SettingsRepository {
  AppUser? getCurrentUser();
  Future<String> getRegion();
  Future<void> setRegion(String regionCode);
  Future<Either<GenericException, void>> logout();
}