import 'package:equatable/equatable.dart';
import 'package:movix/features/details/domain/entities/episode.dart';

abstract class SeasonDetailsState extends Equatable {
  const SeasonDetailsState();
  @override
  List<Object?> get props => [];
}

class SeasonDetailsInitial extends SeasonDetailsState {}
class SeasonDetailsLoading extends SeasonDetailsState {}

class SeasonDetailsError extends SeasonDetailsState {
  const SeasonDetailsError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

class SeasonDetailsLoaded extends SeasonDetailsState {
  const SeasonDetailsLoaded({required this.season});
  final SeasonDetails season;
  @override
  List<Object?> get props => [season];
}