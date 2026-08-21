import 'package:equatable/equatable.dart';
import 'package:movix/features/details/domain/entities/person_details.dart';
import 'package:movix/features/home/domain/entities/movie.dart';

class PersonBundle extends Equatable {
  const PersonBundle({required this.details, required this.filmography});
  final PersonDetails details;
  final List<Movie> filmography;
  @override
  List<Object?> get props => [details, filmography];
}