import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movix/features/details/domain/usecases/get_person_bundle.dart';

import 'person_details_state.dart';

class PersonDetailsCubit extends Cubit<PersonDetailsState> {
  PersonDetailsCubit(this._getPersonBundle) : super(PersonDetailsInitial());
  final GetPersonBundle _getPersonBundle;

  Future<void> load(int personId) async {
    emit(PersonDetailsLoading());
    final result = await _getPersonBundle(personId);
    if (isClosed) return;
    result.fold(
          (error) => emit(PersonDetailsError(message: error.message)),
          (bundle) => emit(PersonDetailsLoaded(details: bundle.details, filmography: bundle.filmography)),
    );
  }
}