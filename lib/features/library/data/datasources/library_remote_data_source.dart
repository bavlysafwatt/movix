import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/library_item.dart';

abstract class LibraryRemoteDataSource {
  Future<bool> isFavorite(int tmdbId, String mediaType);
  Future<bool> isInWatchlist(int tmdbId, String mediaType);
  Future<bool> isWatched(int tmdbId, String mediaType);
  Future<double?> getUserRating(int tmdbId, String mediaType);
  Future<void> addFavorite(LibraryItem item);
  Future<void> removeFavorite(int tmdbId, String mediaType);
  Future<void> addWatchlist(LibraryItem item);
  Future<void> removeWatchlist(int tmdbId, String mediaType);
  Future<void> markWatched(int tmdbId, String mediaType);
  Future<void> unmarkWatched(int tmdbId, String mediaType);
  Future<void> rateItem(int tmdbId, String mediaType, double rating);
}

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  const LibraryRemoteDataSourceImpl(this._client);
  final SupabaseClient _client;
  String get _userId => _client.auth.currentUser!.id;

  Future<bool> _exists(String table, int tmdbId, String mediaType) async {
    final result = await _client
        .from(table)
        .select('id')
        .eq('user_id', _userId)
        .eq('tmdb_id', tmdbId)
        .eq('media_type', mediaType)
        .maybeSingle();
    return result != null;
  }

  @override
  Future<bool> isFavorite(int tmdbId, String mediaType) => _exists('favorites', tmdbId, mediaType);
  @override
  Future<bool> isInWatchlist(int tmdbId, String mediaType) => _exists('watchlist', tmdbId, mediaType);
  @override
  Future<bool> isWatched(int tmdbId, String mediaType) => _exists('watched_history', tmdbId, mediaType);

  @override
  Future<double?> getUserRating(int tmdbId, String mediaType) async {
    final result = await _client
        .from('user_ratings')
        .select('rating')
        .eq('user_id', _userId)
        .eq('tmdb_id', tmdbId)
        .eq('media_type', mediaType)
        .maybeSingle();
    return (result?['rating'] as num?)?.toDouble();
  }

  Map<String, dynamic> _payload(LibraryItem item) => {
    'user_id': _userId,
    'tmdb_id': item.tmdbId,
    'media_type': item.mediaType,
    'title': item.title,
    'poster_path': item.posterPath,
    'release_date': item.releaseDate,
  };

  @override
  Future<void> addFavorite(LibraryItem item) => _client.from('favorites').insert(_payload(item));
  @override
  Future<void> removeFavorite(int tmdbId, String mediaType) =>
      _client.from('favorites').delete().eq('user_id', _userId).eq('tmdb_id', tmdbId).eq('media_type', mediaType);

  @override
  Future<void> addWatchlist(LibraryItem item) => _client.from('watchlist').insert(_payload(item));
  @override
  Future<void> removeWatchlist(int tmdbId, String mediaType) =>
      _client.from('watchlist').delete().eq('user_id', _userId).eq('tmdb_id', tmdbId).eq('media_type', mediaType);

  @override
  Future<void> markWatched(int tmdbId, String mediaType) =>
      _client.from('watched_history').insert({'user_id': _userId, 'tmdb_id': tmdbId, 'media_type': mediaType});
  @override
  Future<void> unmarkWatched(int tmdbId, String mediaType) => _client
      .from('watched_history')
      .delete()
      .eq('user_id', _userId)
      .eq('tmdb_id', tmdbId)
      .eq('media_type', mediaType);

  @override
  Future<void> rateItem(int tmdbId, String mediaType, double rating) => _client.from('user_ratings').upsert(
    {'user_id': _userId, 'tmdb_id': tmdbId, 'media_type': mediaType, 'rating': rating},
    onConflict: 'user_id,tmdb_id,media_type',
  );
}