import 'package:movix/core/helpers/shared_pref_helper.dart';
import 'package:movix/core/utils/constants.dart';

abstract class SearchLocalDataSource {
  Future<List<String>> getRecentSearches();
  Future<void> saveRecentSearch(String query);
  Future<void> clearRecentSearches();
}

class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  const SearchLocalDataSourceImpl();
  static const _maxRecent = 10;

  @override
  Future<List<String>> getRecentSearches() async {
    return SharedPrefHelper.getStringList(key: Constants.recentSearchesKey) ?? const [];
  }

  @override
  Future<void> saveRecentSearch(String query) async {
    final current = await getRecentSearches();
    final deduped = [query, ...current.where((q) => q.toLowerCase() != query.toLowerCase())];
    await SharedPrefHelper.setData(
      key: Constants.recentSearchesKey,
      value: deduped.take(_maxRecent).toList(),
    );
  }

  @override
  Future<void> clearRecentSearches() async {
    await SharedPrefHelper.removeData(key: Constants.recentSearchesKey);
  }
}