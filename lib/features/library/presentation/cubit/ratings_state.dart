import 'package:equatable/equatable.dart';
import 'package:movix/features/library/domain/entities/library_rated_item.dart';

abstract class RatingsState extends Equatable {
  const RatingsState();
  @override
  List<Object?> get props => [];
}
class RatingsInitial extends RatingsState {}
class RatingsLoading extends RatingsState {}
class RatingsError extends RatingsState {
  const RatingsError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}
class RatingsLoaded extends RatingsState {
  const RatingsLoaded({required this.items});
  final List<LibraryRatedItem> items;
  @override
  List<Object?> get props => [items];
}