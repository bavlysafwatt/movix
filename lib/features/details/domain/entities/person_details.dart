import 'package:equatable/equatable.dart';

class PersonDetails extends Equatable {
  const PersonDetails({
    required this.id,
    required this.name,
    this.biography,
    this.profilePath,
    this.birthday,
    this.placeOfBirth,
    this.knownForDepartment,
  });
  final int id;
  final String name;
  final String? biography;
  final String? profilePath;
  final String? birthday;
  final String? placeOfBirth;
  final String? knownForDepartment;
  @override
  List<Object?> get props => [id, name, biography, profilePath, birthday, placeOfBirth, knownForDepartment];
}