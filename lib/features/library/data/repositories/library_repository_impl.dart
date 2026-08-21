import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/utils/app_strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/library_item.dart';
import '../../domain/entities/library_item_status.dart';
import '../../domain/repositories/library_repository.dart';
import '../datasources/library_remote_data_source.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  const LibraryRepositoryImpl(this._remote);
  final LibraryRemoteDataSource _remote;

  @override
  Future<Either<GenericException, LibraryItemStatus>> getStatus({
    required int tmdbId,
    required String mediaType,
  }) {
    return _run(() async {
      final results = await Future.wait([
        _remote.isFavorite(tmdbId, mediaType),
        _remote.isInWatchlist(tmdbId, mediaType),
        _remote.isWatched(tmdbId, mediaType),
        _remote.getUserRating(tmdbId, mediaType),
      ]);
      return LibraryItemStatus(
        isFavorite: results[0] as bool,
        isInWatchlist: results[1] as bool,
        isWatched: results[2] as bool,
        userRating: results[3] as double?,
      );
    });
  }

  @override
  Future<Either<GenericException, void>> toggleFavorite(LibraryItem item, {required bool add}) =>
      _run(() => add ? _remote.addFavorite(item) : _remote.removeFavorite(item.tmdbId, item.mediaType));

  @override
  Future<Either<GenericException, void>> toggleWatchlist(LibraryItem item, {required bool add}) =>
      _run(() => add ? _remote.addWatchlist(item) : _remote.removeWatchlist(item.tmdbId, item.mediaType));

  @override
  Future<Either<GenericException, void>> toggleWatched({
    required int tmdbId,
    required String mediaType,
    required bool watched,
  }) => _run(() => watched ? _remote.markWatched(tmdbId, mediaType) : _remote.unmarkWatched(tmdbId, mediaType));

  @override
  Future<Either<GenericException, void>> rateItem({
    required int tmdbId,
    required String mediaType,
    required double rating,
  }) => _run(() => _remote.rateItem(tmdbId, mediaType, rating));

  Future<Either<GenericException, T>> _run<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on PostgrestException catch (e) {
      if (e.code == '23505') return const Left(ConflictException(message: 'Already saved to your library'));
      return Left(BadRequestException(message: e.message));
    } on AuthException catch (e) {
      return Left(UnauthorizedException(message: e.message));
    } on GenericException catch (e) {
      return Left(e);
    } catch (_) {
      return const Left(GenericException(message: AppStrings.unexpectedError));
    }
  }
}