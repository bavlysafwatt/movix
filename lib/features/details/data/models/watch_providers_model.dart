import 'package:movix/features/details/domain/entities/watch_providers.dart';

class WatchProviderModel extends WatchProvider {
  const WatchProviderModel({required super.id, required super.name, super.logoPath});
  factory WatchProviderModel.fromJson(Map<String, dynamic> json) => WatchProviderModel(
    id: json['provider_id'] as int,
    name: json['provider_name'] as String? ?? '',
    logoPath: json['logo_path'] as String?,
  );
}

class WatchProvidersInfoModel extends WatchProvidersInfo {
  const WatchProvidersInfoModel({super.link, super.flatrate, super.rent, super.buy});

  factory WatchProvidersInfoModel.fromJson(Map<String, dynamic> json) {
    List<WatchProviderModel> parse(String key) =>
        (json[key] as List? ?? []).cast<Map<String, dynamic>>().map(WatchProviderModel.fromJson).toList();

    return WatchProvidersInfoModel(
      link: json['link'] as String?,
      flatrate: parse('flatrate'),
      rent: parse('rent'),
      buy: parse('buy'),
    );
  }
}