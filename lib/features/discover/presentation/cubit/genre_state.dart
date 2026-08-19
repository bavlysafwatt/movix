import 'package:equatable/equatable.dart';
import 'package:movix/features/discover/domain/entities/genre.dart';

abstract class GenreState extends Equatable {
  const GenreState();
  @override
  List<Object?> get props => [];
}

class GenreInitial extends GenreState {}
class GenreLoading extends GenreState {}

class GenreSuccess extends GenreState {
  const GenreSuccess({required this.genres});
  final List<Genre> genres;
  @override
  List<Object?> get props => [genres];
}

class GenreError extends GenreState {
  const GenreError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}