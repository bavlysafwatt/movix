import 'package:movix/features/details/domain/entities/person_details.dart';

class PersonDetailsModel extends PersonDetails {
  const PersonDetailsModel({
    required super.id, required super.name, super.biography,
    super.profilePath, super.birthday, super.placeOfBirth, super.knownForDepartment,
  });

  factory PersonDetailsModel.fromJson(Map<String, dynamic> json) => PersonDetailsModel(
    id: json['id'] as int,
    name: json['name'] as String? ?? 'Unknown',
    biography: (json['biography'] as String?)?.isEmpty ?? true ? null : json['biography'] as String?,
    profilePath: json['profile_path'] as String?,
    birthday: json['birthday'] as String?,
    placeOfBirth: json['place_of_birth'] as String?,
    knownForDepartment: json['known_for_department'] as String?,
  );
}