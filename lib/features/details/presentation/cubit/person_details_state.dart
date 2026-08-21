import 'package:equatable/equatable.dart';
import 'package:movix/features/details/domain/entities/person_details.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

abstract class PersonDetailsState extends Equatable {
  const PersonDetailsState();
  @override
  List<Object?> get props => [];
}

class PersonDetailsInitial extends PersonDetailsState {}
class PersonDetailsLoading extends PersonDetailsState {}

class PersonDetailsError extends PersonDetailsState {
  const PersonDetailsError({required this.message});
  final String message;
  @override
  List<Object?> get props => [message];
}

class PersonDetailsLoaded extends PersonDetailsState {
  const PersonDetailsLoaded({required this.details, required this.filmography});
  final PersonDetails details;
  final List<Movie> filmography;
  @override
  List<Object?> get props => [details, filmography];
}