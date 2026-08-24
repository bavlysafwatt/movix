import 'package:equatable/equatable.dart';
import 'package:movix/features/library/domain/entities/library_item.dart';

enum LibraryListKind { favorites, watchlist, watched }

abstract class LibraryListState extends Equatable {
  const LibraryListState();
  @override
  List<Object?> get props => [];
}

class LibraryListInitial extends LibraryListState {}
class LibraryListLoading extends LibraryListState {}

class LibraryListError extends LibraryListState {
  const LibraryListError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

class LibraryListLoaded extends LibraryListState {
  const LibraryListLoaded({required this.items, this.removingKeys = const {}});
  final List<LibraryItem> items;
  final Set<String> removingKeys;
  @override
  List<Object?> get props => [items, removingKeys];
}