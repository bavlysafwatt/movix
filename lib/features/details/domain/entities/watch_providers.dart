import 'package:equatable/equatable.dart';

class WatchProvider extends Equatable {
  const WatchProvider({required this.id, required this.name, this.logoPath});
  final int id;
  final String name;
  final String? logoPath;
  @override
  List<Object?> get props => [id, name, logoPath];
}

class WatchProvidersInfo extends Equatable {
  const WatchProvidersInfo({this.link, this.flatrate = const [], this.rent = const [], this.buy = const []});
  final String? link;
  final List<WatchProvider> flatrate;
  final List<WatchProvider> rent;
  final List<WatchProvider> buy;

  bool get isEmpty => flatrate.isEmpty && rent.isEmpty && buy.isEmpty;

  @override
  List<Object?> get props => [link, flatrate, rent, buy];
}