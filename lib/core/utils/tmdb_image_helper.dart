import 'package:movix/core/api/end_points.dart';

class TmdbImageHelper {
  static String? poster(String? path, {String size = EndPoints.posterW500}) {
    if (path == null || path.isEmpty) return null;
    return '${EndPoints.imageBaseUrl}$size$path';
  }

  static String? backdrop(String? path, {String size = EndPoints.backdropW780}) {
    if (path == null || path.isEmpty) return null;
    return '${EndPoints.imageBaseUrl}$size$path';
  }

  static String? profile(String? path, {String size = EndPoints.profileW185}) {
    if (path == null || path.isEmpty) return null;
    return '${EndPoints.imageBaseUrl}$size$path';
  }
}