import 'package:dartz/dartz.dart';
import 'package:movix/core/error/exceptions.dart';
import 'package:movix/core/utils/app_strings.dart';
import 'package:movix/features/library/domain/entities/library_rated_item.dart';
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
  Future<Either<GenericException, void>> toggleWatched(LibraryItem item, {required bool watched}) =>
      _run(() => watched ? _remote.markWatched(item) : _remote.unmarkWatched(item.tmdbId, item.mediaType));

  @override
  Future<Either<GenericException, void>> rateItem(LibraryRatedItem item) => _run(() => _remote.rateItem(item));

  @override
  Future<Either<GenericException, List<LibraryItem>>> getFavorites() => _run(() => _remote.getFavorites());

  @override
  Future<Either<GenericException, List<LibraryItem>>> getWatchlist() => _run(() => _remote.getWatchlist());

  @override
  Future<Either<GenericException, List<LibraryItem>>> getWatchedHistory() => _run(() => _remote.getWatchedHistory());

  @override
  Future<Either<GenericException, List<LibraryRatedItem>>> getRatedItems() => _run(() => _remote.getRatedItems());

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